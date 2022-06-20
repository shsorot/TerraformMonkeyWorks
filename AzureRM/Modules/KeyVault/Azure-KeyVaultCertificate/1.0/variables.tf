variable "name" {
  type        = string
  description = " (Required) Specifies the name of the Key Vault Certificate. Changing this forces a new resource to be created."
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


variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}


variable "certificate" {
  type = object({
    content  = string
    password = optional(string)
  })
  default = null
}

variable "certificate_policy" {
  type = object({
    issuer_parameters = object({
      name = string
    })
    key_properties = object({
      curve      = optional(string)
      exportable = bool
      key_size   = optional(number)
      key_type   = string
      reuse_key  = bool
    })
    lifetime_action = optional(object({
      action = object({
        action_type = string
      })
      trigger = object({
        days_before_expiry  = optional(number)
        lifetime_percentage = optional(number)
      })
    }))
    secret_properties = object({
      content_type = string
    })
    x509_certificate_properties = object({
      extended_key_usage = list(string)
      key_usage          = list(string)
      subject            = string
      subject_alternative_names = optional(object({
        dns_names = list(string)
        emails    = list(string)
        upns      = list(string)
      }))
      validity_in_months = number
    })
  })
}

