variable "tags" {
  type    = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default = {}
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

#standalone code addition for locking resource groups

variable "management_lock_name" {
  description = "Logical name of the management lock"
  type        = string
  default     = ""
}

variable "lock_level" {
  description = <<HELP
    (Required) Specifies the Level to be used for this Lock. Possible values are CanNotDelete and ReadOnly. 
    Changing this forces a new resource to be created."
    HELP
  default     = null
}

variable "notes" {
  description = "(Optional) Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created."
  default     = null
}

