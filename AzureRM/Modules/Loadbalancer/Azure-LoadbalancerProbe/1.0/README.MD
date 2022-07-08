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
| [azurerm_lb_probe.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_lb.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_interval_in_seconds"></a> [interval\_in\_seconds](#input\_interval\_in\_seconds) | (Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed. | `number` | `15` | no |
| <a name="input_loadbalancer"></a> [loadbalancer](#input\_loadbalancer) | (Required) The ID of the Load Balancer in which to create the Backend Address Pool. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_loadbalancers"></a> [loadbalancers](#input\_loadbalancers) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the probe. | `string` | n/a | yes |
| <a name="input_number_of_probes"></a> [number\_of\_probes](#input\_number\_of\_probes) | (Optional) The number of failed probe attempts after which the backend endpoint is removed from rotation. The default value is 2. NumberOfProbes multiplied by intervalInSeconds value must be greater or equal to 10.Endpoints are returned to rotation when at least one probe is successful. | `number` | `2` | no |
| <a name="input_port"></a> [port](#input\_port) | (Required) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive. | `number` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Optional) Specifies the protocol of the end point. Possible values are Http, Https or Tcp. If Tcp is specified, a received ACK is required for the probe to be successful. If Http is specified, a 200 OK response from the specified URI is required for the probe to be successful. | `string` | `null` | no |
| <a name="input_request_path"></a> [request\_path](#input\_request\_path) | (Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group where the load balancer is located. If Null, the property resource\_group\_name in object 'loadbalancer' must be specified | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->