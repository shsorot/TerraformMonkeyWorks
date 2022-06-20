variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Key Vault Key. Changing this forces a new resource to be created."
}

variable "key_vault" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Key Vault where the Key should be created. Changing this forces a new resource to be created."
}

variable "key_vaults" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of Module Azure-KeyVault."
  default     = {}
}

variable "key_type" {
  type        = string
  description = "(Required) Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, Oct (Octet), RSA and RSA-HSM. Changing this forces a new resource to be created."
}

variable "key_size" {
  type        = string
  description = "(Optional) Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key_type is RSA or RSA-HSM. Changing this forces a new resource to be created."
  default     = null
}

variable "curve" {
  type        = string
  description = "(Optional) Specifies the curve to use when creating an EC key. Possible values are P-256, P-256K, P-384, and P-521. This field will be required in a future release if key_type is EC or EC-HSM. The API will default to P-256 if nothing is specified. Changing this forces a new resource to be created."
  default     = null
}

variable "key_opts" {
  type        = list(string)
  description = "(Required) A list of JSON web key operations. Possible values include: decrypt, encrypt, sign, unwrapKey, verify and wrapKey. Please note these values are case sensitive."
}

variable "not_before_date" {
  type        = string
  description = "(Optional) Key not usable before the provided UTC datetime (Y-m-d'T'H:M:S'Z')."
  default     = null
}

variable "expiration_date" {
  type        = string
  description = "(Optional) Expiration UTC datetime (Y-m-d'T'H:M:S'Z')."
  default     = null
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

