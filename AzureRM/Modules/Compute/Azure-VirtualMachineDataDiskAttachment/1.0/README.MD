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
| [azurerm_virtual_machine_data_disk_attachment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_caching"></a> [caching](#input\_caching) | (Required) Specifies the caching requirements for this Data Disk. Possible values include None, ReadOnly and ReadWrite. | `string` | `"None"` | no |
| <a name="input_create_option"></a> [create\_option](#input\_create\_option) | (Optional) The Create Option of the Data Disk, such as Empty or Attach. Defaults to Attach. Changing this forces a new resource to be created. | `string` | `"Attach"` | no |
| <a name="input_lun"></a> [lun](#input\_lun) | (Required) The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine. Changing this forces a new resource to be created. | `number` | n/a | yes |
| <a name="input_managed_disk"></a> [managed\_disk](#input\_managed\_disk) | (Required) The ID of an existing Managed Disk which should be attached. Changing this forces a new resource to be created. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_managed_disks"></a> [managed\_disks](#input\_managed\_disks) | (Optional) Output of module Azure-ManagedDisk. | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_virtual_machine"></a> [virtual\_machine](#input\_virtual\_machine) | (Required) The ID of the Virtual machine to which the managed disk will be assigned. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_machines"></a> [virtual\_machines](#input\_virtual\_machines) | (Optional) Output of module Azure-VirtualMachine or Azure-WindowsVirtualMachine or Azure-LinuxVirtualMachine | <pre>map(object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_write_accelerator_enabled"></a> [write\_accelerator\_enabled](#input\_write\_accelerator\_enabled) | (Optional) Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium\_LRS managed disks with no caching and M-Series VMs. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_machine_data_disk_attachment_id"></a> [virtual\_machine\_data\_disk\_attachment\_id](#output\_virtual\_machine\_data\_disk\_attachment\_id) | n/a |
<!-- END_TF_DOCS -->