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

variable "recovery_vault_name" {
  type        = string
  description = "(Required) Specifies the name of the Recovery Services Vault to use. Changing this forces a new resource to be created."
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


variable "source_vm" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) Specifies the ID of the VM to backup. Changing this forces a new resource to be created."
  default     = null
}


variable "virtual_machines" {
  type = map(object({
    id = optional(string)
  }))
  default     = {}
  description = "(Optional) Output of module Azure-VirtualMachine or Azure-WindowsVirtualMachine or Azure-LinuxVirtualMachine"
}

variable "backup_policy" {
  type = object({
    id   = optional(string) # Specify Resource ID of the Backup policy.
    name = optional(string) # Specify Name of the Backup policy if ID is not available. Backup policy data source will be used to fetch Id using resource_group_name and recovery_services_vault_name
    key  = optional(string) # Used to pull up backup policy using tags and output of module Azure-BackupPolicyVM
  })
  description = "(Required) Specifies the id of the backup policy to use."
  default     = null
}


variable "backup_policies" {
  type = map(object({
    id                  = string
    name                = optional(string)
    recovery_vault_name = optional(string)
    resource_group_name = optional(string)
  }))
  description = "(Optional) Output of module Azure-BackupPolicyVM, to be used for lookup of policy ID using TAG"
  default     = {}
}

