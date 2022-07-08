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
| [azurerm_managed_disk_sas_token.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk_sas_token) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_level"></a> [access\_level](#input\_access\_level) | Required) The level of access required on the disk. Supported are Read, Write. | `string` | `"Read"` | no |
| <a name="input_duration_in_seconds"></a> [duration\_in\_seconds](#input\_duration\_in\_seconds) | (Required) The duration for which the export should be allowed. Should be between 30 & 4294967295 seconds. | `number` | n/a | yes |
| <a name="input_managed_disk"></a> [managed\_disk](#input\_managed\_disk) | (Required) The ID of an existing Managed Disk which should be attached. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)  # (Optional)Resource ID of the managed disk.<br>    name                = optional(string)  # (Optional)Name of the managed disk, used for ID lookp using data block<br>    resource_group_name = optional(string)  # (Optional)Resource Group name, must be specified when 'name' is used.<br>    key                 = optional(string)  # (Optional) Terraform object key used for lookup of ID from output of module Azure-ManagedDisk<br>  })</pre> | n/a | yes |
| <a name="input_managed_disks"></a> [managed\_disks](#input\_managed\_disks) | (Optional) Output of module Azure-ManagedDisk. | <pre>map(object({<br>    id = string # (Required) Resource ID of the managed disk.<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Disk Export resource. |
| <a name="output_sas_url"></a> [sas\_url](#output\_sas\_url) | The computed Shared Access Signature (SAS) of the Managed Disk. |
<!-- END_TF_DOCS -->