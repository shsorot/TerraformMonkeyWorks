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
| [azurerm_virtual_hub_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_route_table) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_hub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_hub) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) List of labels associated with this route table. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Virtual Hub IP. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_route"></a> [route](#input\_route) | <TODO> add a resource lookup for azurerm\_virtual\_hub\_connection for next\_hop sub property | <pre>object({<br>    name              = string       #(Required) The name which should be used for this route.<br>    destinations      = list(string) #(Required) The list of destinations for this route.<br>    destinations_type = string       #(Required) The type of destination for this route. Possible values are CIDR, ResourceId and Service<br>    next_hop          = string       # (Required) The next hop's resource id( virtual hub connection)<br>    next_hop_type     = string       # (Optional) The type of next hop. Currently the only possible value is ResourceId. Defaults to ResourceId.<br>  })</pre> | n/a | yes |
| <a name="input_virtual_hub"></a> [virtual\_hub](#input\_virtual\_hub) | (Required) The ID of the Virtual Hub within which this ip configuration should be created. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_hubs"></a> [virtual\_hubs](#input\_virtual\_hubs) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->