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
| [azurerm_policy_set_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the policy set definition. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Required) The display name of the policy set definition. | `string` | n/a | yes |
| <a name="input_management_group_name"></a> [management\_group\_name](#input\_management\_group\_name) | (Optional) The name of the Management Group where this policy set definition should be defined. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | (Optional) The metadata for the policy definition. This is a JSON string representing additional metadata that should be stored with the policy definition. | <pre>object({<br>    json = optional(string) # JSON string denoting the metadata body.<br>    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the policy set definition. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | (Optional) Parameters for the policy definition. This field is a JSON string that allows you to parameterize your policy definition. | <pre>object({<br>    json = optional(string) # JSON string denoting the parameters body.<br>    file = optional(string) # Relative path of the file containing policy JSON stored as UTF-8<br>  })</pre> | `null` | no |
| <a name="input_policy_definition_group"></a> [policy\_definition\_group](#input\_policy\_definition\_group) | (Optional) The metadata for the policy definition. This is a JSON string representing additional metadata that should be stored with the policy definition. | <pre>list(object({<br>    name                            = string           # (Required) The name of this policy definition group.<br>    display_name                    = optional(string) # (Optional) The display name of this policy definition group.<br>    category                        = optional(string) # (Optional) The category of this policy definition group.<br>    description                     = optional(string) # (Optional) The description of this policy definition group.<br>    additional_metadata_resource_id = optional(string) # (Optional) The ID of a resource that contains additional metadata about this policy definition group.<br>  }))</pre> | `[]` | no |
| <a name="input_policy_definition_reference"></a> [policy\_definition\_reference](#input\_policy\_definition\_reference) | n/a | <pre>list(object({<br>    policy_definition = object({<br>      id  = optional(string) # Resource ID of the policy definition. Useful for pre-existing policies.<br>      tag = optional(string) # Tag of the policy definition, used to lookup policy ID from output of module Azure-PolicyDefinition<br>    })<br>    parameter_values = optional(object({<br>      json = optional(string) # JSON string denoting the parameter body.<br>      file = optional(string) # Relative path of the file containing parameter JSON stored as UTF-8<br>    }))<br>    reference_id       = optional(string)       # (Optional) A unique ID within this policy set definition for this policy definition reference.<br>    policy_group_names = optional(list(string)) #  (Optional) A list of names of the policy definition groups that this policy definition reference belongs to.<br>  }))</pre> | `[]` | no |
| <a name="input_policy_definitions"></a> [policy\_definitions](#input\_policy\_definitions) | (Optional)Output of module Azure-PolicyDefinition. | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | (Required) The policy set type. Possible values are BuiltIn or Custom. Changing this forces a new resource to be created. | `string` | `"Custom"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->