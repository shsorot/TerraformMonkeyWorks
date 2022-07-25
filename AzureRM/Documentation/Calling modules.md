 # How are the modules called 

Lets take a look at the sample file Workloads->Infrastructure-Code->1.0->resource_group.tf

variable "ResourceGroups" {
  default = {}
}

module "Landscape-Resource-Groups" {
  source               = "../../../AzureRM/Modules/Resources/Azure-ResourceGroup/1.0"
  for_each             = var.ResourceGroups
  name                 = each.value.name == null ? each.key : each.value.name
  location             = each.value.location
  management_lock_name = try(each.value.management_lock_name, null)
  lock_level           = try(each.value.lock_level, null)
  notes                = try(each.value.notes, null)
  tags                 = try(each.value.tags, local.tags)
}

output "ResourceGroups" {
  value = module.Landscape-Resource-Groups
}


The variables for this module call will be passed as map(object), with a specific key for each object which signifies all the properties encapsulated for that resource.

ResourceGroups = {
  "network-rg" = {
    name     = "network-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Network"
    }
  },
  "application-rg" = {
    name     = "application-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Application"
    }
  }
}

example: for Key = "network-rg", the corresponding object will be used to provision a resource group of name "network-rg" in location "North Europe". The key can be any ascii string and does not necessarily have to be the name of the resource. Automated approach may even generate a unique GUID to ensure that all the keys in the answerfile are unique.

The map(object) approach ensures that the output of module "Landscape-Resource-Groups" is addressable using the key.
example: module.Landscape-Resource-Groups["network-rg"].[<property exposed by output.tf within module directory>]
This allows you to pass the output of this module to another module and specifying a key which can be used to pick up the desired output pack exposed by the developer. This will be explained in detail below.


The modules can also be called with different providers.
example :

module "Landscape-Resource-Groups-Provider1" {
  source               = "../../../AzureRM/Modules/Resources/Azure-ResourceGroup/1.0"
  provider             = { azurerm = <provider1 alias>}
  for_each             = var.ResourceGroups
  name                 = each.value.name == null ? each.key : each.value.name
  location             = each.value.location
  management_lock_name = try(each.value.management_lock_name, null)
  lock_level           = try(each.value.lock_level, null)
  notes                = try(each.value.notes, null)
  tags                 = try(each.value.tags, local.tags)
}

module "Landscape-Resource-Groups-Provider2" {
  source               = "../../../AzureRM/Modules/Resources/Azure-ResourceGroup/1.0"
  provider             = { azurerm = <provider2 alias>}
  for_each             = var.ResourceGroups
  name                 = each.value.name == null ? each.key : each.value.name
  location             = each.value.location
  management_lock_name = try(each.value.management_lock_name, null)
  lock_level           = try(each.value.lock_level, null)
  notes                = try(each.value.notes, null)
  tags                 = try(each.value.tags, local.tags)
}

In this case, both modules will operate on different provider definitions which could be anything from small parameter updates to completely different tenants and subscriptions.

Note: Due to limitation in terraform, currently provider names cannot be passed as variables or made dynamic. It is also not possible to define providers within Modules by passing subscription ID as a variable. (https://www.terraform.io/language/modules/develop/providers) . If you have a requirment where you wish to maintain a single module definition while managing multiple environments ( aks DRY code configuration), consider investigating "Terragrunt" (https://terragrunt.gruntwork.io/)



# Module dependency

Let us consider another example of a module for Proximity placement group(PPG)
PPG has a dependency on ResourceGroup, as evident from the module call in sample file Workloads->Infrastructure-Code->1.0->compute.tf:68


variable "ProximityPlacementGroups" {
  default = {}
}

module "Landscape-ProximityPlacement-Groups" {
  source          = "../../../AzureRM/Modules/Compute/Azure-ProximityPlacementGroup/1.0"
  for_each        = var.ProximityPlacementGroups
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}

output "ProximityPlacementGroups" {
  value = module.Landscape-ProximityPlacement-Groups
}


You can clearly notice that the output of module Landscape-Resource-Groups is being passed to the module via the variable "resource_groups" as evident by the plural noun of the variable.

The variable file section/content for a PPG will be as below


ResourceGroups = {
  "application-rg" = {
    name     = "application-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Network"
    }
  }
}
ProximityPlacementGroups = {
  sapppg01 = {
    name = "sapppg01"
    resource_group = { key = "application-rg" }
    location = "North Europe"
  }
}

You can clearly see that instead of using the variable resource_group_name as specified in the API (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/proximity_placement_group), we are using an object instead of string.

      resource_group = { key = "application-rg" }
Essentially, this translates to the module using the output of module Landscape-Resource-Groups and extracting all the details about the resource group from the output of the module. In this case, the module "Landscape-ProximityPlacement-Groups" uses the properties "location" and "tags" from the source. In case you did not specify the 'location', the module will use the location of the resource group. In case you wish to inherit tags from the resource groups, the variable "inherit_tags" will cause the module to apply any tags in the variable "tags" plus the tags from the parent resource group.
This interlinked reference serves two purpose.
  1. If you accidently specified a key that is not provisioned in this code, terraform plan will throw an error stating that that the variable "resource_groups" does not contains the key
  2. This ensures that terraform will always execute the resource group module/s first and subsequently execute the depenency.
  3. For a complex chain of dependency , example Resource Groups -> Proximity Placment Group -> Availability Set -> Virtual Machines    
                                                              |-> Virtual Network -> Virtual Subnet -> Virtual NIC --^        , the interlinked modules will ensure correct execution of code at the correct place.

