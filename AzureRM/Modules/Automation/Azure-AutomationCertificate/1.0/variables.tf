# variable "location" {
#   description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
#   type        = string
# }

variable "name" {
  description = "(Required) Name of the Automation account certificate"
  type        = string
}

# variable "resource_group_name" {
#     description = "(Required) The name of the resource group where to create the resource."
#     type        = string
# }

# variable "resource_group" {
#   type = object({
#     name = optional(string)
#     tag  = optional(string)
#   })
#   description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
# }

# variable "resource_groups" {
#   type = map(object({
#     id       = optional(string)
#     location = optional(string)
#     tags     = optional(map(string))
#     name     = optional(string)
#   }))
#   description = "(Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Tags"
#   default     = {}
# }

variable "automation_account"{
  type = object({
    id   = optional(string)                # Resource ID of existing automation account
    name = optional(string)                # Required if id and tag are null
    resource_group_name = optional(string) # Required if Name is specified
    tag  = optional(string)                # Tag to lookup automation account details from output of module azure-automationaccount
  })
}

variable "automation_accounts"{
  type = map(object({
    id  = string
    name = string
    location = string
  }))
  default = {}
}

variable "base64"{
  type = object({
    raw = optional(string) # Base64 encoded certificate content
    file = optional(string)# relative file path to the Terraform root code calling this module. File must be a PFX format certificate.
  })
}

variable "description"{
  type = string
  description = "(Optional) The description of this Automation Certificate."
  default = null
}

variable "exportable"{
  type = bool
  description = "(Optional) The is exportable flag of the certificate.Defaults to false."
  default = false
}