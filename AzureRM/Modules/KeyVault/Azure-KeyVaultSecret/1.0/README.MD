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
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_type"></a> [content\_type](#input\_content\_type) | (Optional) Specifies the content type for the Key Vault Secret. | `string` | `null` | no |
| <a name="input_expiration_date"></a> [expiration\_date](#input\_expiration\_date) | (Optional) Expiration UTC datetime (Y-m-d'T'H:M:S'Z'). | `string` | `null` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | (Optional) Tag of the key vault, used to lookup resource ID from output of module Azure-KeyVault | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_key_vaults"></a> [key\_vaults](#input\_key\_vaults) | (Optional) Output of module Azure-KeyVault, used to perform lookup of key vault ID using Tag | <pre>map(object({<br>    id  = string<br>    uri = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the secret. | `string` | n/a | yes |
| <a name="input_not_before_date"></a> [not\_before\_date](#input\_not\_before\_date) | (Optional) Key not usable before the provided UTC datetime (Y-m-d'T'H:M:S'Z'). | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_value"></a> [value](#input\_value) | (Required) Value of the secret.<br>  Key Vault strips newlines. To preserve newlines in multi-line secrets try replacing them with \n or by base 64 encoding them with <br>  replace(file("my\_secret\_file"), "/\n/", "\n") or base64encode(file("my\_secret\_file")), respectively. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_version"></a> [version](#output\_version) | n/a |
| <a name="output_versionless_id"></a> [versionless\_id](#output\_versionless\_id) | n/a |
<!-- END_TF_DOCS -->