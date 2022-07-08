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
| [azurerm_management_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Optional) A friendly name for this Management Group. If not specified, this will be the same as the name. | `string` | `null` | no |
| <a name="input_management_groups"></a> [management\_groups](#input\_management\_groups) | n/a | <pre>object({<br>    id = optional(string) # Output of the module Azure-ManagementGroup<br>  })</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) The name or UUID for this Management Group, which needs to be unique across your tenant. A new UUID will be generated if not provided. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_parent_management_group"></a> [parent\_management\_group](#input\_parent\_management\_group) | (Optional) The ID of the Parent Management Group. Changing this forces a new resource to be created. | <pre>object({<br>    id   = optional(string)<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_subscription_ids"></a> [subscription\_ids](#input\_subscription\_ids) | (Optional) A list of Subscription GUIDs which should be assigned to the Management Group. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->