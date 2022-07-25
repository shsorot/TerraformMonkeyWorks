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
| [azurerm_policy_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_management_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the policy definition. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Required) The display name of the policy definition. | `string` | n/a | yes |
| <a name="input_management_group"></a> [management\_group](#input\_management\_group) | (Optional) The name of the Management Group where this policy should be defined. Changing this forces a new resource to be created. | <pre>object({<br>    id   = optional(string)<br>    tags = optional(string)<br>    name = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_management_groups"></a> [management\_groups](#input\_management\_groups) | (Optional) Output of module Azure-ManagementGroup. Used to lookup MG properties using Tags | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | (Optional) The metadata for the policy definition. This is a JSON string representing additional metadata that should be stored with the policy definition. | <pre>object({<br>    json = optional(string) # JSON string denoting the metadata body.<br>    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8<br>  })</pre> | `null` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | (Required) The policy mode that allows you to specify which resource types will be evaluated. <br>  Possible values are All, Indexed, Microsoft.ContainerService.Data, Microsoft.CustomerLockbox.Data,<br>   Microsoft.DataCatalog.Data, Microsoft.KeyVault.Data, Microsoft.Kubernetes.Data, <br>   Microsoft.MachineLearningServices.Data, Microsoft.Network.Data and Microsoft.Synapse.Data. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the policy definition. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | (Optional) Parameters for the policy definition. This field is a JSON string that allows you to parameterize your policy definition. | <pre>object({<br>    json = optional(string) # JSON string denoting the parameters body.<br>    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8<br>  })</pre> | `null` | no |
| <a name="input_policy_rule"></a> [policy\_rule](#input\_policy\_rule) | (Optional) The policy rule for the policy definition. This is a JSON string representing the rule that contains an if and a then block. | <pre>object({<br>    json = optional(string) # JSON string denoting the policy rule body.<br>    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8<br>  })</pre> | `null` | no |
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | (Required) The policy type. Possible values are BuiltIn, Custom and NotSpecified. Changing this forces a new resource to be created. | `string` | `"Custom"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->