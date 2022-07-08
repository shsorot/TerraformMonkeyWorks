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
| [azurerm_express_route_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_connection) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorization_key"></a> [authorization\_key](#input\_authorization\_key) | (Optional) The authorization key to establish the Express Route Connection. | `string` | n/a | yes |
| <a name="input_enable_internet_security"></a> [enable\_internet\_security](#input\_enable\_internet\_security) | (Optional) Is Internet security enabled for this Express Route Connection? | `bool` | `false` | no |
| <a name="input_express_route_circuit_peering"></a> [express\_route\_circuit\_peering](#input\_express\_route\_circuit\_peering) | (Required) The ID of the Express Route Circuit Peering that this Express Route Connection connects with. Changing this forces a new resource to be created. | <pre>object({<br>    id                         = optional(string)<br>    name                       = optional(string)<br>    resource_group_name        = optional(string)<br>    express_route_circuit_name = optional(string)<br>    tag                        = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_express_route_circuit_peerings"></a> [express\_route\_circuit\_peerings](#input\_express\_route\_circuit\_peerings) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_express_route_gateway"></a> [express\_route\_gateway](#input\_express\_route\_gateway) | (Required) The ID of the Express Route Gateway that this Express Route Connection connects with. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_express_route_gateways"></a> [express\_route\_gateways](#input\_express\_route\_gateways) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Express Route Connection. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_routing"></a> [routing](#input\_routing) | n/a | <pre>object({<br>    associated_route_table = object({ # (Optional) The ID of the Virtual Hub Route Table associated with this Express Route Connection.<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })<br>    propagated_route_table = object({<br>      labels = optional(string)                # (Optional) The list of labels to logically group route tables.<br>      route_table_ids = optional(list(object({ # (Optional) A list of IDs of the Virtual Hub Route Table to propagate routes from Express Route Connection to the route table.<br>        id                  = optional(string)<br>        name                = optional(string)<br>        resource_group_name = optional(string)<br>        key                 = optional(string)<br>      })))<br>    })<br>  })</pre> | `null` | no |
| <a name="input_routing_weight"></a> [routing\_weight](#input\_routing\_weight) | (Optional) The routing weight associated to the Express Route Connection. Possible value is between 0 and 32000. Defaults to 0. | `number` | `0` | no |
| <a name="input_virtual_hub_route_tables"></a> [virtual\_hub\_route\_tables](#input\_virtual\_hub\_route\_tables) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->