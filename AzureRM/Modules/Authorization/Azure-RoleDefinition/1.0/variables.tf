variable "role_definition_id" {
  type        = string
  description = "(Optional) A unique UUID/GUID which identifies this role - one will be generated if not specified. Changing this forces a new resource to be created."
  default     = null
}

variable "name" {
  type        = string
  description = "(Required) The name of the Role Definition. Changing this forces a new resource to be created."
}

variable "scope" {
  type        = string
  description = "(Required) The scope at which the Role Definition applies too, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM. It is recommended to use the first entry of the assignable_scopes. Changing this forces a new resource to be created."
}

variable "description" {
  type        = string
  description = "(Optional) A description of the Role Definition."
  default     = null
}

variable "permissions" {
  type = object({
    actions          = optional(list(string)) # (Optional) One or more Allowed Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read
    data_actions     = optional(list(string)) # (Optional) One or more Allowed Data Actions, such as *, Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read
    not_actions      = optional(list(string)) # (Optional) One or more Disallowed Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read
    not_data_actions = optional(list(string)) # (Optional) One or more Disallowed Data Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read
  })
  description = "value"
}

variable "assignable_scopes" {
  type        = list(string)
  description = "(Optional) One or more assignable scopes for this Role Definition, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM."
  default     = null
}