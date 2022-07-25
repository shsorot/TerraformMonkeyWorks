variable "name" {
  description = "Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created"
  type        = string
}
# variable "resource_group_name" {
#     description =   "Required) The name of the resource group in which to create the Bastion Host."
#     type        =   string
# }

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
  description = "(Required) Specifies the supported Azure location where the resource exists.If Null, resource group location is used instead."
  type        = string
  default     = null
}

# Added in provider > 3.xx.xx
variable "copy_paste_enabled"{
  type = bool
  description = "(Optional) Is Copy/Paste feature enabled for the Bastion Host. Defaults to true."
  default = true
}

# Added in provider > 3.xx.xx
variable "file_copy_enabled"{
  type = bool
  description = "(Optional) Is File Copy enabled for the Bastion Host. Defaults to false. Only supported when 'sku' is 'Standard' "
  default = false
}

# Added in provider > 3.xx.xx
variable "sku"{
  type = string
  description = "(Optional) The SKU of the bastion host. Accepted values are Basic and Standard"
  default = "Basic"
}

# Added in provider > 3.xx.xx
variable "ip_connect_enabled"{
  type = bool
  description  = "(Optional) is IP connect feature enabled for the bastion host. Defaults to false"
  default = false
}

# Added in provider > 3.xx.xx
variable "scale_units"{
  type = number
  description = "(Optional) The number of scale units with which to provision the bastion host. Possible values are between 2 and 50. Defaults to 2. For SKU basic, this is always 2."
  default = 2
}

# Added in provider > 3.xx.xx
variable "shareable_link_enabled"{
  type = bool
  description = "(Optional) Is Shareable link feature enabled for the bastion host. Defaults to false. Only supported when sku is 'Standard'"
  default = false
}

# Added in provider > 3.xx.xx
variable "tunneling_enabled"{
  type = bool
  description = "(Optional) Is Tunneling feature enabled for the Bastion Host. Defaults to false. Only supported when SKU is 'Standard'"
  default = false
}

variable "ip_configuration_name" {
  type    = string
  default = "ip_configuration"
}


variable "subnet" {
  description = "(Required) Reference to a Virtual Network in which this Bastion Host subnet will be  created."
  type = object({
    virtual_network_name = optional(string) # (Optional) Name of an existing virtual network to create the subnet "AzureBastionSubnet in"
    virtual_network_key  = optional(string) # (Optional) Resource group of the existing virtual network. If null, lookup will be attempted with bastion host resource group
    resource_group_name  = optional(string) # (Optional) Key value used to lookup virtual network details from output of module Azure-VirtualNetwork(2.0
    address_prefixes     = list(string)     # Address prefix range to be used for this subnet
  })
}

variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_network_tag'"
  type = map(object({
    id                    = string # Resource ID of the virtual Network
    name                  = string # Name of the Virtual Network
    resource_group_name   = string # Resource Group of the virtual network
    subnet = map(object({
      id = string
    }))
  }))
  default = {}
}

variable "public_ip_address" {
  description = "(Required) Reference to a Public IP Address to create & associate with this Bastion Host."
  type = object({
    name                = optional(string)  # (Optional) Name of an non-existing Public IP address
    resource_group_name = optional(string)  # (Optional) Resource Group to create the public IP address in. If empty, Bastion host resource group will be used for lookup
  })
}


variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

