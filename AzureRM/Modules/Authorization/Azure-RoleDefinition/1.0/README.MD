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
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignable_scopes"></a> [assignable\_scopes](#input\_assignable\_scopes) | (Optional) One or more assignable scopes for this Role Definition, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM. | `list(string)` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of the Role Definition. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Role Definition. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | (Optional) A permissions block as defined in type. | <pre>object({<br>    actions          = optional(list(string)) # (Optional) One or more Allowed Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read<br>    data_actions     = optional(list(string)) # (Optional) One or more Allowed Data Actions, such as *, Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read<br>    not_actions      = optional(list(string)) # (Optional) One or more Disallowed Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read<br>    not_data_actions = optional(list(string)) # (Optional) One or more Disallowed Data Actions, such as *, Microsoft.Resources/subscriptions/resourceGroups/read<br>  })</pre> | n/a | yes |
| <a name="input_role_definition_id"></a> [role\_definition\_id](#input\_role\_definition\_id) | (Optional) A unique UUID/GUID which identifies this role - one will be generated if not specified. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) The scope at which the Role Definition applies too, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM. It is recommended to use the first entry of the assignable\_scopes. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | This ID is specific to Terraform - and is of the format {roleDefinitionId}\|{scope}. |
| <a name="output_role_definition_id"></a> [role\_definition\_id](#output\_role\_definition\_id) | The Role Definition ID. |
| <a name="output_role_definition_resource_id"></a> [role\_definition\_resource\_id](#output\_role\_definition\_resource\_id) | The Azure Resource Manager ID for the resource. |
<!-- END_TF_DOCS -->