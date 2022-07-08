<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_provider.policy"></a> [provider.policy](#provider\_provider.policy) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group_policy_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_policy_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_definition) | data source |
| [azurerm_policy_set_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_set_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [provider_azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/provider/latest/docs/data-sources/azurerm_resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the policy definition. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Required) The display name of the policy definition. | `string` | n/a | yes |
| <a name="input_enforce"></a> [enforce](#input\_enforce) | (Optional) Specifies if this Policy should be enforced or not? | `bool` | `null` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) The Type of Managed Identity which should be added to this Policy Definition. The only possible value is SystemAssigned. | <pre>object({<br>    type = string<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The Azure Region where the Policy Assignment should exist. Changing this forces a new Policy Assignment to be created. | `string` | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | (Optional) The metadata for the policy definition. This is a JSON string representing additional metadata that should be stored with the policy definition. | <pre>object({<br>    json = optional(string) # JSON string denoting the metadata body.<br>    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the policy definition. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_not_scopes"></a> [not\_scopes](#input\_not\_scopes) | (Optional) Specifies a list of Resource Scopes (for example a Subscription, or a Resource Group) within this Management Group which are excluded from this Policy. | `list(string)` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | (Optional) Parameters for the policy definition. This field is a JSON string that allows you to parameterize your policy definition. | <pre>object({<br>    json = optional(string) # JSON string denoting the parameters body.<br>    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8<br>  })</pre> | `null` | no |
| <a name="input_policy_definition"></a> [policy\_definition](#input\_policy\_definition) | (Required) The ID of the Policy Definition or Policy Definition Set. Changing this forces a new Policy Assignment to be created. | <pre>object({<br>    id   = optional(string) # Resource ID of the Policy or Set <br>    name = optional(string) # Display name of the policy definition.<br>    key  = optional(string) # Tag of the policy definition, used to fetch ID from the output of module Azure-PolicyDefinition.Cannot be used in combination with definition_set_tag<br>  })</pre> | `null` | no |
| <a name="input_policy_definition_set"></a> [policy\_definition\_set](#input\_policy\_definition\_set) | (Required) The ID of the Policy Definition or Policy Definition Set. Changing this forces a new Policy Assignment to be created. | <pre>object({<br>    id   = optional(string) # Resource ID of the Policy set<br>    name = optional(string) # Display name of the policy definition set.  Cannot be used in combination with tag<br>    key  = optional(string) # Tag of the policy definition set, used to fetch ID from the output of module Azure-PolicyDefinitionSet. Cannot be used in combination with name<br>  })</pre> | `{}` | no |
| <a name="input_policy_definition_sets"></a> [policy\_definition\_sets](#input\_policy\_definition\_sets) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_policy_definitions"></a> [policy\_definitions](#input\_policy\_definitions) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The ID of the Management Group. Changing this forces a new Policy Assignment to be created. | <pre>object({<br>    id              = optional(string) # Resource ID of the resource group<br>    name            = optional(string) # Name of the resource group, used to generate the resource ID string<br>    subscription_id = optional(string) # If not provided along with name, current subscription ID of the login context will be used. This may cause failures if the target resource is in another subscription<br>    tag             = optional(string) # Tag value used to lookup resource group ID from output of module Azure-ResourceGroup<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->