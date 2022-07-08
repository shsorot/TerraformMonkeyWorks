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
| [azurerm_express_route_circuit.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_classic_operations"></a> [allow\_classic\_operations](#input\_allow\_classic\_operations) | (Optional) Allow the circuit to interact with classic (RDFE) resources. Defaults to false. | `bool` | `false` | no |
| <a name="input_bandwidth_in_gbps"></a> [bandwidth\_in\_gbps](#input\_bandwidth\_in\_gbps) | (Optional) The bandwidth in Gbps of the circuit being created on the Express Route Port. | `number` | `null` | no |
| <a name="input_bandwidth_in_mbps"></a> [bandwidth\_in\_mbps](#input\_bandwidth\_in\_mbps) | (Optional) The bandwidth in Mbps of the circuit being created on the Service Provider. | `number` | n/a | yes |
| <a name="input_express_route_port"></a> [express\_route\_port](#input\_express\_route\_port) | (Optional) The ID of the Express Route Port this Express Route Circuit is based on. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_express_route_ports"></a> [express\_route\_ports](#input\_express\_route\_ports) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the ExpressRoute circuit. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_peering_location"></a> [peering\_location](#input\_peering\_location) | (Optional) The name of the peering location and not the Azure resource location. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_service_provider_name"></a> [service\_provider\_name](#input\_service\_provider\_name) | (Optional) The name of the ExpressRoute Service Provider. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | n/a | <pre>object({<br>    tier   = string #(Required) The service tier. Possible values are Basic, Local, Standard or Premium.<br>    family = string #(Required) The billing mode for bandwidth. Possible values are MeteredData or UnlimitedData.<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_service_key"></a> [service\_key](#output\_service\_key) | n/a |
| <a name="output_service_provider_provisioning_state"></a> [service\_provider\_provisioning\_state](#output\_service\_provider\_provisioning\_state) | n/a |
<!-- END_TF_DOCS -->