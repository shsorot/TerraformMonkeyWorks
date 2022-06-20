variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) Name of the automation Account.)"
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

variable "sku_name" {
  description = "(Optional) The SKU name of the account - only Basic is supported at this time."
  type        = string
  default     = "Basic"
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

variable "identity" {
  type = object({
    type = string # (Required) The type of identity used for this Automation Account. Possible values are SystemAssigned, UserAssigned and SystemAssigned, UserAssigned.
    identity = optional(list(object({
      id                  = optional(string) #(Optional) The ID of the User Assigned Identity which should be assigned to this Automation Account.
      name                = optional(string) #(Optional) The name of the User Assigned Identity which should be assigned to this Automation Account. Used to lookup ID using data blocks
      resource_group_name = optional(string) #(Optional) Resource group name to be used with the property 'name'. If null, core resource group will be used.
      key                 = optional(string) #(Optional) Terraform object key used to lookup ID using output of module Azure-UserAssignedIdentity supplied to variable 'user_assigned_identities'
    })))
  })
  description = <<EOF
      id                  = #(Optional) The ID of the User Assigned Identity which should be assigned to this Automation Account.
      name                = #(Optional) The name of the User Assigned Identity which should be assigned to this Automation Account. Used to lookup ID using data blocks
      resource_group_name = #(Optional) Resource group name to be used with the property 'name'. If null, core resource group will be used.
      key                 = #(Optional) Terraform object key used to lookup ID using output of module Azure-UserAssignedIdentity supplied to variable 'user_assigned_identities'
  EOF
  default     = null
}

variable "user_assigned_identities" {
  type = map(object({
    id = optional(string) #(Optional) The property id from output of module Azure-UserAssignedIdentity
  }))
  description = "(Optional)Output of module Azure-UserAssignedIdentity. Used to lookup ID using Terraform Object Keys"
  default     = {}
}