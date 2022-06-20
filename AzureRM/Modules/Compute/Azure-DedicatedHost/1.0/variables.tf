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
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "dedicated_host_group" {
  type = object({
    id                  = optional(string) # (Optional) Resource ID of the dedicated host group where this dedicated host will be created.
    name                = optional(string) # (Optional) Name of the dedicated host group to be used for id lookup using data block
    resource_group_name = optional(string) # (Optional) Resource group name where the dedicated host group exists. Must be used when 'name' is being used.
    key                 = optional(string) # (Optional) Use the Terraform object key to lookup the id from output of module Azure-DedicatedHostGroup
  })
  description = <<EOT
    (Required) Specifies the ID of the Dedicated Host Group where the Dedicated Host should exist. Changing this forces a new resource to be created.
    id                  = # (Optional) Resource ID of the dedicated host group where this dedicated host will be created.
    name                = # (Optional) Name of the dedicated host group to be used for id lookup using data block
    resource_group_name = # (Optional) Resource group name where the dedicated host group exists. Must be used when 'name' is being used.
    key                 = # (Optional) Use the Terraform object key to lookup the id from output of module Azure-DedicatedHostGroup
    EOT
  default     = null
}

variable "dedicated_host_groups" {
  type = map(object({
    id                          = string           # (Mandatory) Resource ID of the dedicated host group.
    platform_fault_domain_count = optional(number) # (Optional) Sub property of dedicatedd host group
  }))
  description = <<EOF
  (Optional) Output of module Azure-DedicatedHostGroup.
    id                          = # (Mandatory) Resource ID of the dedicated host group.
    platform_fault_domain_count = # (Optional) Sub property of dedicatedd host group
  EOF
  default     = {}
}

variable "platform_fault_domain" {
  type        = number
  description = <<EOT
    (Required) The number of fault domains that the Dedicated Host spans. Changing this forces a new resource to be created. 
    If null, and 'dedicated_host_group' is specified, the platform_fault_domain_count will be retrieved from the dedicated host group.
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
  validation {
    condition     = contains(["DSv3-Type1", "DSv3-Type2", "DSv4-Type1", "ESv3-Type1", "ESv3-Type2", "FSv2-Type2", "DASv4-Type1", "DCSv2-Type1", "DDSv4-Type1", "DSv3-Type1", "DSv3-Type2", "DSv3-Type3", "DSv3-Type4", "DSv4-Type1", "EASv4-Type1", "EDSv4-Type1", "ESv3-Type1", "ESv3-Type2", "ESv3-Type3", "ESv3-Type4", "ESv4-Type1", "FSv2-Type2", "FSv2-Type3", "LSv2-Type1", "MS-Type1", "MSm-Type1", "MSmv2-Type1", "MSv2-Type1", "NVASv4-Type1", "NVSv3-Type1"],var.sku_name)
    error_message = "Valid values for sku_name are: DSv3-Type1, DSv3-Type2, DSv4-Type1, ESv3-Type1, ESv3-Type2,FSv2-Type2, DASv4-Type1, DCSv2-Type1, DDSv4-Type1, DSv3-Type1, DSv3-Type2, DSv3-Type3, DSv3-Type4, DSv4-Type1, EASv4-Type1, EDSv4-Type1, ESv3-Type1, ESv3-Type2, ESv3-Type3, ESv3-Type4, ESv4-Type1, FSv2-Type2, FSv2-Type3, LSv2-Type1, MS-Type1, MSm-Type1, MSmv2-Type1, MSv2-Type1, NVASv4-Type1, and NVSv3-Type1."
  }
}

variable "license_type" {
  type        = string
  description = <<EOT
    (Optional) Specifies the software license type that will be applied to the 
    VMs deployed on the Dedicated Host. Possible values are None, 
    Windows_Server_Hybrid and Windows_Server_Perpetual. Defaults to None.
    EOT
  default     = "None"
  validation {
    condition     = contains(["None", "Windows_Server_Hybrid", "Windows_Server_Perpetual"],var.license_type)
    error_message = "Valid values for sku_name are: None, Windows_Server_Hybrid, and Windows_Server_Perpetual."
  }
}
