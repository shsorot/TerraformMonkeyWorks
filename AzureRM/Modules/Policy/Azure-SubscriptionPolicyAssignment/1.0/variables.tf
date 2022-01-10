variable "name" {
  type        = string
  description = "(Required) The name of the policy definition. Changing this forces a new resource to be created."
}



variable "display_name" {
  type        = string
  description = "(Required) The display name of the policy definition."
}

variable "enforce" {
  type        = bool
  description = "(Optional) Specifies if this Policy should be enforced or not?"
  default     = null
}

variable "description" {
  type        = string
  description = "(Optional) The description of the policy definition."
  default     = null
}
variable "subscription_id" {
  type        = string
  description = "(Required) The ID of the Subscription where this Policy Assignment should be created. Changing this forces a new Policy Assignment to be created."
}

variable "management_groups" {
  type = map(object({
    id = optional(string)
  }))
  default = null
}

variable "policy_definition" {
  type = object({
    id                 = optional(string) # Resource ID of the Policy or Set 
    definition_tag     = optional(string) # Tag of the policy definition, used to fetch ID from the output of module Azure-PolicyDefinition.Cannot be used in combination with definition_set_tag
    definition_set_tag = optional(string) # Tag of the policy set definition, used to fetch ID from the output of module Azure-PolicySetDefinition. Cannot be used in combination with definition_tag.
  })
  description = "(Optional) The policy rule for the policy definition. This is a JSON string representing the rule that contains an if and a then block."
  default     = null
}

variable "policy_definitions" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "policy_definition_sets" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "identity" {
  type = object({
    type = string
  })
  description = "(Optional) The Type of Managed Identity which should be added to this Policy Definition. The only possible value is SystemAssigned."
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

variable "not_scopes" {
  type        = list(string)
  description = "(Optional) Specifies a list of Resource Scopes (for example a Subscription, or a Resource Group) within this Management Group which are excluded from this Policy."
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

