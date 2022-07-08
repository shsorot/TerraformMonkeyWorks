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
| [azurerm_route.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/route_table) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefix"></a> [address\_prefix](#input\_address\_prefix) | (Required) The destination CIDR to which the route applies, such as 10.1.0.0/16 | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the route. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_next_hop_in_ip_address"></a> [next\_hop\_in\_ip\_address](#input\_next\_hop\_in\_ip\_address) | (Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. | `string` | n/a | yes |
| <a name="input_next_hop_type"></a> [next\_hop\_type](#input\_next\_hop\_type) | (Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | `string` | n/a | yes |
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | (Required) The name of the route table within which create the route. Changing this forces a new resource to be created. | <pre>object({<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | n/a | <pre>map(object({<br>    id   = optional(string)<br>    name = optional(string)<br>    key  = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_route"></a> [route](#output\_route) | n/a |
<!-- END_TF_DOCS -->