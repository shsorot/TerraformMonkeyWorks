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
| [azurerm_virtual_hub_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_hub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_hub) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_internet_security_enabled"></a> [internet\_security\_enabled](#input\_internet\_security\_enabled) | (Optional) Should Internet Security be enabled to secure internet traffic? Changing this forces a new resource to be created. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The Name which should be used for this Connection, which must be unique within the Virtual Hub. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_remote_virtual_network"></a> [remote\_virtual\_network](#input\_remote\_virtual\_network) | (Required) The ID of the Virtual Network which the Virtual Hub should be connected to. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    subscription_id     = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_remote_virtual_networks"></a> [remote\_virtual\_networks](#input\_remote\_virtual\_networks) | n/a | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | n/a | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_routing"></a> [routing](#input\_routing) | n/a | <pre>object({<br>    associated_route_table = object({<br>      id   = optional(string)<br>      name = optional(string)<br>      key  = optional(string)<br>    })<br>    propagated_route_table = object({<br>      labels = optional(string)<br>      route_table = list(object({<br>        id   = optional(string)<br>        name = optional(string)<br>        key  = optional(string)<br>      }))<br>    })<br>    static_vnet_route = object({<br>      name                = optional(string)<br>      address_prefixes    = optional(list(string))<br>      next_hop_ip_address = optional(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_virtual_hub"></a> [virtual\_hub](#input\_virtual\_hub) | (Required) The ID of the Virtual Hub within which this connection should be created. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_hubs"></a> [virtual\_hubs](#input\_virtual\_hubs) | n/a | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->