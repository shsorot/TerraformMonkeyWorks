variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

# variable "resource_group_name" {
#   type = string
#   description = " (Required) The name of the resource group in which to create the Recovery Services Vault. Changing this forces a new resource to be created."
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
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "name" {
  description = "(Required) Specifies the name of the Recovery Services Vault. Changing this forces a new resource to be created."
  type        = string
}

variable "soft_delete_enabled" {
  type        = bool
  description = "(Optional) Is soft delete enable for this Vault? Defaults to true."
  default     = true
}

variable "sku" {
  type        = string
  description = "(Required) Sets the vault's SKU. Possible values include: Standard, RS0"
  default     = "Standard"
}

variable "identity_type" {
  type        = string
  description = "(Required) The Type of Identity which should be used for this Recovery Services Vault. At this time the only possible value is SystemAssigned"
  default     = "SystemAssigned"
}

