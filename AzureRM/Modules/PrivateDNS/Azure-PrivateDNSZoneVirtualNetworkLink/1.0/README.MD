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
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Private DNS Zone Virtual Network Link. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_private_dns_zone"></a> [private\_dns\_zone](#input\_private\_dns\_zone) | (Required) The name of the Private DNS zone (without a terminating dot). Changing this forces a new resource to be created. | <pre>object({<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | (Optional) Output of module Azure-PrivateDNSZone. Used to lookup DNS zone ID and properties using key. | <pre>map(object({<br>    id    = optional(string)<br>    name  = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_registration_enabled"></a> [registration\_enabled](#input\_registration\_enabled) | (Optional) Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to false. | `string` | `false` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_virtual_network"></a> [virtual\_network](#input\_virtual\_network) | (Required) The ID of the Virtual Network that should be linked to the DNS Zone. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual\_network\_tag' and 'virtual\_network\_tag' | <pre>map(object({<br>    id   = string # Resource ID of the virtual Network<br>    name = string # Name of the Virtual Network<br>    subnet = map(object({<br>      id = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->