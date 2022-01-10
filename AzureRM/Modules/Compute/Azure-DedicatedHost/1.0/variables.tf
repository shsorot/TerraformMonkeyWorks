variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Dedicated Host. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure location where the Dedicated Host exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

variable "dedicated_host_group" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = <<EOT
    (Required) Specifies the ID of the Dedicated Host Group 
    where the Dedicated Host should exist. 
    Changing this forces a new resource to be created.
    EOT
  default     = null
}

variable "dedicated_host_groups" {
  type = map(object({
    id                    = string
    platform_fault_domain = optional(string)
  }))
  description = "(Optional) Output of module Azure-DedicatedHostGroup."
  default     = {}
}

variable "platform_fault_domain" {
  type        = number
  description = <<EOT
    (Required) The number of fault domains that the Dedicated Host spans. 
    Changing this forces a new resource to be created. 
    If null, the output from source host group is used instead.
    EOT
}

variable "auto_replace_on_failure" {
  type        = bool
  description = <<EOT
    (Optional) Should the Dedicated Host automatically be replaced in 
    case of a Hardware Failure? Defaults to true.
    EOT
  default     = false
}

variable "sku_name" {
  type        = string
  description = <<EOT
    (Required) Specify the sku name of the Dedicated Host. 
    Possible values are DSv3-Type1, DSv3-Type2, DSv4-Type1, 
    ESv3-Type1, ESv3-Type2,FSv2-Type2, DASv4-Type1, DCSv2-Type1, 
    DDSv4-Type1, DSv3-Type1, DSv3-Type2, DSv3-Type3, DSv4-Type1, 
    EASv4-Type1, EDSv4-Type1, ESv3-Type1, ESv3-Type2, ESv3-Type3, 
    ESv4-Type1, FSv2-Type2, FSv2-Type3, LSv2-Type1, MS-Type1, 
    MSm-Type1, MSmv2-Type1, MSv2-Type1, NVASv4-Type1, 
    and NVSv3-Type1. Changing this forces a new resource to be created.
    EOT
}

variable "license_type" {
  type        = string
  description = <<EOT
    (Optional) Specifies the software license type that will be applied to the 
    VMs deployed on the Dedicated Host. Possible values are None, 
    Windows_Server_Hybrid and Windows_Server_Perpetual. Defaults to None.
    EOT
  default     = null
}

