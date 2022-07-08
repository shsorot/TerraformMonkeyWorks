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
| [azurerm_virtual_network_gateway_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_express_route_circuit.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/express_route_circuit) | data source |
| [azurerm_local_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/local_network_gateway) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network_gateway.peer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network_gateway) | data source |
| [azurerm_virtual_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network_gateway) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorization_key"></a> [authorization\_key](#input\_authorization\_key) | (Optional) The authorization key associated with the Express Route Circuit. This field is required only if the type is an ExpressRoute connection. | `string` | `null` | no |
| <a name="input_connection_protocol"></a> [connection\_protocol](#input\_connection\_protocol) | (Optional) The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2. Changing this value will force a resource to be created. -> Note: Only valid for IPSec connections on virtual network gateways with SKU VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ or VpnGw3AZ. | `string` | `"IKev2"` | no |
| <a name="input_dpd_timeout_seconds"></a> [dpd\_timeout\_seconds](#input\_dpd\_timeout\_seconds) | (Optional) The dead peer detection timeout of this connection in seconds. Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | (Optional) If true, BGP (Border Gateway Protocol) is enabled for this connection. Defaults to false. | `bool` | `false` | no |
| <a name="input_express_route_circuit"></a> [express\_route\_circuit](#input\_express\_route\_circuit) | (Optional) The ID of the Express Route Circuit when creating an ExpressRoute connection (i.e. when type is ExpressRoute). The Express Route Circuit can be in the same or in a different subscription. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_express_route_circuits"></a> [express\_route\_circuits](#input\_express\_route\_circuits) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_express_route_gateway_bypass"></a> [express\_route\_gateway\_bypass](#input\_express\_route\_gateway\_bypass) | (Optional) If true, data packets will bypass ExpressRoute Gateway for data forwarding This is only valid for ExpressRoute connections. | `bool` | `false` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | (Required) Boolean value to denote if if should inherit tags from parent resource group. | `bool` | `false` | no |
| <a name="input_ipsec_policy"></a> [ipsec\_policy](#input\_ipsec\_policy) | (Optional) A ipsec\_policy block which is documented below. Only a single policy can be defined for a connection. For details on custom policies refer to the relevant section in the Azure documentation. | <pre>object({<br>    dh_group         = string #(Required) The DH group used in IKE phase 1 for initial SA. Valid options are DHGroup1, DHGroup14, DHGroup2, DHGroup2048, DHGroup24, ECP256, ECP384, or None.<br>    ike_encryption   = string #(Required) The IKE encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, or GCMAES256.<br>    ike_integrity    = string #(Required) The IKE integrity algorithm. Valid options are GCMAES128, GCMAES256, MD5, SHA1, SHA256, or SHA384.<br>    ipsec_encryption = string # (Required) The IPSec encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, GCMAES192, GCMAES256, or None.<br>    ipsec_integrity  = string # (Required) The IPSec integrity algorithm. Valid options are GCMAES128, GCMAES192, GCMAES256, MD5, SHA1, or SHA256.<br>    pfs_group        = string #(Required) The DH group used in IKE phase 2 for new child SA. Valid options are ECP256, ECP384, PFS1, PFS14, PFS2, PFS2048, PFS24, PFSMM, or None.<br>    sa_datasize      = number #(Optional) The IPSec SA payload size in KB. Must be at least 1024 KB. Defaults to 102400000 KB.<br>    sa_lifetime      = number #(Optional) The IPSec SA lifetime in seconds. Must be at least 300 seconds. Defaults to 27000 seconds.<br>  })</pre> | `null` | no |
| <a name="input_local_azure_ip_address_enabled"></a> [local\_azure\_ip\_address\_enabled](#input\_local\_azure\_ip\_address\_enabled) | (Optional) Use private local Azure IP for the connection. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_local_network_gateway"></a> [local\_network\_gateway](#input\_local\_network\_gateway) | (Optional) The ID of the local network gateway when creating Site-to-Site connection (i.e. when type is IPsec). | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_local_network_gateways"></a> [local\_network\_gateways](#input\_local\_network\_gateways) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location of the resource. If not provided, the location of the resource group will be used. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the connection. Changing the name forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_peer_virtual_network_gateway"></a> [peer\_virtual\_network\_gateway](#input\_peer\_virtual\_network\_gateway) | (Optional) The ID of the peer virtual network gateway when creating a VNet-to-VNet connection (i.e. when type is Vnet2Vnet). The peer Virtual Network Gateway can be in the same or in a different subscription. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_routing_weight"></a> [routing\_weight](#input\_routing\_weight) | (Optional) The routing weight. Defaults to 10. | `number` | `10` | no |
| <a name="input_shared_key"></a> [shared\_key](#input\_shared\_key) | (Optional) The shared IPSec key. A key could be provided if a Site-to-Site, VNet-to-VNet or ExpressRoute connection is created. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_traffic_selector_policy"></a> [traffic\_selector\_policy](#input\_traffic\_selector\_policy) | (Optional)A traffic\_selector\_policy which allows to specify traffic selector policy proposal to be used in a virtual network gateway connection. Only one block can be defined for a connection. For details about traffic selectors refer to the relevant section in the Azure documentation. | <pre>object({<br>    local_address_cidrs  = list(string)<br>    remote_address_cidrs = list(string)<br>  })</pre> | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | (Required) The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet). Each connection type requires different mandatory arguments (refer to the examples above). Changing the connection type will force a new connection to be created. | `string` | n/a | yes |
| <a name="input_use_policy_based_traffic_selectors"></a> [use\_policy\_based\_traffic\_selectors](#input\_use\_policy\_based\_traffic\_selectors) | (Optional) If true, policy-based traffic selectors are enabled for this connection. Enabling policy-based traffic selectors requires an ipsec\_policy block. Defaults to false. | `bool` | `false` | no |
| <a name="input_virtual_network_gateway"></a> [virtual\_network\_gateway](#input\_virtual\_network\_gateway) | (Required) The ID of the Virtual Network Gateway in which the connection will be created. Changing the gateway forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_network_gateways"></a> [virtual\_network\_gateways](#input\_virtual\_network\_gateways) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->