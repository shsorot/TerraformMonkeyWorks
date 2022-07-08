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
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_curve"></a> [curve](#input\_curve) | (Optional) Specifies the curve to use when creating an EC key. Possible values are P-256, P-256K, P-384, and P-521. This field will be required in a future release if key\_type is EC or EC-HSM. The API will default to P-256 if nothing is specified. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_expiration_date"></a> [expiration\_date](#input\_expiration\_date) | (Optional) Expiration UTC datetime (Y-m-d'T'H:M:S'Z'). | `string` | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_key_opts"></a> [key\_opts](#input\_key\_opts) | (Required) A list of JSON web key operations. Possible values include: decrypt, encrypt, sign, unwrapKey, verify and wrapKey. Please note these values are case sensitive. | `list(string)` | n/a | yes |
| <a name="input_key_size"></a> [key\_size](#input\_key\_size) | (Optional) Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key\_type is RSA or RSA-HSM. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_key_type"></a> [key\_type](#input\_key\_type) | (Required) Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, Oct (Octet), RSA and RSA-HSM. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | (Required) The ID of the Key Vault where the Key should be created. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_key_vaults"></a> [key\_vaults](#input\_key\_vaults) | (Optional) Output of Module Azure-KeyVault. | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Key Vault Key. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_not_before_date"></a> [not\_before\_date](#input\_not\_before\_date) | (Optional) Key not usable before the provided UTC datetime (Y-m-d'T'H:M:S'Z'). | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_e"></a> [e](#output\_e) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_n"></a> [n](#output\_n) | n/a |
| <a name="output_version"></a> [version](#output\_version) | n/a |
| <a name="output_versionless_id"></a> [versionless\_id](#output\_versionless\_id) | n/a |
| <a name="output_x"></a> [x](#output\_x) | n/a |
| <a name="output_y"></a> [y](#output\_y) | n/a |
<!-- END_TF_DOCS -->