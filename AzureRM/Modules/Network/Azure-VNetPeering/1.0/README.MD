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
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_forwarded_traffic"></a> [allow\_forwarded\_traffic](#input\_allow\_forwarded\_traffic) | (Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. | `bool` | `false` | no |
| <a name="input_allow_gateway_transit"></a> [allow\_gateway\_transit](#input\_allow\_gateway\_transit) | (Optional) Controls gatewayLinks can be used in the REMOTE virtual network’s link to the local virtual network. <br>  This cannot be set to 'true' when 'use\_remote\_gateways' is set to 'true'. " | `bool` | `false` | no |
| <a name="input_allow_virtual_network_access"></a> [allow\_virtual\_network\_access](#input\_allow\_virtual\_network\_access) | (Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the virtual network peering. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_remote_virtual_network"></a> [remote\_virtual\_network](#input\_remote\_virtual\_network) | (Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    subscription_id     = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the virtual network peering. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_use_remote_gateways"></a> [use\_remote\_gateways](#input\_use\_remote\_gateways) | (Optional) Controls if remote gateways can be used on the LOCAL virtual network. If the flag is set to true, and allow\_gateway\_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false."<br>  This cannot be set to 'true' when 'allow\_gateway\_transit' is set to 'true'. " | `bool` | `false` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | (Required) The name of the virtual network. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional) Output of module Azure-VirtualNetwork | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Virtual Network Peering. |
<!-- END_TF_DOCS -->