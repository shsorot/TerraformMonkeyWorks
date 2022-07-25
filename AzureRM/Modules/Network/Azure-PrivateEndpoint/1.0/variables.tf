variable "name" {
  description = "(Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
  type        = string
}

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

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "subnet" {
  description = "(Required) Reference to a subnet in which this Bastion Host has been created."
  type = object({
    id                   = optional(string)
    name                 = optional(string)
    virtual_network_name = optional(string)
    resource_group_name  = optional(string)
    key                  = optional(string)
    virtual_network_key  = optional(string)
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

variable "dns_zones" {
  description = "(Optional) Output object from module Azure-PrivateDNSZone, to be used with 'dns_zone_tag' and 'dns_zone_id'"
  type = map(object({
    id = string # Resource ID of the DNS Zone
  }))
  default = {}
}


variable "private_dns_zone_group" {
  type = object({
    name = string                    # (Required) Specifies the Name of the Private DNS Zone Group. Changing this forces a new private_dns_zone_group resource to be created.
    private_dns_zone = list(object({ # (Required) Specifies the list of Private DNS Zones to include within the private_dns_zone_group.
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    }))
  })
  default = null
}

variable "private_service_connection" {
  type = object({
    name       = string # (Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created.
    is_enabled = bool   #  (Required) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created.
    # NOTE:
    # If you are trying to connect the Private Endpoint to a remote resource without having the correct RBAC permissions on the remote resource set this value to true.
    # private_connection_resource_id = optional(string) # (Optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private_connection_resource_id or private_connection_resource_alias must be specified. Changing this forces a new resource to be created. For a web app or function app slot, the parent web app should be used in this field instead of a reference to the slot itself.
    private_connection_resource = optional(object({
      id                  = optional(string) # (Optional) The ID of the resource to attach this private endpoint to.
      resource_group_name = optional(string) # (Optional) The Resource group where the connection resource is located.
      baseResourceType    = optional(string) # (Optional) The type of the resource.
      name                = optional(string) # Name of the resource
    }))
    private_connection_resource_alias = optional(string)       # (Optional) The Service Alias of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private_connection_resource_id or private_connection_resource_alias must be specified. Changing this forces a new resource to be created.
    subresource_names                 = optional(list(string)) # (Optional) A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id. Changing this forces a new resource to be created.
    # Refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint#subresource_names for categories
    request_message = optional(string) # (Optional) (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The request message can be a maximum of 140 characters in length. Only valid if is_manual_connection is set to true.
  })
  default = null
}