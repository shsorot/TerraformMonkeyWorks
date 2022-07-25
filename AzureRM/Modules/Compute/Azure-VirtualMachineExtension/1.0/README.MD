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
| [azurerm_virtual_machine_extension.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_upgrade_minor_version"></a> [auto\_upgrade\_minor\_version](#input\_auto\_upgrade\_minor\_version) | (Optional) Specifies if the platform deploys the latest minor version update to the type\_handler\_version specified. | `bool` | `true` | no |
| <a name="input_automatic_upgrade_enabled"></a> [automatic\_upgrade\_enabled](#input\_automatic\_upgrade\_enabled) | (Optional) Specifies if the extension should be automatically upgraded by the platform if there is a newer version of the extension available. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the virtual machine extension peering. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_protected_settings"></a> [protected\_settings](#input\_protected\_settings) | (Optional) The protected\_settings passed to the extension, like settings, these are specified as a JSON object in a string. | <pre>object({<br>    json = optional(string)<br>    file = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_publisher"></a> [publisher](#input\_publisher) | (Required) The publisher of the extension, available publishers can be found by using the Azure CLI. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | (Required) The settings passed to the extension, these are specified as a JSON object in a string. | <pre>object({<br>    json = optional(string)<br>    file = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | (Required) The type of extension, available types for a publisher can be found using the Azure CLI. | `string` | n/a | yes |
| <a name="input_type_handler_version"></a> [type\_handler\_version](#input\_type\_handler\_version) | (Required) Specifies the version of the extension to use, available versions can be found using the Azure CLI. | `string` | n/a | yes |
| <a name="input_virtual_machine"></a> [virtual\_machine](#input\_virtual\_machine) | (Required) The ID of the Virtual Machine. Changing this forces a new resource to be created | <pre>object({<br>    id                  = optional(string),<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_machines"></a> [virtual\_machines](#input\_virtual\_machines) | n/a | <pre>map(object({<br>    id = optional(string),<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->