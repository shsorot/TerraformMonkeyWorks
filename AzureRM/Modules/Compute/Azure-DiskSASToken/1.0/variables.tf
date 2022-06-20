variable "managed_disk" {
  type = object({
    id                  = optional(string)  # (Optional)Resource ID of the managed disk.
    name                = optional(string)  # (Optional)Name of the managed disk, used for ID lookp using data block
    resource_group_name = optional(string)  # (Optional)Resource Group name, must be specified when 'name' is used.
    key                 = optional(string)  # (Optional) Terraform object key used for lookup of ID from output of module Azure-ManagedDisk
  })
  description = "(Required) The ID of an existing Managed Disk which should be attached. Changing this forces a new resource to be created."
}


variable "managed_disks" {
  type = map(object({
    id = string # (Required) Resource ID of the managed disk.
  }))
  description = "(Optional) Output of module Azure-ManagedDisk."
  default     = {}
}


variable "duration_in_seconds"{
  type = number
  description = "(Required) The duration for which the export should be allowed. Should be between 30 & 4294967295 seconds."
  validation  {
    condition = var.duration_in_seconds >= 30 && var.duration_in_seconds <= 4294967295
    error_message = "value of duration_in_seconds must be between 30 & 4294967295 seconds"
  }
}


variable "access_level"{
  type = string
  description = "Required) The level of access required on the disk. Supported are Read, Write."
  validation {
    condition = can(regex("^(Read,Write)$",var.access_level))
    error_message = "value of access_level must be 'Read' or 'Write'"
  }
  default = "Read"
}