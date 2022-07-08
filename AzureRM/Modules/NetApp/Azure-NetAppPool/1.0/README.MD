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
| [azurerm_netapp_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_pool) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_netapp_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/netapp_account) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | (Required) The name of the NetApp Account. Specify either the actual name or the Tag value that can be used to look up NetApp Account properties from output of module Azure-NetAppAccount. | <pre>object({<br>    name = optional(string) # Name of the NetApp Account <br>    key  = optional(string) # alternatively, the tag specifying the NetApp Account from the output of module Azure-NetAppAccount<br>  })</pre> | n/a | yes |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the Log Analytics Cluster should exist. Changing this forces a new Log Analytics Cluster to be created. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the NetApp Pool. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_netapp_accounts"></a> [netapp\_accounts](#input\_netapp\_accounts) | (Optional) Output of Module Azure-NetAppAccount. Used to lookup NetApp Account properties using Tags | <pre>map(object({<br>    id   = string # Resource ID of the NetApp account<br>    name = string # Name of the NetApp Account <br>  }))</pre> | `{}` | no |
| <a name="input_qos_type"></a> [qos\_type](#input\_qos\_type) | (Optional) QoS Type of the pool. Valid values include Auto or Manual. Cannot be changed back to Auto once changed. | `string` | `"Auto"` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_service_level"></a> [service\_level](#input\_service\_level) | (Required) The service level of the file system. Valid values include Premium, Standard, or Ultra. Changing this forces a new resource to be created. | `string` | `"Standard"` | no |
| <a name="input_size_in_tb"></a> [size\_in\_tb](#input\_size\_in\_tb) | (Required) Provisioned size of the pool in TB. Value must be between 4 and 500. | `number` | `4` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_name"></a> [account\_name](#output\_account\_name) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_service_level"></a> [service\_level](#output\_service\_level) | n/a |
| <a name="output_size_in_tb"></a> [size\_in\_tb](#output\_size\_in\_tb) | n/a |
<!-- END_TF_DOCS -->