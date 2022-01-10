variable "name" {
  description = "(Required) The name which should be used for this Express Route Port. Changing this forces a new Express Route Port to be created."
  type        = string
}

# variable "resource_group_name" {
#     description = "(Required) The name of the resource group in which to create the Application Security Group."
#     type = string
# }

variable "resource_group" {
  type = object({
    name = optional(string)
    tag  = optional(string)
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
  description = "(Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Tags"
  default     = {}
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

variable "bandwidth_in_gbps" {
  type        = number
  description = "(Required) Bandwidth of the Express Route Port in Gbps. Changing this forces a new Express Route Port to be created."
}

variable "encapsulation" {
  type        = string
  description = " (Required) The encapsulation method used for the Express Route Port. Changing this forces a new Express Route Port to be created. Possible values are: Dot1Q, QinQ."
}

variable "peering_location" {
  type        = string
  description = "(Required) The name of the peering location that this Express Route Port is physically mapped to. Changing this forces a new Express Route Port to be created."
}


# macsec_ckn_keyvault_secret_id and macsec_cak_keyvault_secret_id should be used together with identity, 
# so that the Express Route Port instance have the right permission to access the Key Vault.

variable "link1" {
  type = list(object({
    admin_enabled                 = optional(string) # (Optional) Whether enable administration state on the Express Route Port Link? Defaults to false
    macsec_cipher                 = optional(string) # (Optional) The MACSec cipher used for this Express Route Port Link. Possible values are GcmAes128 and GcmAes256. Defaults to GcmAes128.
    macsec_ckn_keyvault_secret_id = optional(string) #   (Optional) The ID of the Key Vault Secret that contains the MACSec CKN key for this Express Route Port Link.
    macsec_cak_keyvault_secret_id = optional(string) #   (Optional) The ID of the Key Vault Secret that contains the Mac security CAK key for this Express Route Port Link.
  }))
  description = "Link Object definition"
  default     = null
}

variable "link2" {
  type = list(object({
    admin_enabled                 = optional(string) # (Optional) Whether enable administration state on the Express Route Port Link? Defaults to false
    macsec_cipher                 = optional(string) # (Optional) The MACSec cipher used for this Express Route Port Link. Possible values are GcmAes128 and GcmAes256. Defaults to GcmAes128.
    macsec_ckn_keyvault_secret_id = optional(string) #   (Optional) The ID of the Key Vault Secret that contains the MACSec CKN key for this Express Route Port Link.
    macsec_cak_keyvault_secret_id = optional(string) #   (Optional) The ID of the Key Vault Secret that contains the Mac security CAK key for this Express Route Port Link.
  }))
  description = "Link Object definition"
  default     = null
}

variable "identity" {
  type = object({
    type         = string           # (Optional) The identity type. Possible values are 'SystemAssigned' and 'UserAssigned'.
    identity_ids = optional(string) # (Optional) Specifies a list with a single user managed identity id to be assigned to the Express Route Port. Currently, exactly one id is allowed to specify.
  })
  default = null
}