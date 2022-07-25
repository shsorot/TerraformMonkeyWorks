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

# variable "resource_group_name" {
#   type = string
#   description = "(Required) The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created."
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

variable "name" {
  type        = string
  description = "Name of the Key vault. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = null
}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. IF null, current context tenant ID is used."
  default     = null
}

variable "sku_name" {
  type        = string # Can be "standard" or "premium" (case sensitive)
  description = "value"
  default     = "standard"
}

variable "enabled_for_deployment" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false"
  default     = null
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false."
  default     = null
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
  default     = false
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false"
  default     = false
}

variable "soft_delete_retention_days" {
  type        = number
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  default     = 90
}

variable "purge_protection_enabled" {
  type        = bool
  description = <<EOT
  (Optional) Is Purge Protection enabled for this Key Vault? Defaults to false.
  Once Purge Protection has been Enabled it's not possible to Disable it. 
  Support for disabling purge protection is being tracked in this Azure API issue. 
  Deleting the Key Vault with Purge Protection Enabled will schedule the Key Vault to be deleted (which will happen by Azure in the configured number of days, 
  currently 90 days - which will be configurable in Terraform in the future).
  EOT
  default     = false # Enable with caution: this setting unconditionally prevents purging the Key Vault for 90 days
}

# TODO : add code for application ID lookup
variable "access_policy" {
  type = list(object({
    tenant_id               = string                 #   (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Must match the tenant_id used above.
    object_id               = string                 #   (Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies.
    application_id          = optional(string)       #   (Optional) The object ID of an Application in Azure Active Directory.
    certificate_permissions = optional(list(string)) #   (Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update.
    key_permissions         = optional(list(string)) #   (Optional) List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey.
    secret_permissions      = optional(list(string)) #   (Optional) List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set.
    storage_permissions     = optional(list(string)) #   (Optional) List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update.
  }))
  description = <<EOT
  A list of up to 16 objects describing access policies, as described below.
  NOTE
  Since access_policy can be configured both inline and via the 
  separate azurerm_key_vault_access_policy resource, 
  we have to explicitly set it to empty slice ([]) to remove it.
  
  NOTE: This block does not configures anything if enable_rbac_authorization is set to true.
  EOT
  default     = null
}

variable "network_acls" {
  type = object({
    default_action =          string        # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
    bypass         =          string        # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
    ip_rules       = optional(list(string)) #  (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
    virtual_network_subnet = optional(list(object({
      id                   = optional(string)
      name                 = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
      key                  = optional(string)
      virtual_network_key  = optional(string)
    }))) # (Optional) One or more Subnet IDs which should be able to access this Key Vault.

  })
  default = null
}

variable "contact" {
  type = list(object({
    email = string
    name  = optional(string)
    phone = optional(string)
  }))
  default = null
}


variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_tag' for ID lookup."
  type = map(object({
    id   = string # Resource ID of the virtual Network
    name = string # Name of the Virtual Network
    subnet = map(object({
      id = string
    }))
  }))
  default = {}
}


