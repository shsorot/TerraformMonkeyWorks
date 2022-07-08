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
| [azurerm_lb_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_lb.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_address_pool"></a> [backend\_address\_pool](#input\_backend\_address\_pool) | (Optional) A list of reference to a Backend Address Pool over which this Load Balancing Rule operates. | <pre>list(object({<br>    id   = optional(string)<br>    name = optional(string)<br>    key  = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_backend_port"></a> [backend\_port](#input\_backend\_port) | (Required) The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive. | `number` | n/a | yes |
| <a name="input_disable_outbound_snat"></a> [disable\_outbound\_snat](#input\_disable\_outbound\_snat) | (Optional) Is snat enabled for this Load Balancer Rule? Default false. | `bool` | `false` | no |
| <a name="input_enable_floating_ip"></a> [enable\_floating\_ip](#input\_enable\_floating\_ip) | (Optional) Are the Floating IPs enabled for this Load Balncer Rule? A floating IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_tcp_reset"></a> [enable\_tcp\_reset](#input\_enable\_tcp\_reset) | (Optional) Is TCP Reset enabled for this Load Balancer Rule? Defaults to false. | `bool` | `false` | no |
| <a name="input_frontend_ip_configuration_name"></a> [frontend\_ip\_configuration\_name](#input\_frontend\_ip\_configuration\_name) | (Required) The name of the frontend IP configuration to which the rule is associated. | `string` | n/a | yes |
| <a name="input_frontend_port"></a> [frontend\_port](#input\_frontend\_port) | (Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 0 and 65534, inclusive. | `number` | n/a | yes |
| <a name="input_idle_timeout_in_minutes"></a> [idle\_timeout\_in\_minutes](#input\_idle\_timeout\_in\_minutes) | (Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30 minutes. Defaults to 4 minutes. | `number` | `4` | no |
| <a name="input_load_distribution"></a> [load\_distribution](#input\_load\_distribution) | (Optional) Specifies the load balancing distribution type to be used by the Load Balancer.<br>                Possible values are: Default – The load balancer is configured to use a 5 tuple hash to map traffic to available servers.<br>                SourceIP – The load balancer is configured to use a 2 tuple hash to map traffic to available servers.<br>                SourceIPProtocol – The load balancer is configured to use a 3 tuple hash to map traffic to available servers. <br>                Also known as Session Persistence, where the options are called None, Client IP and Client IP and Protocol respectively. | `string` | `"Default"` | no |
| <a name="input_loadbalancer"></a> [loadbalancer](#input\_loadbalancer) | (Required) The ID of the Load Balancer in which to create the Rule. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_loadbalancers"></a> [loadbalancers](#input\_loadbalancers) | n/a | <pre>map(object({<br>    ifd = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the LB Rule. | `string` | n/a | yes |
| <a name="input_probe"></a> [probe](#input\_probe) | Optional) A reference to a Probe used by this Load Balancing Rule. | <pre>object({<br>    id   = optional(string)<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_probes"></a> [probes](#input\_probes) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->