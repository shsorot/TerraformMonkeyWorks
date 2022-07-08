<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.this](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_remote_container_name"></a> [remote\_container\_name](#input\_remote\_container\_name) | n/a | `string` | n/a | yes |
| <a name="input_remote_key_name"></a> [remote\_key\_name](#input\_remote\_key\_name) | n/a | `string` | n/a | yes |
| <a name="input_remote_resource_group_name"></a> [remote\_resource\_group\_name](#input\_remote\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_remote_storage_account_name"></a> [remote\_storage\_account\_name](#input\_remote\_storage\_account\_name) | n/a | `string` | n/a | yes |
| <a name="input_resource_tag"></a> [resource\_tag](#input\_resource\_tag) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_terraform_remote_state_output"></a> [terraform\_remote\_state\_output](#output\_terraform\_remote\_state\_output) | n/a |
<!-- END_TF_DOCS -->