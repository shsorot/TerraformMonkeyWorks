variable "name" {
  type        = string
  description = "(Required) Specifies the name of the image. Changing this forces a new resource to be created."
}

# variable "resource_group_name" {
#   type = string
#   description = "(Required) Specifies the name of the Resource Group where the Disk Encryption Set should exist. Changing this forces a new resource to be created."
# }

variable "resource_group" {
  type = object({
    name = optional(string) # Name of the resource group
    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"
  })
  description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
}

variable "resource_groups" {
  type = map(object({
    id       = optional(string)
    location = optional(string)
    tags     = optional(map(string))
    name     = optional(string)
  }))
  description = <<EOF
   (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"
    id       = # ID of the resource group
    location = # Location of the resource group
    tags     = # List of Azure tags applied to resource group
    name     = # Name of the resource group
  EOF
  default     = {}
}

variable "location" {
  type        = string
  description = "(Required) Specified the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type    = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default = {}
}


variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "source_virtual_machine" {
  type = object({
    id                  = optional(string) # (Optional) The Virtual Machine ID from which to create the image.
    name                = optional(string) # If ID is unknown, use name to retrieve resource ID via 'data' block
    resource_group_name = optional(string) # Resource group name to use along with 'name'. If Null, core resource group name is used instead.
  })
}

# Note: Documentation states multiple blocks, Azure only accepts single os_disk block
variable "os_disk" {
  type = object({
    os_type  = string # (Optional) Specifies the operating system type of the virtual machine. Possible values include: 'Windows', 'Linux'
    os_state = string # (Optional) Specifies the state of the virtual machine. Possible values include: 'Generalized', 'Specialized'
    managed_disk = optional(object({
      id                  = optional(string) # (Optional) Specifies the ID of the managed disk resource that you want to use to create the image.
      name                = optional(string) # (Optional) Specifies the name of the managed disk resource that you want to use to create the image.
      resource_group_name = optional(string) # (Optional) Specifies the name of the resource group where the managed disk is located.
    }))                                      # (Optional) Specifies the managed disk ID to use for the virtual machine.
    blob_uri = optional(string)              # (Optional) Specifies the blob URI of the VHD to use for the virtual machine.
    caching  = optional(string)              # (Optional) Specifies the caching requirements. Possible values include: 'None', 'ReadOnly', 'ReadWrite'
    size_gb  = optional(number)              # (Optional) Specifies the size of the VHD to use for the virtual machine.
  })
  default = null
}


variable "data_disk" {
  type = list(object({
    lun = number # (Required) Specifies the logical unit number of the data disk. If null, array index is used.
    managed_disk = optional(object({
      id                  = optional(string) # (Optional) Specifies the ID of the managed disk resource that you want to use to create the image.
      name                = optional(string) # (Optional) Specifies the name of the managed disk resource that you want to use to create the image.
      resource_group_name = optional(string) # (Optional) Specifies the name of the resource group where the managed disk is located.
    }))                                      # (Optional) Specifies the managed disk ID to use for the virtual machine.
    blob_uri = optional(string)              # (Optional) Specifies the URI in Azure storage of the blob that you want to use to create the image.
    caching  = optional(string)              # (Optional) Specifies the caching mode as ReadWrite, ReadOnly, or None. The default is None.
    size_gb  = optional(number)              # (Optional) Specifies the size of the image to be created. The target size can't be smaller than the source size.
  }))
  default = null
}

variable "zone_resilient" {
  type        = bool
  description = "(Optional) Is zone resiliency enabled? Defaults to false. Changing this forces a new resource to be created."
  default     = false
}

variable "hyper_v_generation" {
  type        = string
  description = "(Optional) The HyperVGenerationType of the VirtualMachine created from the image as V1, V2. The default is V1."
  default     = "V1"
}