It is possible that the parent resource group might have been created in a different state file but the link is provided to you. You can use the resource "terraform_remote_state" to read the remote state and extact the outputs. You can then pass the output of that state file into your module as a dependency. This allows DevOps admins to maintain control of provisioning specific core resources within their own team, while delegating child resources to respective function owners.

It is also possible that the parent resource ( in this case . resource group ) was never created using terraform and/or is being kept out of scope of IaaCS.
To address this issue, a mechanism has been implemented as well. Pls refer to AzureRM->Documenation->VariablesLayout.md on how this is done in detail.
From a module point of view, you would pass the name and location of the resource group as below

ProximityPlacementGroups = {
  sapppg01 = {
    name = "sapppg01"
    resource_group = { name = "application-rg" }
    location = "North Europe"
  }
}

note the difference, instead of key, we are passing the name. Terraform code will perform a data block lookup and fetch information from Azure. If this resource does not exists, terraform plan will error out and inform the Engineer.

Another example : Availability Set in sample file Workloads->Infrastructure-Code->1.0->compute.tf:26
variable "AvailabilitySets" {
  default = {}
}


module "Landscape-Availability-Sets" {
  source                       = "../../../AzureRM/Modules/Compute/Azure-AvailabilitySet/1.0"
  for_each                     = var.AvailabilitySets
  name                         = each.value.name == null ? each.key : each.value.name

  resource_group               = each.value.resource_group
  location                     = try(each.value.location, null)
  platform_fault_domain_count  = try(each.value.platform_fault_domain_count, 2)
  platform_update_domain_count = try(each.value.platform_update_domain_count, 5)
  proximity_placement_group    = try(each.value.proximity_placement_group, null)
  managed                      = try(each.value.managed, null)
  tags                         = try(each.value.tags, local.tags)
  inherit_tags                 = try(each.value.inherit_tags, false)
  proximity_placement_groups   = module.Landscape-ProximityPlacement-Groups
  resource_groups              = module.Landscape-Resource-Groups
}

output "AvailabilitySets" {
  value = module.Landscape-Availability-Sets
}

You can see that Availability set depends on Resource Group and Proximity placement group. 
If you inspect the module code, you will find that Resource groups are mandatory and Proximity placmement groups are optional.

So lets take below cases here
  1. We are provisioning RG and PPG before AVS and wish to attach PPG to AVS
      sample code for variable"
      AvailabilitySets = {
                  avset1 = {
                    name = "app-avset1"
                    resource_group = { key = "application-rg"}
                    location = "North Europe"
                    managed = true
                    proximity_placement_group = { key = "sapppg01"}
                  }
        }
      Module code will use the keys to fetch the output of RG and PPG modules, and extract all the exposed variables to use within it's own code.Errors are notified in the plan stage

  2. We already have a RG provisioned and we do not wish to add PPG to AV Set      
      AvailabilitySets = {
                  avset1 = {
                    name = "app-avset1"
                    resource_group = { name = "application-rg"}
                    location = "North Europe"
                    managed = true
                  }
        }
      Module code will lookup resource group using data block and fetch all the properties it needs. Errors are notified in the plan stage

  3. We already have a RG and PPG provisioned before hand and wish to add the PPG to the AVS. We have been provided with only the PPG name.
    PPG exists in a different resource group as the AVS
      AvailabilitySets = {
                  avset1 = {
                    name = "app-avset1"
                    resource_group = { name = "application-rg"}
                    location = "North Europe"
                    managed = true
                    proximity_placement_group = { name = "sapppg01", resource_group_name = "ppg-rg" }
                  }
        }
      In this case, Module code will use the resource group and name of the PPG to perform a data lookup in Azure and fetch all the information it needs. Errors are notified in the plan stage

    4. We already have a RG and PPG provisioned before hand and wish to add the PPG to the AVS. We have been provided with the PPG resource ID.
      AvailabilitySets = {
                  avset1 = {
                    name = "app-avset1"
                    resource_group = { name = "application-rg"}
                    location = "North Europe"
                    managed = true
                    proximity_placement_group = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Compute/proximityPlacementGroups/example-ppg" }
                  }
        }
        No conversion or calculations are needed. Module code will use the ID and use it directly in the azurerm_availability_set block. No checks are performed and any errors are only notified during apply stage.

  
As you can see, multiple options are provided to allow greatest flexibility to a System administrator to work around the various operations limitations.


Note: Certain resources in azure are self-referencial in nature. Example : azurerm_firewall_rules, where they can refer to another firewall rule that exists. A module in Terraform cannot call upon it's own output, hence as a result, only the properties like "id", "name","resource_group_name" are enabled.
For details, please refer to README.md at AzureRM->Modules->Network-Firewall->Azure-FirewallPolicy->1.0->README.MD

