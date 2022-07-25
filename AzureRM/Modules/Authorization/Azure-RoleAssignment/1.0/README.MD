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
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_condition"></a> [condition](#input\_condition) | (Optional) The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_condition_version"></a> [condition\_version](#input\_condition\_version) | (Optional) The version of the condition. Possible values are 1.0 or 2.0. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_delegated_managed_identity_resource_id"></a> [delegated\_managed\_identity\_resource\_id](#input\_delegated\_managed\_identity\_resource\_id) | (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description for this Role Assignment. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) A unique UUID/GUID for this Role Assignment - one will be generated if not specified. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | (Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_role_definition"></a> [role\_definition](#input\_role\_definition) | (Optional) The Scoped-ID of the Role Definition. Changing this forces a new resource to be created. Conflicts with role\_definition\_name. | <pre>object({<br>    id    = optional(string) # (Optional) The Scoped-ID of the Role Definition. <br>    name  = optional(string) # (Optional) The name of the role definition to be used for lookup when id is unknown.<br>    scope = optional(string) # Subscription scope where role definition is used. If null, current scope is used. To be used with 'name' only.<br>    key   = optional(string) # To be used for ID lookup from output of module Azure-RoleDefinition.<br>  })</pre> | n/a | yes |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | (Optional) The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role\_definition\_id. | `string` | `null` | no |
| <a name="input_role_definitions"></a> [role\_definitions](#input\_role\_definitions) | (Optional) A map of object output module Azure-RoleDefinition. Used by variable 'role\_definition' | <pre>map(object({<br>    id = string # Resource ID of the role definition.<br>  }))</pre> | `{}` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) The scope at which the Role Assignment applies to, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM, or /providers/Microsoft.Management/managementGroups/myMG. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_skip_service_principal_aad_check"></a> [skip\_service\_principal\_aad\_check](#input\_skip\_service\_principal\_aad\_check) | (Optional) If the principal\_id is a newly provisioned Service Principal set this value to true to skip the Azure Active Directory check which may fail due to replication lag. This argument is only valid if the principal\_id is a Service Principal identity. If it is not a Service Principal identity it will cause the role assignment to fail. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The Role Assignment ID. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Role Assignment. |
| <a name="output_principal_type"></a> [principal\_type](#output\_principal\_type) | The type of the principal\_id, e.g. User, Group, Service Principal, Application, etc. |
<!-- END_TF_DOCS -->