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
| [azurerm_lb_backend_address_pool_address.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool_address) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_lb.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb) | data source |
| [azurerm_lb_backend_address_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb_backend_address_pool) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_address_pool"></a> [backend\_address\_pool](#input\_backend\_address\_pool) | (Required) The ID of the Backend Address Pool. Changing this forces a new Backend Address Pool Address to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    loadbalancer_name   = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | (Required) The Static IP Address which should be allocated to this Backend Address Pool. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Backend Address Pool Address. Changing this forces a new Backend Address Pool Address to be created. | `string` | n/a | yes |
| <a name="input_virtual_network"></a> [virtual\_network](#input\_virtual\_network) | (Required) The ID of the Virtual Network within which the Backend Address Pool should exist. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual\_network\_tag' and 'virtual\_network\_tag' | <pre>map(object({<br>    id   = string # Resource ID of the virtual Network<br>    name = string # Name of the Virtual Network<br>    subnet = map(object({<br>      id = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->