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
| [azurerm_lb.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_frontend_ip_configuration"></a> [frontend\_ip\_configuration](#input\_frontend\_ip\_configuration) | (Optional) One or multiple frontend\_ip\_configuration blocks as documented below. | <pre>list(object({<br>    name = string # Required) Specifies the name of the frontend ip configuration.<br>    subnet = object({<br>      id                   = optional(string)<br>      name                 = optional(string)<br>      virtual_network_name = optional(string)<br>      resource_group_name  = optional(string)<br>      tag                  = optional(string)<br>      virtual_network_key  = optional(string)<br>    })<br><br>    private_ip_address            = optional(any)    # (Optional) Private IP Address to assign to the Load Balancer. The last one and first four IPs in any range are reserved and cannot be manually assigned.<br>    private_ip_address_allocation = optional(string) # (Optional) The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static.<br>    private_ip_address_version    = optional(string) # The version of IP that the Private IP Address is. Possible values are IPv4 or IPv6<br><br>    public_ip_address = optional(object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    }))<br><br>    public_ip_prefix = optional(object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    }))<br><br>    # availability_zone = optional(string) # (Optional) Refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#availability_zone <br>    zones = optional(list(string)) #(Optional) Refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#availability_zone <br>  }))</pre> | `[]` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Load Balancer. | `string` | n/a | yes |
| <a name="input_public_ip_addresses"></a> [public\_ip\_addresses](#input\_public\_ip\_addresses) | (Required) Public IP address output from Azure-PublicIPAddress module. IP address must be of type static and standard. | <pre>map(object({<br>    fqdn    = optional(string)<br>    id      = string<br>    address = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_public_ip_prefixes"></a> [public\_ip\_prefixes](#input\_public\_ip\_prefixes) | (Optional) Output of Module Azure-PublicIPPRefix, used to lookup resource ID when var.public\_ip\_prefix\_tag is specified. | <pre>map(object({<br>    id        = string           # Resource ID of the public ip prefix object<br>    ip_prefix = optional(string) # CIDR prefix count of prefix object.<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard. Defaults to Basic. | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual\_network\_tag' and 'virtual\_network\_tag' | <pre>map(object({<br>    id   = string # Resource ID of the virtual Network<br>    name = string # Name of the Virtual Network<br>    subnet = map(object({<br>      id = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_frontend_ip_configuration"></a> [frontend\_ip\_configuration](#output\_frontend\_ip\_configuration) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | n/a |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | n/a |
<!-- END_TF_DOCS -->