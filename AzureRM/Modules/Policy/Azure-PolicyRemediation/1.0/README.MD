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
| [azurerm_policy_remediation.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_remediation) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location_filters"></a> [location\_filters](#input\_location\_filters) | (Optional) A list of the resource locations that will be remediated. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Policy Remediation. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_policy_assignment"></a> [policy\_assignment](#input\_policy\_assignment) | (Required) The ID of the Policy Assignment that should be remediated. | <pre>object({<br>    id  = optional(string)<br>    tag = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_policy_assignments"></a> [policy\_assignments](#input\_policy\_assignments) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_policy_definition_reference"></a> [policy\_definition\_reference](#input\_policy\_definition\_reference) | (Optional) The unique ID for the policy definition within the policy set definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition. | <pre>object({<br>    id  = optional(string)<br>    tag = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_policy_definitions"></a> [policy\_definitions](#input\_policy\_definitions) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_resource_discovery_mode"></a> [resource\_discovery\_mode](#input\_resource\_discovery\_mode) | (Optional) The way that resources to remediate are discovered. Possible values are ExistingNonCompliant, ReEvaluateCompliance. Defaults to ExistingNonCompliant. | `string` | `"ExistingCompliant"` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) The Scope at which the Policy Remediation should be applied. Changing this forces a new resource to be created. A scope must be a Resource ID out of one of the following list: | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->