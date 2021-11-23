variable "name" {
  type        = string
  description = "(Required) Specifies the name of the EventHub Namespace resource. Changing this forces a new resource to be created."
}

# variable "resource_group_name" {
#   type = string
#   description = "(Required) The name of the resource group in which the EventHub Namespace exists. Changing this forces a new resource to be created."
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

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.If null, Resource group location is used."
  default     = null
}


variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "inherit_tags" {
  type    = bool
  default = false
}

variable "sku" {
  type        = string
  description = "(Required) Defines which tier to use. Valid options are Basic, Standard, and Premium. Please not that setting this field to Premium will force the creation of a new resource and also requires setting zone_redundant to true."
  default     = null
}

variable "capacity" {
  type        = number
  description = "(Optional) Specifies the Capacity / Throughput Units for a Standard SKU namespace. Default capacity has a maximum of 20, but can be increased in blocks of 20 on a committed purchase basis."
  default     = null
}

variable "auto_inflate_enabled" {
  type        = bool
  description = "(Optional) Is Auto Inflate enabled for the EventHub Namespace?"
  default     = null
}

variable "dedicated_cluster" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = " (Optional) Specifies the ID of the EventHub Dedicated Cluster where this Namespace should created. Changing this forces a new resource to be created."
  default     = null
}

variable "dedicated_clusters" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of module Azure-EventHubCluster"
  default     = {}
}

variable "identity" {
  type = object({
    type = string #   (Required) The Type of Identity which should be used for this EventHub Namespace. At this time the only possible value is SystemAssigned.
  })
  description = "(Optional) An identity block as defined."
  default     = null
}


variable "maximum_throughput_units" {
  type        = number
  description = "(Optional) Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20."
  default     = null
}

variable "zone_redundant" {
  type        = string
  description = "(Optional) Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). Changing this forces a new resource to be created. Defaults to false."
  default     = null
}

variable "network_rulesets" {
  type = object({
    default_action                 = string         #(Required) The default action to take when a rule is not matched. Possible values are Allow and Deny. Defaults to Deny.
    trusted_service_access_enabled = optional(bool) #(Optional) Whether Trusted Microsoft Services are allowed to bypass firewall.
    virtual_network_rule = optional(list(object({
      subnet = object({
        id                   = optional(string)
        name                 = optional(string)
        virtual_network_name = optional(string)
        resource_group_name  = optional(string)
        tag                  = optional(string)
        virtual_network_tag  = optional(string)
      })
    })))
    ip_rule = optional(list(object({
      ip_mask = string
      action  = optional(string)
    })))
  })

}


variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_network_tag'"
  type = map(object({
    id   = string # Resource ID of the virtual Network
    name = string # Name of the Virtual Network
    subnet = map(object({
      id = optional(string)
    }))
  }))
  default = {}
}

