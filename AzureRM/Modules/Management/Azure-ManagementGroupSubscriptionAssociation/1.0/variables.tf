variable "management_group" {
  type = object({
    id   = optional(string)
    name = optional(string)
    tag  = optional(string)
  })
  description = "(Optional) The ID of the Parent Management Group. Changing this forces a new resource to be created."
  default     = null
}

variable "management_groups" {
  type = map(object({
    id = optional(string) # Output of the module Azure-ManagementGroup
  }))
  default = {}
}

variable "subscription_id" {
  type        = string
  description = "(Optional) The ID of the Subscription to be associated with the Management Group. Changing this forces a new Management to be created."
  default     = null
}

