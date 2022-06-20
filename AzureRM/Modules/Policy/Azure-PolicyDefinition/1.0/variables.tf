variable "name" {
  type        = string
  description = "(Required) The name of the policy definition. Changing this forces a new resource to be created."
}

variable "policy_type" {
  type        = string
  description = "(Required) The policy type. Possible values are BuiltIn, Custom and NotSpecified. Changing this forces a new resource to be created."
  default     = "Custom"
}

variable "mode" {
  type        = string
  description = <<EOM
  (Required) The policy mode that allows you to specify which resource types will be evaluated. 
  Possible values are All, Indexed, Microsoft.ContainerService.Data, Microsoft.CustomerLockbox.Data,
   Microsoft.DataCatalog.Data, Microsoft.KeyVault.Data, Microsoft.Kubernetes.Data, 
   Microsoft.MachineLearningServices.Data, Microsoft.Network.Data and Microsoft.Synapse.Data.
  EOM
}

variable "display_name" {
  type        = string
  description = "(Required) The display name of the policy definition."
}

variable "description" {
  type        = string
  description = "(Optional) The description of the policy definition."
  default     = null
}
variable "management_group" {
  type = object({
    id   = optional(string)
    tags = optional(string)
    name = optional(string)
  })
  description = "(Optional) The name of the Management Group where this policy should be defined. Changing this forces a new resource to be created."
  default     = null
}

variable "management_groups" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of module Azure-ManagementGroup. Used to lookup MG properties using Tags"
  default     = {}
}

variable "policy_rule" {
  type = object({
    json = optional(string) # JSON string denoting the policy rule body.
    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8
  })
  description = "(Optional) The policy rule for the policy definition. This is a JSON string representing the rule that contains an if and a then block."
  default     = null
}

variable "metadata" {
  type = object({
    json = optional(string) # JSON string denoting the metadata body.
    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8
  })
  description = "(Optional) The metadata for the policy definition. This is a JSON string representing additional metadata that should be stored with the policy definition."
  default     = null
}
variable "parameters" {
  type = object({
    json = optional(string) # JSON string denoting the parameters body.
    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8
  })
  description = "(Optional) Parameters for the policy definition. This field is a JSON string that allows you to parameterize your policy definition."
  default     = null
}

