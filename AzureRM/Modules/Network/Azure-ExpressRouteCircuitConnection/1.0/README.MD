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
| [azurerm_express_route_circuit_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_connection) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefix_ipv4"></a> [address\_prefix\_ipv4](#input\_address\_prefix\_ipv4) | (Required) The IPv4 address space from which to allocate customer address for global reach. Changing this forces a new Express Route Circuit Connection to be created. | `string` | n/a | yes |
| <a name="input_address_prefix_ipv6"></a> [address\_prefix\_ipv6](#input\_address\_prefix\_ipv6) | (Optional) The IPv6 address space from which to allocate customer addresses for global reach. | `string` | n/a | yes |
| <a name="input_authorization_key"></a> [authorization\_key](#input\_authorization\_key) | (Optional) The authorization key which is associated with the Express Route Circuit Connection. | `string` | n/a | yes |
| <a name="input_express_route_circuit_peerings"></a> [express\_route\_circuit\_peerings](#input\_express\_route\_circuit\_peerings) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Express Route Circuit Connection. Changing this forces a new Express Route Circuit Connection to be created. | `string` | n/a | yes |
| <a name="input_peer_peering"></a> [peer\_peering](#input\_peer\_peering) | (Required) The ID of the peered Express Route Circuit Private Peering. Changing this forces a new Express Route Circuit Connection to be created. | <pre>object({<br>    id                         = optional(string)<br>    name                       = optional(string)<br>    resource_group_name        = optional(string)<br>    express_route_circuit_name = optional(string)<br>    subscription_id            = optional(string)<br>    tag                        = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_peering"></a> [peering](#input\_peering) | (Required) The ID of the Express Route Circuit Private Peering that this Express Route Circuit Connection connects with. Changing this forces a new Express Route Circuit Connection to be created. | <pre>object({<br>    id                         = optional(string)<br>    name                       = optional(string)<br>    resource_group_name        = optional(string)<br>    express_route_circuit_name = optional(string)<br>    subscription_id            = optional(string)<br>    tag                        = optional(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->