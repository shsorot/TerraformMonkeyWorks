variable "name" {
  type        = string
  description = "(Optional) The name or UUID for this Management Group, which needs to be unique across your tenant. A new UUID will be generated if not provided. Changing this forces a new resource to be created."
}

# Deprecated from provider > 3.0.0
# variable "group_id" {
#   type        = string
#   description = "(Optional) The name or UUID for this Management Group, which needs to be unique across your tenant. A new UUID will be generated if not provided. Changing this forces a new resource to be created."
#   default     = null
# }

variable "display_name" {
  type        = string
  description = " (Optional) A friendly name for this Management Group. If not specified, this will be the same as the name."
  default     = null
}

variable "parent_management_group" {
  type = object({
    id   = optional(string)
    name = optional(string)
    tag  = optional(string)
  })
  description = "(Optional) The ID of the Parent Management Group. Changing this forces a new resource to be created."
  default     = null
}

variable "management_groups" {
  type = object({
    id = optional(string) # Output of the module Azure-ManagementGroup
  })
  default = {}
}

variable "subscription_ids" {
  type        = list(string)
  description = "(Optional) A list of Subscription GUIDs which should be assigned to the Management Group."
  default     = []
}

