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
| [azurerm_express_route_port.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_port) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bandwidth_in_gbps"></a> [bandwidth\_in\_gbps](#input\_bandwidth\_in\_gbps) | (Required) Bandwidth of the Express Route Port in Gbps. Changing this forces a new Express Route Port to be created. | `number` | n/a | yes |
| <a name="input_encapsulation"></a> [encapsulation](#input\_encapsulation) | (Required) The encapsulation method used for the Express Route Port. Changing this forces a new Express Route Port to be created. Possible values are: Dot1Q, QinQ. | `string` | n/a | yes |
| <a name="input_identity"></a> [identity](#input\_identity) | n/a | <pre>object({<br>    type         = string           # (Optional) The identity type. Possible values are 'SystemAssigned' and 'UserAssigned'.<br>    identity_ids = optional(string) # (Optional) Specifies a list with a single user managed identity id to be assigned to the Express Route Port. Currently, exactly one id is allowed to specify.<br>  })</pre> | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_link1"></a> [link1](#input\_link1) | Link Object definition | <pre>list(object({<br>    admin_enabled                 = optional(string) # (Optional) Whether enable administration state on the Express Route Port Link? Defaults to false<br>    macsec_cipher                 = optional(string) # (Optional) The MACSec cipher used for this Express Route Port Link. Possible values are GcmAes128 and GcmAes256. Defaults to GcmAes128.<br>    macsec_ckn_keyvault_secret_id = optional(string) #   (Optional) The ID of the Key Vault Secret that contains the MACSec CKN key for this Express Route Port Link.<br>    macsec_cak_keyvault_secret_id = optional(string) #   (Optional) The ID of the Key Vault Secret that contains the Mac security CAK key for this Express Route Port Link.<br>  }))</pre> | `null` | no |
| <a name="input_link2"></a> [link2](#input\_link2) | Link Object definition | <pre>list(object({<br>    admin_enabled                 = optional(string) # (Optional) Whether enable administration state on the Express Route Port Link? Defaults to false<br>    macsec_cipher                 = optional(string) # (Optional) The MACSec cipher used for this Express Route Port Link. Possible values are GcmAes128 and GcmAes256. Defaults to GcmAes128.<br>    macsec_ckn_keyvault_secret_id = optional(string) #   (Optional) The ID of the Key Vault Secret that contains the MACSec CKN key for this Express Route Port Link.<br>    macsec_cak_keyvault_secret_id = optional(string) #   (Optional) The ID of the Key Vault Secret that contains the Mac security CAK key for this Express Route Port Link.<br>  }))</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Express Route Port. Changing this forces a new Express Route Port to be created. | `string` | n/a | yes |
| <a name="input_peering_location"></a> [peering\_location](#input\_peering\_location) | (Required) The name of the peering location that this Express Route Port is physically mapped to. Changing this forces a new Express Route Port to be created. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ethertype"></a> [ethertype](#output\_ethertype) | n/a |
| <a name="output_guid"></a> [guid](#output\_guid) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
| <a name="output_mtu"></a> [mtu](#output\_mtu) | n/a |
<!-- END_TF_DOCS -->