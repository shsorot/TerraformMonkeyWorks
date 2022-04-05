# variable "resource_group_name" {
#   type  = string
#   description = "(Required) The name of the resource group in which to create the virtual network."
# }

variable "resource_group" {
  type = object({
    name = optional(string)
    tag  = optional(string)
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
  description = "(Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Tags"
  default     = {}
}

variable "name" {
  type        = string
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  description = "(Required) Boolean value to denote if if should inherit tags from parent resource group."
  default     = false
}

variable "address_space" {
  type        = list(string)
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
}

variable "location" {
  type        = string
  description = <<HELP
  (Optional) The location/region where the virtual network is created. Changing this forces a new resource to be created. 
  If Null, location from resource group is used.
  HELP
  default     = null
}

variable "bgp_community" {
  type        = string
  description = <<HELP
  (Optional) The BGP community attribute in format <as-number>:<community-value>.
  The as-number segment is the Microsoft ASN, which is always 12076 for now.
  HELP
  default     = null
}

variable "ddos_protection_plan" {
  type = object({
    id                  = optional(string) # Specify ID if you have one.
    name                = optional(string) # Name of the DDOS ID. To be used with Resource Group(Optional, local.resource_group_name is used if null) & subscription_id( current is used if not specified )
    resource_group_name = optional(string) # Resource Group to lookup the DDOS using name. If Null, the 
    subscription_id     = optional(string) # If the resource is located in a different subscription, specify this along with name and resource group name.
    tag                 = optional(string) # If using an output of module Azure-NetworkDDOSProtectionPlan, use this value to perform a lookup instead
  })
  description = "(Optional) The DDoS Protection Plan object. If provided, DDOS protection plan will be enabled."
  default     = null
}


variable "dns_servers" {
  type        = list(string)
  description = "(Optional) List of IP addresses of DNS servers"
  default     = null
}

variable "subnet" {
  type = list(object({
    name                                           = string                 # (Required) The name of the subnet. Changing this forces a new resource to be created.
    address_prefixes                               = list(string)           # (Required) The address prefixes to use for the subnet in the format ["cidrblock"]
    enforce_private_link_endpoint_network_policies = optional(bool)         # Refer to link : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#enforce_private_link_endpoint_network_policies
    enforce_private_link_service_network_policies  = optional(bool)         # Refer to link : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#enforce_private_link_service_network_policies
    service_endpoints                              = optional(list(string)) # Refer to link : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#service_endpoints
    service_endpoint_policy_ids                    = optional(string)       # (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
    delegation = optional(object({
      name = optional(string) # A name for this delegation.
      service_delegation = object({
        name    = string                 # A value from the list at :https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#name
        actions = optional(list(string)) # A list value from the list at :https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#actions
      })
    }))
    security_group = optional(object({       # (Optional)  Custom object describing NSG details to be attached to the subnet
      id                  = optional(string) # (Optional)  Resource ID of the NSG if available
      name                = optional(string) # (Optional)  Name of the NSG
      resource_group_name = optional(string) # (Optional)  Resource Group where NSG is placed. If Name is provided, will be used to lookup
      tag                 = optional(string) # When using the ouput of module Azure-NetworkSecuritygroup, use this to perform a lookup.
    }))
    route_table = optional(object({          # (Optional)  Custom object describing route_table details to be attached to the subnet
      id                  = optional(string) # (Optional)  Resource ID of the route_table if available
      name                = optional(string) # (Optional)  Name of the Route table
      resource_group_name = optional(string) # (Optional)  Resource Group where Route table is placed. If Name is provided, will be used to lookup
      tag                 = optional(string) # When using the ouput of module Azure-RouteTable, use this to perform a lookup.
    }))
  }))
  description = "(Optional) List of objects describing subnet details to be provisioned."
  default     = null
}


// Section to declare variables as output of other modules

variable "ddos_protection_plans" {
  type = map(object({
    id                  = string
    virtual_network_ids = optional(list(string))
  }))
  description = "(Optional) Output of module Azure-NetworkDDOSProtectionPlan. Used to lookup in case resource ID is not available."
  default     = null
}


variable "network_security_groups" {
  type = map(object({
    id = string
  }))
  description = "(Optional) Output of module Azure-NetworkSecurityGroup. Used to lookup resource ID using tags."
  default     = {}
}

variable "route_tables" {
  type = map(object({
    id = string
  }))
  description = "(Optional) Output of module Azure-RouteTable. Used to lookup resource ID using tags."
  default     = {}
} 