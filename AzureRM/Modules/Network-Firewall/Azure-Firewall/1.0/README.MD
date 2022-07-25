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
| [azurerm_firewall.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/firewall_policy) | data source |
| [azurerm_public_ip.management-this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.management-this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_hub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_hub) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution. | `list(string)` | `null` | no |
| <a name="input_firewall_policies"></a> [firewall\_policies](#input\_firewall\_policies) | (Optional) Output of module Azure-FirewallPolicy | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_firewall_policy"></a> [firewall\_policy](#input\_firewall\_policy) | (Optional) The ID of the Firewall Policy applied to this Firewall. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | n/a | <pre>object({<br>    name = optional(string) # (Required) Specifies the name of the IP Configuration.<br>    subnet = object({       # (Required) Specifies the subnet of the IP Configuration.Must be /26 and named "AzureFirewallSubnet"<br>      id                   = optional(string)<br>      virtual_network_name = optional(string)<br>      resource_group_name  = optional(string)<br>      virtual_network_key  = optional(string)<br>    })<br>    public_ip_address = object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_management_ip_configuration"></a> [management\_ip\_configuration](#input\_management\_ip\_configuration) | n/a | <pre>object({<br>    name = optional(string) # (Required) Specifies the name of the IP Configuration.<br>    subnet = object({       # (Required) The Management Subnet used for the Firewall must have the name AzureFirewallManagementSubnet and the subnet mask must be at least a /26.<br>      id                   = optional(string)<br>      virtual_network_name = optional(string)<br>      resource_group_name  = optional(string)<br>      virtual_network_key  = optional(string)<br>    })<br>    public_ip_address = object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Firewall. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_private_ip_ranges"></a> [private\_ip\_ranges](#input\_private\_ip\_ranges) | (Optional) A list of SNAT private CIDR IP ranges, or the special string IANAPrivateRanges, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918. | `list(string)` | `null` | no |
| <a name="input_public_ip_addresses"></a> [public\_ip\_addresses](#input\_public\_ip\_addresses) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) Sku name of the Firewall. Possible values are AZFW\_Hub and AZFW\_VNet. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | (Optional) Sku tier of the Firewall. Possible values are Premium and Standard. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_threat_intel_mode"></a> [threat\_intel\_mode](#input\_threat\_intel\_mode) | (Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert,Deny and ''(empty string). Defaults to Alert | `string` | `null` | no |
| <a name="input_virtual_hub"></a> [virtual\_hub](#input\_virtual\_hub) | n/a | <pre>object({<br>    public_ip_count = optional(number) # (Optional) Specifies the number of public IPs to assign to the Firewall. Defaults to 1.<br>    virtual_hub = object({             # (Required) Specifies the ID of the Virtual Hub where the Firewall resides in.<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_virtual_hubs"></a> [virtual\_hubs](#input\_virtual\_hubs) | (Optional)Output of module Azure-VirtualHub | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | n/a | <pre>map(object({<br>    id = optional(string)<br>    subnet = map(object({<br>      id = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) A list of availability zones where the Firewall will be created. Defaults to null. | `list(number)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_ip_configuration"></a> [ip\_configuration](#output\_ip\_configuration) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_virtual_hub"></a> [virtual\_hub](#output\_virtual\_hub) | n/a |
<!-- END_TF_DOCS -->