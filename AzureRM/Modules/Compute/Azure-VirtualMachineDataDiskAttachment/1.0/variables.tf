variable "virtual_machine" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Virtual machine to which the managed disk will be assigned."
}

variable "virtual_machines" {
  type = map(object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  }))
  default     = {}
  description = "(Optional) Output of module Azure-VirtualMachine or Azure-WindowsVirtualMachine or Azure-LinuxVirtualMachine"
}

variable "managed_disk" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of an existing Managed Disk which should be attached. Changing this forces a new resource to be created."
}


variable "managed_disks" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of module Azure-ManagedDisk."
  default     = {}
}

variable "lun" {
  type        = number
  description = "(Required) The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine. Changing this forces a new resource to be created."
}

variable "caching" {
  type        = string
  description = "(Required) Specifies the caching requirements for this Data Disk. Possible values include None, ReadOnly and ReadWrite."
  default     = "None"
}

variable "create_option" {
  type        = string
  description = "(Optional) The Create Option of the Data Disk, such as Empty or Attach. Defaults to Attach. Changing this forces a new resource to be created."
  default     = "Attach"
}

variable "write_accelerator_enabled" {
  type        = bool
  description = "(Optional) Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium_LRS managed disks with no caching and M-Series VMs. Defaults to false."
  default     = false
}

