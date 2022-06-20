variable "virtual_machine" {
  type = object({
    id                  = optional(string),
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Machine. Changing this forces a new resource to be created"
}


variable "virtual_machines" {
  type = map(object({
    id = optional(string),
  }))
}

variable "active_directory_domain" {
  type        = string
  description = "The name of the Active Directory domain to join"
}

variable "ou_path" {
  type        = string
  description = "An organizational unit (OU) within an Active Directory to place computers"
  default     = null
}

variable "active_directory_username" {
  type        = string
  description = "The username of an account with permissions to bind machines to the Active Directory Domain"
  sensitive   = true
}

variable "active_directory_password" {
  type        = string
  description = "The password of the account with permissions to bind machines to the Active Directory Domain"
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
