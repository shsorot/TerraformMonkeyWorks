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
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_security_group"></a> [application\_security\_group](#input\_application\_security\_group) | n/a | <pre>object({<br>    id                  = optional(string) # Name of the ASG. This will be used to lookup ASG resource in Azure for NIC association.<br>    name                = optional(string)<br>    resource_group_name = optional(string) # Resource group where ASG is located. If null, local.resource_group_name will be used.<br>    key                 = optional(string) # Tag to be used to lookup ASG from the output of module Azure-ApplicationSecurityGroup<br>  })</pre> | `null` | no |
| <a name="input_application_security_groups"></a> [application\_security\_groups](#input\_application\_security\_groups) | (Optional) Output of module Azure-ApplicationSecurityGroup. | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. | `list(string)` | `[]` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | (Optional) Should Accelerated Networking be enabled? Defaults to false. Supported by limited subnet of VM Sku's. | `bool` | `false` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | (Optional) Should IP Forwarding be enabled? Defaults to false | `bool` | `false` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | (Optionla) Inherit tags from resource group. | `bool` | `false` | no |
| <a name="input_internal_dns_name_label"></a> [internal\_dns\_name\_label](#input\_internal\_dns\_name\_label) | (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network. | `string` | `null` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | n/a | <pre>list(object({<br>    name = string # Required, Name of the IP configuration.If Empty, key name is used.<br>    subnet = object({<br>      id                   = optional(string)<br>      name                 = optional(string)<br>      virtual_network_name = optional(string)<br>      resource_group_name  = optional(string)<br>      tag                  = optional(string)<br>      virtual_network_key  = optional(string)<br>    })<br>    private_ip_address         = optional(string) # Private IP Address. If left null, dynamic allocation is used.<br>    private_ip_address_version = optional(string) # (Optional) The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4<br>    primary                    = optional(bool)<br><br>    public_ip_address = optional(object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    }))<br>    backend_address_pool = optional(object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      load_balancer_name  = optional(string)<br>      resource_group_name = optional(string)<br>      backend_pool_tag    = optional(string)<br>      loadbalancer_tag    = optional(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_loadbalancers"></a> [loadbalancers](#input\_loadbalancers) | n/a | <pre>map(object({<br>    id                   = optional(string)<br>    private_ip_address   = optional(string)<br>    private_ip_addresses = optional(list(string))<br>    backend_address_pool_address = optional(map(object({<br>      id = string<br>    })))<br>    backend_address_pool = optional(map(object({<br>      id = string<br>    })))<br>    nat_pool = optional(map(object({<br>      id = string<br>    })))<br>    nat_rule = optional(map(object({<br>      id = string<br>    })))<br>    probe = optional(map(object({<br>      id = string<br>    })))<br>    rule = optional(map(object({<br>      id = string<br>    })))<br>    frontend_ip_configuration = optional(map(object({<br>      id                   = string<br>      private_ip_address   = string<br>      public_ip_address_id = optional(string)<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location in which the resources will be created. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the VM NiC. | `string` | n/a | yes |
| <a name="input_network_security_group"></a> [network\_security\_group](#input\_network\_security\_group) | n/a | <pre>object({<br>    id                  = optional(string) # Name of the NSG. This will be used to lookup NSG resource in Azure for NIC association.<br>    name                = optional(string)<br>    resource_group_name = optional(string) # Resource group where NSG is located. If null, local.resource_group_name will be used.<br>    key                 = optional(string) # Tag to be used to lookup NSG from the output of module Azure-NetworkSecurityGroup<br>  })</pre> | `null` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | n/a | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_public_ip_addresses"></a> [public\_ip\_addresses](#input\_public\_ip\_addresses) | (Required) Public IP address output from Azure-PublicIPAddress module. IP address must be of type static and standard. | <pre>map(object({<br>    fqdn    = optional(string)<br>    id      = string<br>    address = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual\_network\_tag' and 'virtual\_network\_tag' | <pre>map(object({<br>    id   = string # Resource ID of the virtual Network<br>    name = string # Name of the Virtual Network<br>    subnet = map(object({<br>      id = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_security_group_association_id"></a> [application\_security\_group\_association\_id](#output\_application\_security\_group\_association\_id) | n/a |
| <a name="output_application_security_group_id"></a> [application\_security\_group\_id](#output\_application\_security\_group\_id) | TODO : Add data block based lookup |
| <a name="output_applied_dns_servers"></a> [applied\_dns\_servers](#output\_applied\_dns\_servers) | n/a |
| <a name="output_backend_address_pool_association_id"></a> [backend\_address\_pool\_association\_id](#output\_backend\_address\_pool\_association\_id) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_internal_domain_name_suffix"></a> [internal\_domain\_name\_suffix](#output\_internal\_domain\_name\_suffix) | n/a |
| <a name="output_mac_address"></a> [mac\_address](#output\_mac\_address) | n/a |
| <a name="output_network_security_group_association_id"></a> [network\_security\_group\_association\_id](#output\_network\_security\_group\_association\_id) | n/a |
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | TODO : Add data block based lookup |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | n/a |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | n/a |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | n/a |
<!-- END_TF_DOCS -->