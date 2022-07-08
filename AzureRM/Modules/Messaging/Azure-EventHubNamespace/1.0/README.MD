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
| [azurerm_eventhub_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_inflate_enabled"></a> [auto\_inflate\_enabled](#input\_auto\_inflate\_enabled) | (Optional) Is Auto Inflate enabled for the EventHub Namespace? | `bool` | `null` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | (Optional) Specifies the Capacity / Throughput Units for a Standard SKU namespace. Default capacity has a maximum of 20, but can be increased in blocks of 20 on a committed purchase basis. | `number` | `null` | no |
| <a name="input_dedicated_cluster"></a> [dedicated\_cluster](#input\_dedicated\_cluster) | (Optional) Specifies the ID of the EventHub Dedicated Cluster where this Namespace should created. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_dedicated_clusters"></a> [dedicated\_clusters](#input\_dedicated\_clusters) | (Optional) Output of module Azure-EventHubCluster | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An identity block as defined. | <pre>object({<br>    type = string #   (Required) The Type of Identity which should be used for this EventHub Namespace. At this time the only possible value is SystemAssigned.<br>  })</pre> | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.If null, Resource group location is used. | `string` | `null` | no |
| <a name="input_maximum_throughput_units"></a> [maximum\_throughput\_units](#input\_maximum\_throughput\_units) | (Optional) Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the EventHub Namespace resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_rulesets"></a> [network\_rulesets](#input\_network\_rulesets) | n/a | <pre>object({<br>    default_action                 = string         #(Required) The default action to take when a rule is not matched. Possible values are Allow and Deny. Defaults to Deny.<br>    trusted_service_access_enabled = optional(bool) #(Optional) Whether Trusted Microsoft Services are allowed to bypass firewall.<br>    virtual_network_rule = optional(list(object({<br>      subnet = object({<br>        id                   = optional(string)<br>        name                 = optional(string)<br>        virtual_network_name = optional(string)<br>        resource_group_name  = optional(string)<br>        tag                  = optional(string)<br>        virtual_network_key  = optional(string)<br>      })<br>    })))<br>    ip_rule = optional(list(object({<br>      ip_mask = string<br>      action  = optional(string)<br>    })))<br>  })</pre> | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) Defines which tier to use. Valid options are Basic, Standard, and Premium. Please not that setting this field to Premium will force the creation of a new resource and also requires setting zone\_redundant to true. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual\_network\_tag' and 'virtual\_network\_tag' | <pre>map(object({<br>    id   = string # Resource ID of the virtual Network<br>    name = string # Name of the Virtual Network<br>    subnet = map(object({<br>      id = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | (Optional) Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). Changing this forces a new resource to be created. Defaults to false. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
<!-- END_TF_DOCS -->