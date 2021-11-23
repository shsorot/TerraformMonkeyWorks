variable "name" {
  type        = string
  description = "(Required) The name of the policy set definition. Changing this forces a new resource to be created."
}

variable "policy_type" {
  type        = string
  description = "(Required) The policy set type. Possible values are BuiltIn or Custom. Changing this forces a new resource to be created."
  default     = "Custom"
}

variable "display_name" {
  type        = string
  description = "(Required) The display name of the policy set definition."
}

variable "description" {
  type        = string
  description = "(Optional) The description of the policy set definition."
  default     = null
}
variable "management_group_name" {
  type        = string
  description = "(Optional) The name of the Management Group where this policy set definition should be defined. Changing this forces a new resource to be created."
  default     = null
}

variable "policy_definition_reference" {
  type = list(object({
    policy_definition = object({
      id  = optional(string) # Resource ID of the policy definition. Useful for pre-existing policies.
      tag = optional(string) # Tag of the policy definition, used to lookup policy ID from output of module Azure-PolicyDefinition
    })
    parameter_values = optional(object({
      json = optional(string) # JSON string denoting the parameter body.
      file = optional(string) # Relative path of the file containing parameter JSON stored as UTF-8
    }))
    reference_id       = optional(string)       # (Optional) A unique ID within this policy set definition for this policy definition reference.
    policy_group_names = optional(list(string)) #  (Optional) A list of names of the policy definition groups that this policy definition reference belongs to.
  }))
  default = []
}

variable "policy_definition_group" {
  type = list(object({
    name                            = string           # (Required) The name of this policy definition group.
    display_name                    = optional(string) # (Optional) The display name of this policy definition group.
    category                        = optional(string) # (Optional) The category of this policy definition group.
    description                     = optional(string) # (Optional) The description of this policy definition group.
    additional_metadata_resource_id = optional(string) # (Optional) The ID of a resource that contains additional metadata about this policy definition group.
  }))
  description = "(Optional) The metadata for the policy definition. This is a JSON string representing additional metadata that should be stored with the policy definition."
  default     = []
}

variable "policy_definitions" {
  type = map(object({
    id = string
  }))
  description = "(Optional)Output of module Azure-PolicyDefinition."
  default     = {}
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

