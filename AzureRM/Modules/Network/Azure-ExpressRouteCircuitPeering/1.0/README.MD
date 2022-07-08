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
| [azurerm_express_route_circuit_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_peering) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_express_route_circuit.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/express_route_circuit) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_express_route_circuit"></a> [express\_route\_circuit](#input\_express\_route\_circuit) | (Required) The name of the ExpressRoute Circuit in which to create the Peering. | <pre>object({<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_express_route_circuits"></a> [express\_route\_circuits](#input\_express\_route\_circuits) | n/a | <pre>map(object({<br>    id   = optional(string)<br>    name = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_ipv6"></a> [ipv6](#input\_ipv6) | n/a | <pre>object({<br>    microsoft_peering = object({<br>      advertised_public_prefixes = list(string)     # (Required) A list of Advertised Public Prefixes.<br>      customer_asn               = optional(string) # (Optional) The CustomerASN of the peering.<br>      routing_registry_name      = optional(string) # (Optional) The Routing Registry against which the AS number and prefixes are registered. For example: ARIN, RIPE, AFRINIC etc.<br>    })<br>  })</pre> | `null` | no |
| <a name="input_microsoft_peering_config"></a> [microsoft\_peering\_config](#input\_microsoft\_peering\_config) | n/a | <pre>object({<br>    advertised_public_prefixes = optional(list(string)) # (Required) A list of Advertised Public Prefixes.<br>    customer_asn               = optional(string)       # (Optional) The CustomerASN of the peering.<br>    routing_registry_name      = optional(string)       # (Optional) The Routing Registry against which the AS number and prefixes are registered. For example: ARIN, RIPE, AFRINIC etc.<br>  })</pre> | `null` | no |
| <a name="input_peer_asn"></a> [peer\_asn](#input\_peer\_asn) | (Optional) The Either a 16-bit or a 32-bit ASN. Can either be public or private. | `string` | `null` | no |
| <a name="input_peering_type"></a> [peering\_type](#input\_peering\_type) | (Required) The type of the ExpressRoute Circuit Peering. Acceptable values include AzurePrivatePeering, AzurePublicPeering and MicrosoftPeering. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_primary_peer_address_prefix"></a> [primary\_peer\_address\_prefix](#input\_primary\_peer\_address\_prefix) | (Required) A /30 subnet for the primary link. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group in which to create the Express Route Circuit Peering. Changing this forces a new resource to be created. | <pre>object({<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_route_filter"></a> [route\_filter](#input\_route\_filter) | (Optional) The ID of the Route Filter. Only available when peering\_type is set to MicrosoftPeering. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_route_filters"></a> [route\_filters](#input\_route\_filters) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_secondary_peer_address_prefix"></a> [secondary\_peer\_address\_prefix](#input\_secondary\_peer\_address\_prefix) | (Required) A /30 subnet for the secondary link. | `string` | n/a | yes |
| <a name="input_shared_key"></a> [shared\_key](#input\_shared\_key) | (Optional) The shared key. Can be a maximum of 25 characters. | `string` | `null` | no |
| <a name="input_vlan_id"></a> [vlan\_id](#input\_vlan\_id) | (Required) A valid VLAN ID to establish this peering on. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_asn"></a> [azure\_asn](#output\_azure\_asn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_primary_azure_port"></a> [primary\_azure\_port](#output\_primary\_azure\_port) | n/a |
| <a name="output_secondary_azure_port"></a> [secondary\_azure\_port](#output\_secondary\_azure\_port) | n/a |
<!-- END_TF_DOCS -->