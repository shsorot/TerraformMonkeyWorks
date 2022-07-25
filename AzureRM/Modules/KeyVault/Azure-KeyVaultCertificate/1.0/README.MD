<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_certificate.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate"></a> [certificate](#input\_certificate) | n/a | <pre>object({<br>    content  = string<br>    password = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_certificate_policy"></a> [certificate\_policy](#input\_certificate\_policy) | n/a | <pre>object({<br>    issuer_parameters = object({<br>      name = string<br>    })<br>    key_properties = object({<br>      curve      = optional(string)<br>      exportable = bool<br>      key_size   = optional(number)<br>      key_type   = string<br>      reuse_key  = bool<br>    })<br>    lifetime_action = optional(object({<br>      action = object({<br>        action_type = string<br>      })<br>      trigger = object({<br>        days_before_expiry  = optional(number)<br>        lifetime_percentage = optional(number)<br>      })<br>    }))<br>    secret_properties = object({<br>      content_type = string<br>    })<br>    x509_certificate_properties = object({<br>      extended_key_usage = list(string)<br>      key_usage          = list(string)<br>      subject            = string<br>      subject_alternative_names = optional(object({<br>        dns_names = list(string)<br>        emails    = list(string)<br>        upns      = list(string)<br>      }))<br>      validity_in_months = number<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | (Optional) Tag of the key vault, used to lookup resource ID from output of module Azure-KeyVault | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_key_vaults"></a> [key\_vaults](#input\_key\_vaults) | (Optional) Output of module Azure-KeyVault, used to perform lookup of key vault ID using Tag | <pre>map(object({<br>    id  = string<br>    uri = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Key Vault Certificate. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_attribute"></a> [certificate\_attribute](#output\_certificate\_attribute) | Certificate attributes & properties |
| <a name="output_id"></a> [id](#output\_id) | The ID of the certificate |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | The secret URL of the key vault certificate |
| <a name="output_thumbprint"></a> [thumbprint](#output\_thumbprint) | Value of the certificate thumbprint |
| <a name="output_version"></a> [version](#output\_version) | The version of the certificate |
<!-- END_TF_DOCS -->