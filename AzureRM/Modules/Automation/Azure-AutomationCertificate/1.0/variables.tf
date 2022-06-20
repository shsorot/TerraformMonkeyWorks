# variable "location" {
#   description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
#   type        = string
# }

variable "name" {
  description = "(Required) Name of the Automation account certificate"
  type        = string
}

variable "automation_account" {
  type = object({
    id                  = optional(string) # (Optional)Resource ID of existing automation account. 
    name                = optional(string) # (Optional)Name of the automation account to be used for fetching resource ID using data blocks, when property'id' is not available.
    resource_group_name = optional(string) # (Optional)Resource group name to be used by data block to lookup automation account when 'name' is used.  Mandatory when using 'name'
    key                 = optional(string) # (Optional)Terraform Object Key to lookup automation account details from output of module Azure-AutomationAccount
  })
  description = <<EOF
  (Required) The name of the automation account in which the Certificate is created. Changing this forces a new resource to be created.
    id                  = # (Optional)Resource ID of existing automation account. 
    name                = # (Optional)Name of the automation account to be used for fetching resource ID using data blocks, when property'id' is not available.
    resource_group_name = # (Optional)Resource group name to be used by data block to lookup automation account when 'name' is used.  Mandatory when using 'name'
    key                 = # (Optional)Terraform Object Key to lookup automation account details from output of module Azure-AutomationAccount
  EOF
}

variable "automation_accounts" {
  type = map(object({
    id       = string # (Optional)Resource ID of existing automation account from output of module Azure-AutomationAccount
    name     = string # (Optional)Name of the automation account existing automation account from output of module Azure-AutomationAccount
    location = string # (Optional)Location of existing automation account from output of module Azure-AutomationAccount
  }))
  description = "(Optional)Output of module Azure-AutomationAccount. Used to lookup automation account details using Terraform Object Keys"
  default     = {}
}

variable "base64" {
  type = object({
    raw  = optional(string) # Base64 encoded certificate content
    file = optional(string) # relative file path to the Terraform root code calling this module. File must be a PFX format certificate.
  })
  description = <<EOF
    (Required) Base64 encoded value of the certificate. Changing this forces a new resource to be created.
    raw  = # Base64 encoded certificate content
    file = # relative file path to the Terraform root code calling this module. File must be a PFX format certificate.
  EOF
}

variable "description" {
  type        = string
  description = "(Optional) The description of this Automation Certificate."
  default     = null
}

variable "exportable" {
  type        = bool
  description = "(Optional) The is exportable flag of the certificate.Defaults to false."
  default     = false
}