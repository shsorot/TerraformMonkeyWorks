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
| [azurerm_management_group_subscription_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_subscription_association) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_management_group"></a> [management\_group](#input\_management\_group) | (Optional) The ID of the Parent Management Group. Changing this forces a new resource to be created. | <pre>object({<br>    id   = optional(string)<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_management_groups"></a> [management\_groups](#input\_management\_groups) | n/a | <pre>map(object({<br>    id = optional(string) # Output of the module Azure-ManagementGroup<br>  }))</pre> | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | (Optional) The ID of the Subscription to be associated with the Management Group. Changing this forces a new Management to be created. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->