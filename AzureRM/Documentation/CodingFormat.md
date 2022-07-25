
# Module layout
Each resource type is converted to a module based on example below :
--> For AzureRM provider , within Resource Category "Automation" having a provider "azurerm_automation_account" as per documentation : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account , the module is organized in the below folder structure
          --> root
                |-> Azurerm
                      |-> Automation 
                            |-> Azure-AutomationAccount
                                 |-> 1.0 (Can be different)
                                      |-> main.tf                       : terraform file containing language specific options, like enabling experimental features
                                      |-> local.tf                      : All local variables, computation, data block lookups go here.
                                      |-> variables.tf                  : Define all your variables here
                                      |-> output.tf                     : Define your output variables herein
                                      |-> azurerm_automation_account.tf : Code for resource provider block goes here. In case module uses multiple providers, each provider will exist in sepererate file to allow cleaner debugging
                                      \-> README.md                     : Readme file generated from variables.tf and terraform-docs

A module can contain multiple resources as well.
Example: For the module Azurerm\Resources\Azure-ResourceGroup\1.0, you will find that it contains two resource files as exhibited below
          --> root
                |-> Azurerm
                      |-> Resources 
                            |-> Azure-ResourceGroup
                                 |-> 1.0 (Can be different)
                                      |-> main.tf                       : terraform file containing language specific options, like enabling experimental features
                                      |-> local.tf                      : All local variables, computation, data block lookups go here.
                                      |-> variables.tf                  : Define all your variables here
                                      |-> output.tf                     : Define your output variables herein
                                      |-> azurerm_resource_group.tf     : Main resource file for deploying/configuring resource group
                                      |-> azurerm_management_lock.tf    : Additional resource added to this module to allow adding locks to resource groups.
                                      \-> README.md                     : Readme file generated from variables.tf and terraform-docs

While azurerm_management_lock.tf can exist as it's own module ( and it does in AzureRM->Management->Azure-ManagementLock->1.0), bundling them together eases the life of a developer as most locks are applied at the time of resource group provisions.

A Module can also exist in multiple versions. Note that Terraform does not allows user defined modules to exist as versions unless they are uploaded to Terraform registry, this is a current approach to maintain multiple version, where each version provides a slightly different functionality.
Example: For Resource AzureRM->Network-Azure-VirtualNetwork, there are two version in the directory. 
  a.> 1.0 : This Module version only provisions a Virtual network and properties that are exposed via azurerm_virtual_network
  b.> 2.0 : This module provisions not only a Virtual network, but offers the facility to provision subnets and attach route tables & network security groups during creation time.

  Version 1.0 can be technically called as "deprecated", but it exists where devops administrators may only want to expose this version to their developers and limit the blast radius of any change.

Example2: For resource, AzureRM->Network->Azure-NetworkInterface, there are two versions in the directory,
  a.> 1.0 : This module version only provisions a Virtual Network NIC and properties that are exposed viaa azurerm_virtual_network
  b.> 2.0 : This module version not only provisions a virtual network nic, but allow offers options to attach an Application security group, Assign a network security group and also add the NIC to a backend address pool , quite similar to the experience offered by Azure portal

  Version 1.0 exists in case ASG and NSG association is being managed by Azure policy , which will cause a revert-remediate loop in production each time the state execution is run. 1.0 also exists in case DevOps administrators want to maintain a fine grained control on what to assign to the NICS's via different modules. Of course, the resources for ASG, NSG and Backend pool taggings exists seperately as standalone modules and can be called as desired.







  # Variables layout.

  To explain this concept, we shall use the example of Availability Sets and specify a sample module code below. 

resource "azurerm_availability_set" "this" {
  name                         = var.name
  location                     = local.location
  resource_group_name          = local.resource_group_name
  proximity_placement_group_id = local.proximity_placement_group_id
  managed                      = var.managed
  tags                         = local.tags
}

  We have only selected a few parameters for the modules for the explaination.
  You can see that the core resource dependency for AV Sets is a Resource Group. You can also note that we are supplying the Resource group name and Location as a local variable. 

  If you notice in the "local.tf" for the module, there is quite a lot of computation going on to generate the local values. 

data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "this" {
  count = var.resource_group.name == null ? 0 : 1
  name  = var.resource_group.name
}

#Create the local variables
locals {
  client_id               = data.azurerm_client_config.current.client_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  subscription_id         = data.azurerm_subscription.current.subscription_id
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}

What is happening here is based on the options provided in the variables.tf file ( selection pasted below )

variable "resource_group" {
  type = object({
    name = optional(string) # Name of the resource group
    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"
  })
  description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
}

variable "resource_groups" {
  type = map(object({
    id       = optional(string)
    location = optional(string)
    tags     = optional(map(string))
    name     = optional(string)
  }))
  description = <<EOF
   (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"
    id       = # ID of the resource group
    location = # Location of the resource group
    tags     = # List of Azure tags applied to resource group
    name     = # Name of the resource group
  EOF
  default     = {}
}

If you are provisioning the parent resource group in the same code , you want to preserve the depeendency chain, ie the parent is provisioned/configured before you act on the child/dependent  resource. Terraform automatically does this when you reference an output of another data block ,resource block or module into your current code.
Here, if you pass the Key 