variable "name" {
  type        = string
  description = "(Required) Specifies the name of the EventHub Authorization Rule resource. Changing this forces a new resource to be created."
}

variable "namespace_name" {
  type        = string
  description = "(Required) Specifies the name of the EventHub Authorization Rule resource. Changing this forces a new resource to be created."
}

variable "namespace_name" {
  type        = string
  description = "(Required) Specifies the name of the EventHub. Changing this forces a new resource to be created."
}

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

variable "listen" {
  type        = bool
  description = "(Optional) Grants listen access to this this Authorization Rule. Defaults to false."
  default     = false
}

variable "send" {
  type        = bool
  description = "(Optional) Grants send access to this this Authorization Rule. Defaults to false."
  default     = false
}

variable "manage" {
  type        = bool
  description = "(Optional) Grants manage access to this this Authorization Rule. When this property is true - both listen and send must be too. Defaults to false."
  default     = false
}