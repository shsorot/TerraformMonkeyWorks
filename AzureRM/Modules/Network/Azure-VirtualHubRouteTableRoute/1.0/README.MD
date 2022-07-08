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
| [azurerm_virtual_hub_route_table_route.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_route_table_route) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destinations"></a> [destinations](#input\_destinations) | (Required) A list of destination addresses for this route. | `list(string)` | n/a | yes |
| <a name="input_destinations_type"></a> [destinations\_type](#input\_destinations\_type) | (Required) The type of destinations. Possible values are CIDR, ResourceId and Service. Defaults to CIDR | `string` | `"CIDR"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this route. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_next_hop"></a> [next\_hop](#input\_next\_hop) | (Required) The next hop's resource ID ( azurerm\_virtual\_hub\_connection ) | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    virtual_hub_name    = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_next_hop_type"></a> [next\_hop\_type](#input\_next\_hop\_type) | (Optional) The type of next hop. Currently the only possible value is ResourceId. Defaults to ResourceId. | `string` | `"ResourceId"` | no |
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | n/a | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    virtual_hub_name    = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | n/a | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_virtual_hub_connections"></a> [virtual\_hub\_connections](#input\_virtual\_hub\_connections) | n/a | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->