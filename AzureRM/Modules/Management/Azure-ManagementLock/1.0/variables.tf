variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Management Lock. Changing this forces a new resource to be created."
}

variable "scope" {
  type        = string
  description = "(Required) Specifies the scope at which the Management Lock should be created. Changing this forces a new resource to be created."
}

variable "lock_level" {
  type        = string
  description = "(Required) Specifies the scope at which the Management Lock should be created. Changing this forces a new resource to be created."
}

variable "notes" {
  type        = string
  description = " (Optional) Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created."
  default     = null
}

