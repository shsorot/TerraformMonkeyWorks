variable "name" {
  type        = string
  description = "(Optional) A unique UUID/GUID for this Role Assignment - one will be generated if not specified. Changing this forces a new resource to be created."
  default     = null
}

variable "scope" {
  type        = string
  description = "(Required) The scope at which the Role Assignment applies to, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM, or /providers/Microsoft.Management/managementGroups/myMG. Changing this forces a new resource to be created."
}

variable "role_definition" {
  type = object({
    id    = optional(string) # (Optional) The Scoped-ID of the Role Definition. 
    name  = optional(string) # (Optional) The name of the role definition to be used for lookup when id is unknown.
    scope = optional(string) # Subscription scope where role definition is used. If null, current scope is used. To be used with 'name' only.
    key   = optional(string) # To be used for ID lookup from output of module Azure-RoleDefinition.
  })
  description = "(Optional) The Scoped-ID of the Role Definition. Changing this forces a new resource to be created. Conflicts with role_definition_name."
}

variable "role_definitions" {
  type = map(object({
    id = string # Resource ID of the role definition.
  }))
  description = "(Optional) A map of object output module Azure-RoleDefinition. Used by variable 'role_definition'"
  default     = {}
}

variable "role_definition_name" {
  type        = string
  description = "(Optional) The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role_definition_id."
  default     = null
}

variable "principal_id" {
  type        = string
  description = "(Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created."
}

variable "condition" {
  type        = string
  description = "(Optional) The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created."
  default     = null
}

variable "condition_version" {
  type        = string
  description = "(Optional) The version of the condition. Possible values are 1.0 or 2.0. Changing this forces a new resource to be created."
  default     = null
}

variable "delegated_managed_identity_resource_id" {
  type        = string
  description = "(Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created."
  default     = null
}

variable "description" {
  type        = string
  description = "(Optional) The description for this Role Assignment. Changing this forces a new resource to be created."
  default     = null
}

variable "skip_service_principal_aad_check" {
  type        = bool
  description = "(Optional) If the principal_id is a newly provisioned Service Principal set this value to true to skip the Azure Active Directory check which may fail due to replication lag. This argument is only valid if the principal_id is a Service Principal identity. If it is not a Service Principal identity it will cause the role assignment to fail. Defaults to false."
  default     = false
}