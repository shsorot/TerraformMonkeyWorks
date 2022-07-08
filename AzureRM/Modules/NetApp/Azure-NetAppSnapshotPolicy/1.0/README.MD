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
| [azurerm_netapp_snapshot_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_snapshot_policy) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_netapp_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/netapp_account) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | (Required) The name of the NetApp Account. Specify either the actual name or the Tag value that can be used to look up NetApp Account properties from output of module Azure-NetAppAccount. | <pre>object({<br>    name = optional(string) # Name of the NetApp Account <br>    key  = optional(string) # alternatively, the tag specifying the NetApp Account from the output of module Azure-NetAppAccount<br>  })</pre> | n/a | yes |
| <a name="input_daily_schedule"></a> [daily\_schedule](#input\_daily\_schedule) | (Optional) Defines the daily schedule for the NetApp Snapshot Policy. | <pre>object({<br>    snapshots_to_keep = optional(number) # (Required) How many daily snapshots to keep, valid range is from 0 to 255.<br>    hour              = optional(number) # (Required) The hour at which the daily snapshot is taken. Valid range is from 0 to 23.<br>    minute            = optional(number) # (Required) The minute at which the daily snapshot is taken. Valid range is from 0 to 59.<br>  })</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Required) Defines that the NetApp Snapshot Policy is enabled or not. | `bool` | `false` | no |
| <a name="input_hourly_schedule"></a> [hourly\_schedule](#input\_hourly\_schedule) | (Optional) Defines the hourly schedule for the NetApp Snapshot Policy. | <pre>object({<br>    snapshots_to_keep = optional(number) # (Required) How many hourly snapshots to keep, valid range is from 0 to 255.<br>    minute            = optional(number) # (Required) The minute at which the hourly snapshot is taken. Valid range is from 0 to 59.<br>  })</pre> | `{}` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the Log Analytics Cluster should exist. Changing this forces a new Log Analytics Cluster to be created. | `string` | `null` | no |
| <a name="input_monthly_schedule"></a> [monthly\_schedule](#input\_monthly\_schedule) | (Optional) Defines the weekly schedule for the NetApp Snapshot policy. | <pre>object({<br>    snapshots_to_keep = optional(number)       # (Required) How many weekly snapshots to keep, valid range is from 0 to 255.<br>    days_of_month     = optional(list(number)) # (Required) The day/s of the month at which the monthly snapshot is taken. Valid values are dates in numerical value.<br>    hour              = optional(number)       # (Required) The hour at which the monthly snapshot is taken. Valid range is from 0 to 23.<br>    minute            = optional(number)       # (Required) The minute at which the monthly snapshot is taken. Valid range is from 0 to 59.<br>  })</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the NetApp Snapshot Policy. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_netapp_accounts"></a> [netapp\_accounts](#input\_netapp\_accounts) | (Optional) Output of Module Azure-NetAppAccount. Used to lookup NetApp Account properties using Tags | <pre>map(object({<br>    id   = string # Resource ID of the NetApp account<br>    name = string # Name of the NetApp Account <br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_weekly_schedule"></a> [weekly\_schedule](#input\_weekly\_schedule) | (Optional) Defines the weekly schedule for the NetApp Snapshot policy. | <pre>object({<br>    snapshots_to_keep = optional(number)       # (Required) How many weekly snapshots to keep, valid range is from 0 to 255.<br>    days_of_week      = optional(list(string)) # (Required) The day of the week at which the weekly snapshot is taken. Valid values are Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday.<br>    hour              = optional(number)       # (Required) The hour at which the weekly snapshot is taken. Valid range is from 0 to 23.<br>    minute            = optional(number)       # (Required) The minute at which the weekly snapshot is taken. Valid range is from 0 to 59.<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_name"></a> [account\_name](#output\_account\_name) | n/a |
| <a name="output_daily_schedule"></a> [daily\_schedule](#output\_daily\_schedule) | n/a |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | n/a |
| <a name="output_hourly_schedule"></a> [hourly\_schedule](#output\_hourly\_schedule) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_monthly_schedule"></a> [monthly\_schedule](#output\_monthly\_schedule) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_weekly_schedule"></a> [weekly\_schedule](#output\_weekly\_schedule) | n/a |
<!-- END_TF_DOCS -->