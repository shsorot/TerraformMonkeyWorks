variable "name" {
  type        = string
  description = "(Required) The name of the Disk Encryption Set. Changing this forces a new resource to be created."
}

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
  description = "(Required) Specifies the Azure Region where the Disk Encryption Set exists. Changing this forces a new resource to be created."
}

variable "key_vault_key" {
  type = object({
    id                  = optional(string)  # (Optional) ID of the Key vault key to be used for disk encryption.
    name                = optional(string)  # (Optional) Name of the Key vault key to be used for Id lookup using data block
    key_vault_name      = optional(string)  # (Optional) Name of the keyvault, must be used when 'name' is used.
    resource_group_name = optional(string)  # (Optional) Resource group of the keyvault, if null when 'name' is used, then the resource group of the disk encryption set is used.
    key                 = optional(string)  # (Optional) Key to be used for Id lookup using output of module Azure-KeyVaultKey
  })
  description = <<EOF
  (Required) Specifies the URL to a Key Vault Key (either from a Key Vault Key, or the Key URL for the Key Vault Secret).
    id                  = # (Optional) ID of the Key vault key to be used for disk encryption.
    name                = # (Optional) Name of the Key vault key to be used for Id lookup using data block
    key_vault_name      = # (Optional) Name of the keyvault, must be used when 'name' is used.
    resource_group_name = # (Optional) Resource group of the keyvault, if null when 'name' is used, then the resource group of the disk encryption set is used.
    key                 = # (Optional) Key to be used for Id lookup using output of module Azure-KeyVaultKey
  EOF
}

variable "key_vault_keys" {
  type = map(object({
    id =  string # (Required) Resource ID of the keyvault key.
  }))
  description = "(Optional) Output of module Azure-KeyVaultKey. Used to lookup Key Vault Key properties using Terraform Object Keys"
  default = {}
}

variable "identity" {
  type = object({
    type = string # (Required) The Type of Identity which should be used for this Disk Encryption Set. At this time the only possible value is SystemAssigned.
  })
  default = {
    type = "SystemAssigned"
  }
  validation {
    condition = contains("SystemAssigned",var.identity.type)
    error_message = "Value of identity.type must be 'SystemAssigned'"
  }
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

# Added in provider > 3.xx.x
variable "auto_key_rotation_enabled" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption Set automatically rotates encryption Key to latest version. Defaults to false."
  default     = false
}

variable "encryption_type" {
  type        = string
  description = " (Optional) The type of key used to encrypt the data of the disk. Possible values are EncryptionAtRestWithCustomerKey, EncryptionAtRestWithPlatformAndCustomerKeys and ConfidentialVmEncryptedWithCustomerKey. Defaults to EncryptionAtRestWithCustomerKey."
  default     = "EncryptionAtRestWithCustomerKey"
}