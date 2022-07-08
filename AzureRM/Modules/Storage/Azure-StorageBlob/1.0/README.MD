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
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | (Optional) The access tier of the storage blob. Possible values are Archive, Cool and Hot. | `string` | `null` | no |
| <a name="input_content_md5"></a> [content\_md5](#input\_content\_md5) | (Optional) The MD5 sum of the blob contents. Cannot be defined if source\_uri is defined, or if blob type is Append or Page. <br>  Changing this forces a new resource to be created.<br>  This property is intended to be used with the Terraform internal filemd5 and md5 functions when source or source\_content, respectively, are defined. | `string` | `null` | no |
| <a name="input_content_type"></a> [content\_type](#input\_content\_type) | (Optional) The content type of the storage blob. Cannot be defined if source\_uri is defined. Defaults to application/octet-stream | `string` | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | (Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Container which should be created within the Storage Account. | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | (Optional) Used only for page blobs to specify the size in bytes of the blob to be created. Must be a multiple of 512. Defaults to 0. | `number` | `null` | no |
| <a name="input_source"></a> [source](#input\_source) | n/a | `any` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | (Required) The name of the Storage Account where the Container should be created. | `string` | n/a | yes |
| <a name="input_storage_container_name"></a> [storage\_container\_name](#input\_storage\_container\_name) | (Required) The name of the storage container in which this blob should be created. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | (Required) The type of the storage blob to be created. Possible values are Append, Block or Page. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_uri"></a> [uri](#output\_uri) | n/a |
<!-- END_TF_DOCS -->