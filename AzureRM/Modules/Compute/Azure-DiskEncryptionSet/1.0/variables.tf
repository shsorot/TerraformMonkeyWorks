variable "name" {
  type        = string
  description = "(Required) The name of the Disk Encryption Set. Changing this forces a new resource to be created."
}

# variable "resource_group_name" {
#   type = string
#   description = "(Required) Specifies the name of the Resource Group where the Disk Encryption Set should exist. Changing this forces a new resource to be created."
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
  description = "(Required) Specifies the Azure Region where the Disk Encryption Set exists. Changing this forces a new resource to be created."
}

variable "key_vault_key" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    key_vault_name      = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Required) Specifies the URL to a Key Vault Key (either from a Key Vault Key, or the Key URL for the Key Vault Secret)."
}

variable "key_vault_keys" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "identity" {
  type = object({
    type = string # (Required) The Type of Identity which should be used for this Disk Encryption Set. At this time the only possible value is SystemAssigned.
  })
  default = {
    type = "SystemAssigned"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "inherit_tags" {
  type    = bool
  default = false
}

