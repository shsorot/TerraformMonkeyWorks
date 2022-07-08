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
| [azurerm_virtual_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_local_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/local_network_gateway) | data source |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_active"></a> [active\_active](#input\_active\_active) | (Optional) If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false. | `bool` | `false` | no |
| <a name="input_bgp_settings"></a> [bgp\_settings](#input\_bgp\_settings) | n/a | <pre>list(object({<br>    asn = optional(string)                     # (Optional) The Autonomous System Number (ASN) to use as part of the BGP.<br>    peering_addresses = list(object({          # (Optional) A list of peering_addresses as defined below. Only one peering_addresses block can be specified except when active_active of this Virtual Network Gateway is true.<br>      ip_configuration_name = optional(string) # (Optional) The name of the IP configuration of this Virtual Network Gateway. In case there are multiple ip_configuration blocks defined, this property is required to specify.<br>      apipa_addresses       = optional(string) # (Optional) A list of Azure custom APIPA addresses assigned to the BGP peer of the Virtual Network Gateway.<br>    }))<br>    peer_weight = optional(string) # (Optional) The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100.<br>  }))</pre> | `null` | no |
| <a name="input_custom_route"></a> [custom\_route](#input\_custom\_route) | n/a | <pre>object({<br>    address_prefixes = list(string) # (Optional) A list of address blocks reserved for this virtual network in CIDR notation.<br>  })</pre> | `null` | no |
| <a name="input_default_local_network_gateway"></a> [default\_local\_network\_gateway](#input\_default\_local\_network\_gateway) | (Optional) The ID of the local network gateway through which outbound Internet traffic from the virtual network in which the gateway is created will be routed (forced tunnelling). Refer to the Azure documentation on forced tunnelling. If not specified, forced tunnelling is disabled. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | (Optional) If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false. | `bool` | `false` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | (Optional) The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None. | `string` | `"None"` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | (Required) Boolean value to denote if if should inherit tags from parent resource group. | `bool` | `false` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | n/a | <pre>object({<br>    private_ip_address_allocation = optional(string) # (Optional) Defines how the private IP address of the gateways virtual interface is assigned. Valid options are Static or Dynamic. Defaults to Dynamic.<br>    subnet = object({                                # (Required) The ID of the gateway subnet of a virtual network in which the virtual network gateway will be created. It is mandatory that the associated subnet is named GatewaySubnet. Therefore, each virtual network can contain at most a single Virtual Network Gateway.<br>      id                   = optional(string)<br>      virtual_network_name = optional(string)<br>      resource_group_name  = optional(string)<br>      virtual_network_key  = optional(string)<br>    })<br>    public_ip_address = object({ # (Required) The ID of the public ip address to associate with the Virtual Network Gateway.<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_local_network_gateways"></a> [local\_network\_gateways](#input\_local\_network\_gateways) | n/a | <pre>map(object({<br>    id = string<br>  }))</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location/region where the virtual network gateway is created. Changing this forces a new resource to be created. <br>  If Null, location from resource group is used. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Virtual Network Gateway. Changing the name forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_private_ip_address_enabled"></a> [private\_ip\_address\_enabled](#input\_private\_ip\_address\_enabled) | (Optional) Should private IP be enabled on this gateway for connections? Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_public_ip_addresses"></a> [public\_ip\_addresses](#input\_public\_ip\_addresses) | (Required) Public IP address output from Azure-PublicIPAddress module. IP address must be of type static and standard. | <pre>map(object({<br>    fqdn    = optional(string)<br>    id      = string<br>    address = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn\_type and generation arguments. A PolicyBased gateway only supports the Basic sku. Further, the UltraPerformance sku is only supported by an ExpressRoute gateway. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | (Required) The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute. Changing the type forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | n/a | <pre>map(object({<br>    id = optional(string)<br>    subnet = map(object({<br>      id = optional(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_vpn_client_configuration"></a> [vpn\_client\_configuration](#input\_vpn\_client\_configuration) | n/a | <pre>object({<br>    address_space = string<br>    aad_tenant    = optional(string)<br>    aad_audience  = optional(string)<br>    aad_issuer    = optional(string)<br>    root_certificate = optional(list(object({<br>      name             = string<br>      public_cert_data = string<br>    })))<br>    revoked_certificate = optional(list(object({<br>      name       = string<br>      thumbprint = string<br>    })))<br>    radius_server_address = optional(string)<br>    radius_server_secret  = optional(string)<br>    vpn_client_protocols  = optional(string)<br>    vpn_auth_types        = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | (Optional) The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased. | `string` | `"RouteBased"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bgp_settings"></a> [bgp\_settings](#output\_bgp\_settings) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->