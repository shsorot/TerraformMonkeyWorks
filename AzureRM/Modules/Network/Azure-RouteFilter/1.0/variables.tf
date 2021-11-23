variable "name" {
  description = "(Required) Specifies the name of the Public IP resource . Changing this forces a new resource to be created."
  type        = string
}
# variable "resource_group_name" {
#     description = "(Required) The name of the resource group in which to create the public ip."
#     type        = string
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
  type    = bool
  default = false
}

variable "rule" {
  type = object({
    name        = string #  (Required) The name of the route filter rule.
    rule_type   = string #  (Required) The rule type of the rule. The only possible value is Community.
    communities = string #  (Required) The collection for bgp community values to filter on. e.g. ['12076:5010','12076:5020'].
    access      = string #  (Required) The access type of the rule. The only possible value is Allow.
  })
}