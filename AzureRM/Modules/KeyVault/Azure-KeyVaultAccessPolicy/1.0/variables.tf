variable "key_vault" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) Tag of the key vault, used to lookup resource ID from output of module Azure-KeyVault"
}

variable "key_vaults" {
  type = map(object({
    id  = string
    uri = string
  }))
  description = "(Optional) Output of module Azure-KeyVault, used to perform lookup of key vault ID using Tag"
  default     = {}
}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Changing this forces a new resource to be created."
}

variable "object_id" {
  type        = string
  description = "(Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Changing this forces a new resource to be created."
}

variable "application_id" {
  type        = string
  description = "(Optional) The object ID of an Application in Azure Active Directory."
}

variable "certificate_permissions" {
  type        = list(string)
  description = <<EOF
    (Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, 
    Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update.
    EOF
  default     = []
}

variable "key_permissions" {
  type        = list(string)
  description = <<EOF
  (Optional) List of key permissions, must be one or more from the following: Backup, Create, 
  Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey.
  EOF
  default     = []
}


variable "secret_permissions" {
  type        = list(string)
  description = <<EOF
  (Optional) List of secret permissions, must be one or more from the following: Backup, Delete, get, list, purge, recover, restore and set.
  EOF
  default     = []
}

variable "storage_permissions" {
  type        = list(string)
  description = <<EOF
   (Optional) List of storage permissions, must be one or more from the following: Backup, Delete, 
   DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update.
  EOF
  default     = []
}

