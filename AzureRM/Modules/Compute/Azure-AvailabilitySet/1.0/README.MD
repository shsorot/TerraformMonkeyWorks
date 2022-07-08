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
| [azurerm_availability_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_proximity_placement_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/proximity_placement_group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Location to provision the Availability Set | `string` | n/a | yes |
| <a name="input_managed"></a> [managed](#input\_managed) | (Optional) Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic). Default is true. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the availability set | `string` | n/a | yes |
| <a name="input_platform_fault_domain_count"></a> [platform\_fault\_domain\_count](#input\_platform\_fault\_domain\_count) | Number of Fault Domain | `number` | `2` | no |
| <a name="input_platform_update_domain_count"></a> [platform\_update\_domain\_count](#input\_platform\_update\_domain\_count) | Number of update domains | `number` | `5` | no |
| <a name="input_proximity_placement_group"></a> [proximity\_placement\_group](#input\_proximity\_placement\_group) | (Optional) The ID of the Proximity Placement Group to which this Virtual Machine should be assigned. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_proximity_placement_groups"></a> [proximity\_placement\_groups](#input\_proximity\_placement\_groups) | (Optional) Output of module Azure-ProximityPlacementGroup for lookup of PPG ID. | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Availability Set. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Availability Set. |
| <a name="output_platform_fault_domain_count"></a> [platform\_fault\_domain\_count](#output\_platform\_fault\_domain\_count) | Value of platform\_fault\_domain\_count |
| <a name="output_platform_update_domain_count"></a> [platform\_update\_domain\_count](#output\_platform\_update\_domain\_count) | Value of platform\_update\_domain\_count |
<!-- END_TF_DOCS -->