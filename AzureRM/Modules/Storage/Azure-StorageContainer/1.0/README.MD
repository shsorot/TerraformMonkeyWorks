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
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_access_type"></a> [container\_access\_type](#input\_container\_access\_type) | (Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private. | `string` | `"private"` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | (Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Container which should be created within the Storage Account. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | (Required) The name of the Storage Account where the Container should be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_has_immutability_policy"></a> [has\_immutability\_policy](#output\_has\_immutability\_policy) | n/a |
| <a name="output_has_legal_hold"></a> [has\_legal\_hold](#output\_has\_legal\_hold) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_resource_manager_id"></a> [resource\_manager\_id](#output\_resource\_manager\_id) | n/a |
<!-- END_TF_DOCS -->