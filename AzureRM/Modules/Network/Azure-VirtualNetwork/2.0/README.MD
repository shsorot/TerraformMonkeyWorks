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
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the virtual network. You can supply more than one address space. | `list(string)` | n/a | yes |
| <a name="input_bgp_community"></a> [bgp\_community](#input\_bgp\_community) | (Optional) The BGP community attribute in format <as-number>:<community-value>.<br>  The as-number segment is the Microsoft ASN, which is always 12076 for now. | `string` | `null` | no |
| <a name="input_ddos_protection_plan"></a> [ddos\_protection\_plan](#input\_ddos\_protection\_plan) | (Optional) The DDoS Protection Plan object. If provided, DDOS protection plan will be enabled. | <pre>object({<br>    id                  = optional(string) # Specify ID if you have one.<br>    name                = optional(string) # Name of the DDOS ID. To be used with Resource Group(Optional, local.resource_group_name is used if null) & subscription_id( current is used if not specified )<br>    resource_group_name = optional(string) # Resource Group to lookup the DDOS using name. If Null, the <br>    subscription_id     = optional(string) # If the resource is located in a different subscription, specify this along with name and resource group name.<br>    key                 = optional(string) # If using an output of module Azure-NetworkDDOSProtectionPlan, use this value to perform a lookup instead<br>  })</pre> | `null` | no |
| <a name="input_ddos_protection_plans"></a> [ddos\_protection\_plans](#input\_ddos\_protection\_plans) | (Optional) Output of module Azure-NetworkDDOSProtectionPlan. Used to lookup in case resource ID is not available. | <pre>map(object({<br>    id                  = string<br>    virtual_network_ids = optional(list(string))<br>  }))</pre> | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) List of IP addresses of DNS servers | `list(string)` | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | (Required) Boolean value to denote if if should inherit tags from parent resource group. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location/region where the virtual network is created. Changing this forces a new resource to be created. <br>  If Null, location from resource group is used. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the virtual network. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | (Optional) Output of module Azure-NetworkSecurityGroup. Used to lookup resource ID using tags. | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | (Optional) Output of module Azure-RouteTable. Used to lookup resource ID using tags. | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | (Optional) List of objects describing subnet details to be provisioned. | <pre>list(object({<br>    name                                           = string                 # (Required) The name of the subnet. Changing this forces a new resource to be created.<br>    address_prefixes                               = list(string)           # (Required) The address prefixes to use for the subnet in the format ["cidrblock"]<br>    enforce_private_link_endpoint_network_policies = optional(bool)         # Refer to link : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#enforce_private_link_endpoint_network_policies<br>    enforce_private_link_service_network_policies  = optional(bool)         # Refer to link : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#enforce_private_link_service_network_policies<br>    service_endpoints                              = optional(list(string)) # Refer to link : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#service_endpoints<br>    service_endpoint_policy_ids                    = optional(string)       # (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.<br>    delegation = optional(object({<br>      name = optional(string) # A name for this delegation.<br>      service_delegation = object({<br>        name    = string                 # A value from the list at :https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#name<br>        actions = optional(list(string)) # A list value from the list at :https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#actions<br>      })<br>    }))<br>    security_group = optional(object({       # (Optional)  Custom object describing NSG details to be attached to the subnet<br>      id                  = optional(string) # (Optional)  Resource ID of the NSG if available<br>      name                = optional(string) # (Optional)  Name of the NSG<br>      resource_group_name = optional(string) # (Optional)  Resource Group where NSG is placed. If Name is provided, will be used to lookup<br>      key                 = optional(string) # When using the ouput of module Azure-NetworkSecuritygroup, use this to perform a lookup.<br>    }))<br>    route_table = optional(object({          # (Optional)  Custom object describing route_table details to be attached to the subnet<br>      id                  = optional(string) # (Optional)  Resource ID of the route_table if available<br>      name                = optional(string) # (Optional)  Name of the Route table<br>      resource_group_name = optional(string) # (Optional)  Resource Group where Route table is placed. If Name is provided, will be used to lookup<br>      key                 = optional(string) # When using the ouput of module Azure-RouteTable, use this to perform a lookup.<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | n/a |
<!-- END_TF_DOCS -->