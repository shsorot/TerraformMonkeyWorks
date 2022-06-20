variable "name" {
  type        = string
  description = "(Required) Name of the secret."
}

variable "value" {
  type        = string
  description = <<HELP
  (Required) Value of the secret.
  Key Vault strips newlines. To preserve newlines in multi-line secrets try replacing them with \n or by base 64 encoding them with 
  replace(file("my_secret_file"), "/\n/", "\n") or base64encode(file("my_secret_file")), respectively.
  HELP
  sensitive   = true
}

variable "key_vault" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) Tag of the key vault, used to lookup resource ID from output of module Azure-KeyVault"
}

variable "key_vaults" {
  type = map(object({
    id  = string
    uri = optional(string)
  }))
  description = "(Optional) Output of module Azure-KeyVault, used to perform lookup of key vault ID using Tag"
  default     = {}
}

variable "content_type" {
  type        = string
  description = " (Optional) Specifies the content type for the Key Vault Secret. "
  default     = null
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
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

