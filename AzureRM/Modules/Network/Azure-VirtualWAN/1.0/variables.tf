variable "name" {
  description = "(Required) Specifies the name of the Virtual WAN. Changing this forces a new resource to be created."
  type        = string
}

# variable "resource_group_name" {
#     description = "(Required) The name of the resource group in which to create the Application Security Group."
#     type = string
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
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
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


variable "disable_vpn_encryption" {
  type        = bool
  description = "(Required) Specifies the name of the Virtual WAN. Changing this forces a new resource to be created."
  default     = false
}

variable "allow_branch_to_branch_traffic" {
  type        = bool
  description = " (Optional) Boolean flag to specify whether branch to branch traffic is allowed. Defaults to true."
  default     = false
}

variable "office365_local_breakout_category" {
  type        = string
  description = "(Optional) Specifies the Office365 local breakout category. Possible values include: Optimize, OptimizeAndAllow, All, None. Defaults to None."
  default     = "None"
}

variable "type" {
  type        = string
  description = "(Optional) Specifies the Virtual WAN type. Possible Values include: Basic and Standard. Defaults to Standard."
  default     = "Standard"
}