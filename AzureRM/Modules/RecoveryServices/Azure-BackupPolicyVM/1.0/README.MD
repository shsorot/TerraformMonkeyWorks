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
| [azurerm_backup_policy_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_recovery_services_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/recovery_services_vault) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup"></a> [backup](#input\_backup) | (Required) Configures the Policy backup frequency, times & days as documented | <pre>object({<br>    frequency = string                 # either "Daily" or "Weekly"<br>    time      = string                 # 24h format (e.g. "01:00")<br>    weekdays  = optional(list(string)) # must be set to null for Daily frequency; ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"] for Weekly frequency<br>  })</pre> | n/a | yes |
| <a name="input_instant_restore_retention_days"></a> [instant\_restore\_retention\_days](#input\_instant\_restore\_retention\_days) | (Optional) Specifies the instant restore retention range in days. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Backup Policy. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_recovery_vault"></a> [recovery\_vault](#input\_recovery\_vault) | (Required) Specifies the name of the Recovery Services Vault to use. Changing this forces a new resource to be created. | <pre>object({<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_recovery_vaults"></a> [recovery\_vaults](#input\_recovery\_vaults) | n/a | <pre>map(object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_retention_daily"></a> [retention\_daily](#input\_retention\_daily) | n/a | <pre>object({<br>    count = number # (Required) The number of daily backups to keep. Must be between 7 and 9999.<br>  })</pre> | `null` | no |
| <a name="input_retention_monthly"></a> [retention\_monthly](#input\_retention\_monthly) | n/a | <pre>object({           # must be set to null if not relevant<br>    count    = number       # (Required) The number of monthly backups to keep. Must be between 1 and 9999<br>    weekdays = list(string) # ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]<br>    weeks    = list(string) # ["First", "Second", "Third", "Fourth", "Last"]<br>  })</pre> | n/a | yes |
| <a name="input_retention_weekly"></a> [retention\_weekly](#input\_retention\_weekly) | n/a | <pre>object({ # must be set to null if not relevant<br>    count    = number<br>    weekdays = list(string) # ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]<br>  })</pre> | `null` | no |
| <a name="input_retention_yearly"></a> [retention\_yearly](#input\_retention\_yearly) | n/a | <pre>object({<br>    count    = number       # Required) The number of yearly backups to keep. Must be between 1 and 9999<br>    weekdays = list(string) # ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]<br>    weeks    = list(string) # ["First", "Second", "Third", "Fourth", "Last"]<br>    months   = list(string) # [January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]<br>  })</pre> | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | (Optional) Configures the policy daily retention as documented in the retention\_daily block below. Required when backup frequency is Daily. | `string` | `"UTC"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_recovery_vault_name"></a> [recovery\_vault\_name](#output\_recovery\_vault\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->