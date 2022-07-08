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
| [azurerm_virtual_hub_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_ip) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_hub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_hub) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Virtual Hub IP. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | (Optional) The private IP address of the IP configuration. | `string` | `null` | no |
| <a name="input_private_ip_allocation_method"></a> [private\_ip\_allocation\_method](#input\_private\_ip\_allocation\_method) | (Optional) The private IP address allocation method. Possible values are Static and Dynamic is allowed. Defaults to Dynamic. | `string` | `null` | no |
| <a name="input_public_ip_address"></a> [public\_ip\_address](#input\_public\_ip\_address) | (Optional) The ID of the Public IP Address. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_public_ip_addresses"></a> [public\_ip\_addresses](#input\_public\_ip\_addresses) | (Required) Public IP address output from Azure-PublicIPAddress module. IP address must be of type static and standard. | <pre>map(object({<br>    fqdn    = string<br>    id      = string<br>    address = string<br>  }))</pre> | n/a | yes |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Required) The ID of the Subnet that the IP will reside. Changing this forces a new resource to be created. | <pre>object({<br>    id                   = optional(string)<br>    name                 = optional(string)<br>    virtual_network_name = optional(string)<br>    resource_group_name  = optional(string)<br>    tag                  = optional(string)<br>    virtual_network_key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_hub"></a> [virtual\_hub](#input\_virtual\_hub) | (Required) The ID of the Virtual Hub within which this ip configuration should be created. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_hubs"></a> [virtual\_hubs](#input\_virtual\_hubs) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | n/a | <pre>map(object({<br>    id = optional(string)<br>    subnet = map(object({<br>      id = optional(string)<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->