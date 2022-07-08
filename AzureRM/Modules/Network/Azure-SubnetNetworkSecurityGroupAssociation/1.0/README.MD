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
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_security_group"></a> [network\_security\_group](#input\_network\_security\_group) | (Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | (Optional) Output of module Azure-NetworkSecurityGroups/1.0 | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | n/a | <pre>object({<br>    id                   = optional(string)<br>    name                 = optional(string)<br>    virtual_network_name = optional(string)<br>    resource_group_name  = optional(string)<br>    tag                  = optional(string)<br>    virtual_network_key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional)Output of module Azure-VirtualNetwork/2.0 | <pre>map(object({<br>    id = optional(string)<br>    subnet = map(object({<br>      id = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->