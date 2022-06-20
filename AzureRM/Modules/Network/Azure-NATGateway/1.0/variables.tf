variable "name" {
  type        = string
  description = "(Required) Specifies the name of the NAT Gateway. Changing this forces a new resource to be created."
}

# variable "resource_group_name" {
#   type = string
#   description = "(Required) Specifies the name of the Resource Group in which the NAT Gateway should exist. Changing this forces a new resource to be created."
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
  type        = string
  description = "(Optional) Specifies the supported Azure location where the NAT Gateway should exist. Changing this forces a new resource to be created. If Null, Resource Group location is used instead."
  default     = null
}

variable "idle_timeout_in_minutes" {
  type        = number
  description = "Optional) The idle timeout which should be used in minutes. Defaults to 4."
  default     = 4
}

variable "sku_name" {
  type        = string
  description = "(Optional) The SKU which should be used. At this time the only supported value is Standard. Defaults to Standard."
  default     = "Standard"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource. Changing this forces a new resource to be created."
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "zones" {
  type        = list(number)
  description = "(Optional) A list of availability zones where the NAT Gateway should be provisioned. Changing this forces a new resource to be created."
  default     = null
}

