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
| [azurerm_virtual_machine_extension.addsdomainjoin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_directory_domain"></a> [active\_directory\_domain](#input\_active\_directory\_domain) | The name of the Active Directory domain to join | `string` | n/a | yes |
| <a name="input_active_directory_password"></a> [active\_directory\_password](#input\_active\_directory\_password) | The password of the account with permissions to bind machines to the Active Directory Domain | `string` | n/a | yes |
| <a name="input_active_directory_username"></a> [active\_directory\_username](#input\_active\_directory\_username) | The username of an account with permissions to bind machines to the Active Directory Domain | `string` | n/a | yes |
| <a name="input_ou_path"></a> [ou\_path](#input\_ou\_path) | An organizational unit (OU) within an Active Directory to place computers | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_virtual_machine"></a> [virtual\_machine](#input\_virtual\_machine) | (Required) The ID of the Virtual Machine. Changing this forces a new resource to be created | <pre>object({<br>    id                  = optional(string),<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_machines"></a> [virtual\_machines](#input\_virtual\_machines) | n/a | <pre>map(object({<br>    id = optional(string),<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->