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
| [azurerm_storage_share.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | n/a | <pre>map(object({<br>    access_policy = object({<br>      permissions = string           #     (Required) The permissions which should be associated with this Shared Identifier. Possible value is combination of r (read), w (write), d (delete), and l (list).<br>      start       = optional(string) #   (Optional) The time at which this Access Policy should be valid from, in ISO8601 format.<br>      expiry      = optional(string) #    (Optional) The time at which this Access Policy should be valid until, in ISO8601 format.<br>    })<br>  }))</pre> | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | (Optional) A mapping of MetaData for this File Share. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the share. Must be unique within the storage account where the share is located. | `string` | n/a | yes |
| <a name="input_quota"></a> [quota](#input\_quota) | (Optional) The maximum size of the share, in gigabytes. <br>  For Standard storage accounts, this must be greater than 0 and less than 5120 GB (5 TB). <br>  For Premium FileStorage storage accounts, this must be greater than 100 GB and less than 102400 GB (100 TB). <br>  Default is 5120. | `number` | `5120` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | (Required) Specifies the storage account in which to create the share. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_resource_manager_id"></a> [resource\_manager\_id](#output\_resource\_manager\_id) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->