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
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_security_groups"></a> [application\_security\_groups](#input\_application\_security\_groups) | n/a | <pre>map(object({<br>    id = string<br>  }))</pre> | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_nsg_rule"></a> [nsg\_rule](#input\_nsg\_rule) | n/a | <pre>list(object({<br>    name                    = string<br>    description             = optional(string)<br>    direction               = string                 # Can be "Inbound" or "Outbound"<br>    priority                = number                 # A value between 100 and 4096<br>    access                  = string                 # Can be "Allow" or "Deny"<br>    protocol                = string                 # Can be "tcp", "udp", "icmp" or "*"<br>    source_address_prefix   = optional(string)       # A CIDR range, a service tag (e.g. "VirtualNetwork") or "*" (null defaults to "*"). Ignored if either <source_address_prefixes> or <source_application_security_group_ids> is set.<br>    source_address_prefixes = optional(list(string)) # An array of CIDR ranges (neither service tags nor "*" can be used). Ignored if <source_application_security_group_ids> is set.<br>    source_application_security_group = optional(list(object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })))<br>    source_port_range            = optional(string)       # Can be a number (e.g. "445"), a range (e.g. "1024-2048") or "*" (null defaults to "*"). Ignored if <source_port_ranges> is set.<br>    source_port_ranges           = optional(list(string)) # An array of numbers or ranges ("*" cannot be used)<br>    destination_address_prefix   = optional(string)       # A CIDR range, a service tag (e.g. "VirtualNetwork") or "*" (null defaults to "*"). Ignored if either <destination_address_prefixes> or <destination_application_security_group_ids> is set.<br>    destination_address_prefixes = optional(list(string)) # An array of CIDR ranges (neither service tags nor "*" can be used). Ignored if <destination_application_security_group_ids> is set.<br>    destination_application_security_group = optional(list(object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })))<br>    destination_port_range  = optional(string)       # Can be a number (e.g. "445"), a range (e.g. "1024-2048") or "*" (null defaults to "*"). Ignored if <destination_port_ranges> is set.<br>    destination_port_ranges = optional(list(string)) # An array of numbers or ranges ("*" cannot be used)<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_nsg_rule"></a> [nsg\_rule](#output\_nsg\_rule) | n/a |
<!-- END_TF_DOCS -->