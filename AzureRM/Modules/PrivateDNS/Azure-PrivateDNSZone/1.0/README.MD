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
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Private DNS Zone. Must be a valid domain name. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_soa_record"></a> [soa\_record](#input\_soa\_record) | n/a | <pre>object({<br>    email        = string                #   (Required) The email contact for the SOA record.<br>    expire_time  = optional(string)      #   (Optional) The expire time for the SOA record. Defaults to 2419200.<br>    minimum_ttl  = optional(string)      #   (Optional) The minimum Time To Live for the SOA record. By convention, it is used to determine the negative caching duration. Defaults to 10<br>    refresh_time = optional(string)      #   (Optional) The refresh time for the SOA record. Defaults to 3600.<br>    retry_time   = optional(string)      #   (Optional) The retry time for the SOA record. Defaults to 300.<br>    ttl          = optional(string)      #   (Optional) The Time To Live of the SOA Record in seconds. Defaults to 3600.<br>    tags         = optional(map(string)) #   (Optional) A mapping of tags to assign to the Record Set.<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_max_number_of_record_sets"></a> [max\_number\_of\_record\_sets](#output\_max\_number\_of\_record\_sets) | n/a |
| <a name="output_max_number_of_virtual_network_links"></a> [max\_number\_of\_virtual\_network\_links](#output\_max\_number\_of\_virtual\_network\_links) | n/a |
| <a name="output_max_number_of_virtual_network_links_with_registration"></a> [max\_number\_of\_virtual\_network\_links\_with\_registration](#output\_max\_number\_of\_virtual\_network\_links\_with\_registration) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_number_of_record_sets"></a> [number\_of\_record\_sets](#output\_number\_of\_record\_sets) | n/a |
<!-- END_TF_DOCS -->