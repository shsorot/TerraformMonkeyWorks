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
| [azurerm_dedicated_host.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dedicated_host) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_dedicated_host_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dedicated_host_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_replace_on_failure"></a> [auto\_replace\_on\_failure](#input\_auto\_replace\_on\_failure) | (Optional) Should the Dedicated Host automatically be replaced in <br>    case of a Hardware Failure? Defaults to true. | `bool` | `false` | no |
| <a name="input_dedicated_host_group"></a> [dedicated\_host\_group](#input\_dedicated\_host\_group) | (Required) Specifies the ID of the Dedicated Host Group where the Dedicated Host should exist. Changing this forces a new resource to be created.<br>    id                  = # (Optional) Resource ID of the dedicated host group where this dedicated host will be created.<br>    name                = # (Optional) Name of the dedicated host group to be used for id lookup using data block<br>    resource\_group\_name = # (Optional) Resource group name where the dedicated host group exists. Must be used when 'name' is being used.<br>    key                 = # (Optional) Use the Terraform object key to lookup the id from output of module Azure-DedicatedHostGroup | <pre>object({<br>    id                  = optional(string) # (Optional) Resource ID of the dedicated host group where this dedicated host will be created.<br>    name                = optional(string) # (Optional) Name of the dedicated host group to be used for id lookup using data block<br>    resource_group_name = optional(string) # (Optional) Resource group name where the dedicated host group exists. Must be used when 'name' is being used.<br>    key                 = optional(string) # (Optional) Use the Terraform object key to lookup the id from output of module Azure-DedicatedHostGroup<br>  })</pre> | `null` | no |
| <a name="input_dedicated_host_groups"></a> [dedicated\_host\_groups](#input\_dedicated\_host\_groups) | (Optional) Output of module Azure-DedicatedHostGroup.<br>    id                          = # (Mandatory) Resource ID of the dedicated host group.<br>    platform\_fault\_domain\_count = # (Optional) Sub property of dedicatedd host group | <pre>map(object({<br>    id                          = string           # (Mandatory) Resource ID of the dedicated host group.<br>    platform_fault_domain_count = optional(number) # (Optional) Sub property of dedicatedd host group<br>  }))</pre> | `{}` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | (Optional) Specifies the software license type that will be applied to the <br>    VMs deployed on the Dedicated Host. Possible values are None, <br>    Windows\_Server\_Hybrid and Windows\_Server\_Perpetual. Defaults to None. | `string` | `"None"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure location where the Dedicated Host exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Dedicated Host. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_platform_fault_domain"></a> [platform\_fault\_domain](#input\_platform\_fault\_domain) | (Required) The number of fault domains that the Dedicated Host spans. Changing this forces a new resource to be created. <br>    If null, and 'dedicated\_host\_group' is specified, the platform\_fault\_domain\_count will be retrieved from the dedicated host group. | `number` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) Specify the sku name of the Dedicated Host. <br>    Possible values are DSv3-Type1, DSv3-Type2, DSv4-Type1, <br>    ESv3-Type1, ESv3-Type2,FSv2-Type2, DASv4-Type1, DCSv2-Type1, <br>    DDSv4-Type1, DSv3-Type1, DSv3-Type2, DSv3-Type3, DSv4-Type1, <br>    EASv4-Type1, EDSv4-Type1, ESv3-Type1, ESv3-Type2, ESv3-Type3, <br>    ESv4-Type1, FSv2-Type2, FSv2-Type3, LSv2-Type1, MS-Type1, <br>    MSm-Type1, MSmv2-Type1, MSv2-Type1, NVASv4-Type1, <br>    and NVSv3-Type1. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Dedicated Host. |
| <a name="output_location"></a> [location](#output\_location) | Location of the Dedicated Host. |
| <a name="output_name"></a> [name](#output\_name) | Name of the Dedicated Host. |
<!-- END_TF_DOCS -->