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
| [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/disk_encryption_set) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_option"></a> [create\_option](#input\_create\_option) | (Required) The method to use when creating the managed disk. Changing this forces a new resource to be created. Possible values include:<br>        Import - Import a VHD file in to the managed disk (VHD specified with source\_uri).<br>        Empty - Create an empty managed disk.<br>        Copy - Copy an existing managed disk or snapshot (specified with source\_resource\_id).<br>        FromImage - Copy a Platform Image (specified with image\_reference\_id)<br>        Restore - Set by Azure Backup or Site Recovery on a restored disk (specified with source\_resource\_id). | `string` | `"Empty"` | no |
| <a name="input_disk_access_id"></a> [disk\_access\_id](#input\_disk\_access\_id) | The ID of the disk access resource for using private endpoints on disks. | `string` | `null` | no |
| <a name="input_disk_encryption_set"></a> [disk\_encryption\_set](#input\_disk\_encryption\_set) | (Optional) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_disk_encryption_sets"></a> [disk\_encryption\_sets](#input\_disk\_encryption\_sets) | (Optional) Output of module Azure-DiskEncryptionSet, used to perform lookup of ID using tag. | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_disk_iops_read_only"></a> [disk\_iops\_read\_only](#input\_disk\_iops\_read\_only) | (Optional) The number of IOPS allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. One operation can transfer between 4k and 256k bytes. | `number` | `null` | no |
| <a name="input_disk_iops_read_write"></a> [disk\_iops\_read\_write](#input\_disk\_iops\_read\_write) | (Optional) The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes. | `number` | `null` | no |
| <a name="input_disk_mbps_read_only"></a> [disk\_mbps\_read\_only](#input\_disk\_mbps\_read\_only) | (Optional) The bandwidth allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. MBps means millions of bytes per second. | `number` | `null` | no |
| <a name="input_disk_mbps_read_write"></a> [disk\_mbps\_read\_write](#input\_disk\_mbps\_read\_write) | (Optional) The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second. | `number` | `null` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | (Optional, Required for a new managed disk) Specifies the size of the managed disk to create in gigabytes. If create\_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased. | `number` | `32` | no |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone) | (Optional) Specifies the Edge Zone within the Azure Region where this Managed Disk should exist. Changing this forces a new Managed Disk to be created. | `string` | `null` | no |
| <a name="input_encryption_settings"></a> [encryption\_settings](#input\_encryption\_settings) | Added in provider > 3.xx.x | <pre>object({<br>    enabled = bool<br>    disk_encryption_key = object({<br>      secret_url      = string #   (Required) The URL to the Key Vault Secret used as the Disk Encryption Key. This can be found as id on the azurerm_key_vault_secret resource.<br>      source_vault_id = string #    (Required) The URL of the Key Vault. This can be found as vault_uri on the azurerm_key_vault resource.<br>    })<br>    key_encryption_key = object({<br>      secret_url      = string #   (Required) The URL to the Key Vault Secret used as the Disk Encryption Key. This can be found as id on the azurerm_key_vault_secret resource.<br>      source_vault_id = string #    (Required) The URL of the Key Vault. This can be found as vault_uri on the azurerm_key_vault resource.<br>    })<br>  })</pre> | `null` | no |
| <a name="input_gallery_image_reference_id"></a> [gallery\_image\_reference\_id](#input\_gallery\_image\_reference\_id) | (Optional) ID of a Gallery Image Version to copy when create\_option is FromImage. This field cannot be specified if image\_reference\_id is specified. | `string` | `null` | no |
| <a name="input_hyper_v_generation"></a> [hyper\_v\_generation](#input\_hyper\_v\_generation) | (Optional) The HyperV Generation of the Disk when the source of an Import or Copy operation targets a source that contains an operating system. Possible values are V1 and V2. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_image_reference_id"></a> [image\_reference\_id](#input\_image\_reference\_id) | (Optional) ID of an existing platform/marketplace disk image to copy when create\_option is FromImage | `string` | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specified the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_logical_sector_size"></a> [logical\_sector\_size](#input\_logical\_sector\_size) | (Optional) Logical Sector Size. Possible values are: 512 and 4096. Defaults to 4096. Changing this forces a new resource to be created. | `number` | `4096` | no |
| <a name="input_max_shares"></a> [max\_shares](#input\_max\_shares) | (Optional) The maximum number of VMs that can attach to the disk at the same time. Value greater than one indicates a disk that can be mounted on multiple VMs at the same time. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Managed Disk. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_access_policy"></a> [network\_access\_policy](#input\_network\_access\_policy) | Policy for accessing the disk via network. Allowed values are AllowAll, AllowPrivate, and DenyAll. | `string` | `"AllowAll"` | no |
| <a name="input_on_demand_bursting_enabled"></a> [on\_demand\_bursting\_enabled](#input\_on\_demand\_bursting\_enabled) | (Optional) Specifies if On-Demand Bursting is enabled for the Managed Disk. Defaults to false | `bool` | `false` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | (Optional) Specify a value when the source of an Import or Copy operation targets a source that contains an operating system. Valid values are Linux or Windows. | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether it is allowed to access the disk via public network. Defaults to true. | `bool` | `true` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_source_resource_id"></a> [source\_resource\_id](#input\_source\_resource\_id) | (Optional) The ID of an existing Managed Disk to copy create\_option is Copy or the recovery point to restore when create\_option is Restore | `string` | `null` | no |
| <a name="input_source_uri"></a> [source\_uri](#input\_source\_uri) | (Optional) URI to a valid VHD file to be used when create\_option is Import. | `string` | `null` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | (Optional) The ID of the Storage Account where the source\_uri is located. Required when create\_option is set to Import. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | (Required) The type of storage to use for the managed disk. Possible values are Standard\_LRS, Premium\_LRS, StandardSSD\_LRS or UltraSSD\_LRS. | `string` | `"Standard_LRS"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | The disk performance tier to use. Possible values are documented here(https://docs.microsoft.com/en-us/azure/virtual-machines/disks-change-performance). This feature is currently supported only for premium SSDs. | `string` | `null` | no |
| <a name="input_trusted_launch_enabled"></a> [trusted\_launch\_enabled](#input\_trusted\_launch\_enabled) | (Optional) Specifies if Trusted Launch is enabled for the Managed Disk. Defaults to false. | `bool` | `false` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) A number containing the availability zone to allocate the Managed Disk in. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->