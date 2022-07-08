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
| [azurerm_netapp_volume.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_volume) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_netapp_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/netapp_account) | data source |
| [azurerm_netapp_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/netapp_pool) | data source |
| [azurerm_netapp_snapshot.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/netapp_snapshot) | data source |
| [azurerm_netapp_snapshot_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/netapp_snapshot_policy) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | (Required) The name of the NetApp Account. Specify either the actual name or the Tag value that can be used to look up NetApp Account properties from output of module Azure-NetAppAccount. | <pre>object({<br>    name = optional(string) # Name of the NetApp Account <br>    key  = optional(string) # alternatively, the tag specifying the NetApp Account from the output of module Azure-NetAppAccount<br>  })</pre> | n/a | yes |
| <a name="input_create_from_snapshot_resource"></a> [create\_from\_snapshot\_resource](#input\_create\_from\_snapshot\_resource) | (Optional) Creates volume from snapshot. Following properties must be the same as the original volume where the snapshot was taken from: protocols, subnet\_id, location, service\_level, resource\_group\_name, account\_name and pool\_name. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    account_name        = optional(string)<br>    pool_name           = optional(string)<br>    volume_name         = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_data_protection_replication"></a> [data\_protection\_replication](#input\_data\_protection\_replication) | n/a | <pre>object({<br>    endpoint_type             = optional(string) # (Optional) The endpoint type, default value is dst for destination.<br>    remote_volume_location    = optional(string) #  (Required) Location of the primary volume.<br>    remote_volume_resource_id = optional(string) #  (Required) Resource ID of the remote protection volume.<br>    replication_frequency     = optional(string) #  (Required) Replication frequency, supported values are '10minutes', 'hourly', 'daily', values are case sensitive.<br>  })</pre> | `null` | no |
| <a name="input_data_protection_snapshot_policy"></a> [data\_protection\_snapshot\_policy](#input\_data\_protection\_snapshot\_policy) | TODO : add remote subscription lookup capability | <pre>object({<br>    id   = optional(string) # Resource ID of the Snapshot policy<br>    name = optional(string) # Name of the Snapshot policy existing within the NetApp Account<br>    key  = optional(string) # Name of the Snapshot policy Tag available in the output of Azure-NetAppSnapshotPolicy<br>  })</pre> | `null` | no |
| <a name="input_export_policy_rule"></a> [export\_policy\_rule](#input\_export\_policy\_rule) | (Required) Export policy block for the given volume. | <pre>list(object({<br>    rule_index          = number                 # (Required) The index number of the rule.<br>    allowed_clients     = list(string)           # (Required) The list of clients allowed to access the volume.<br>    protocols_enabled   = optional(list(string)) # (Required) A list of allowed protocols. Valid values include CIFS, NFSv3, or NFSv4.1. Only one value is supported at this time. This replaces the previous arguments: cifs_enabled, nfsv3_enabled and nfsv4_enabled.<br>    unix_read_only      = optional(bool)         #  (Optional) Is the file system on unix read only?<br>    unix_read_write     = optional(bool)         #  (Optional) Is the file system on unix read write?<br>    root_access_enabled = optional(bool)         # (Optional) Is root access permitted to this volume?<br>  }))</pre> | n/a | yes |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the Log Analytics Cluster should exist. Changing this forces a new Log Analytics Cluster to be created. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the NetApp Pool. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_netapp_accounts"></a> [netapp\_accounts](#input\_netapp\_accounts) | (Optional) Output of Module Azure-NetAppAccount. Used to lookup NetApp Account properties using Tags | <pre>map(object({<br>    id   = string # Resource ID of the NetApp account<br>    name = string # Name of the NetApp Account <br>  }))</pre> | `{}` | no |
| <a name="input_netapp_pools"></a> [netapp\_pools](#input\_netapp\_pools) | (Optional) Output of Module Azure-NetAppPool. Used to lookup NetApp Pool properties using Tags | <pre>map(object({<br>    id            = string # Resource ID of the NetApp Pool<br>    name          = string # Name of the NetApp Pool <br>    service_level = string # Service level of the NetApp Pool<br>  }))</pre> | `{}` | no |
| <a name="input_netapp_snapshots"></a> [netapp\_snapshots](#input\_netapp\_snapshots) | (Optional) Output of module Azure-NetAppSnapshot. Used to lookup NetApp Snapshot properties using Tags | <pre>map(object({<br>    id = string<br>  }))</pre> | `{}` | no |
| <a name="input_pool"></a> [pool](#input\_pool) | (Required) The name of the NetApp Pool. Specify either the actual name or the Tag value that can be used to look up NetApp Account properties from output of module Azure-NetAppPool. | <pre>object({<br>    name = optional(string) # Name of the NetApp Capacity pool located in the NetApp Account specified in variable "account"<br>    key  = optional(string) # alternatively, the tag specifying the NetApp Pool from the output of module Azure-NetAppPool<br>  })</pre> | n/a | yes |
| <a name="input_protocols"></a> [protocols](#input\_protocols) | (Optional) The target volume protocol expressed as a list. Supported single value include CIFS, NFSv3, or NFSv4.1. If argument is not defined it will default to NFSv3. Changing this forces a new resource to be created and data will be lost. Dual protocol scenario is supported for CIFS and NFSv3, for more information, please refer to Create a dual-protocol volume for Azure NetApp Files document. | `list(string)` | <pre>[<br>  "NFSv4.1"<br>]</pre> | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_security_style"></a> [security\_style](#input\_security\_style) | (Optional) Volume security style, accepted values are Unix or Ntfs. If not provided, single-protocol volume is created defaulting to Unix if it is NFSv3 or NFSv4.1 volume, if CIFS, it will default to Ntfs. In a dual-protocol volume, if not provided, its value will be Ntfs. | `string` | `null` | no |
| <a name="input_snapshot_directory_visible"></a> [snapshot\_directory\_visible](#input\_snapshot\_directory\_visible) | (Optional) Specifies whether the .snapshot (NFS clients) or ~snapshot (SMB clients) path of a volume is visible, default value is true. | `bool` | `true` | no |
| <a name="input_snapshot_policies"></a> [snapshot\_policies](#input\_snapshot\_policies) | (Optional) Output of Module Azure-NetAppSnapshotPolicy. Used to lookup Snapshot policy properties using Tags | <pre>map(object({<br>    id = string # Resource ID of the Snapshot policy<br>  }))</pre> | `null` | no |
| <a name="input_storage_quota_in_gb"></a> [storage\_quota\_in\_gb](#input\_storage\_quota\_in\_gb) | (Required) The maximum Storage Quota allowed for a file system in Gigabytes. | `number` | n/a | yes |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | (Required) Reference to a subnet in which this volume will be placed. | <pre>object({<br>    id                   = optional(string)<br>    name                 = optional(string)<br>    virtual_network_name = optional(string)<br>    resource_group_name  = optional(string)<br>    tag                  = optional(string)<br>    virtual_network_key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_throughput_in_mibps"></a> [throughput\_in\_mibps](#input\_throughput\_in\_mibps) | (Optional) Throughput of this volume in Mibps.This is required if the pool QOS is set to Manual | `number` | `null` | no |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual\_network\_tag' and 'virtual\_network\_tag' | <pre>map(object({<br>    id   = string # Resource ID of the virtual Network<br>    name = string # Name of the Virtual Network<br>    subnet = map(object({<br>      id = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_volume_path"></a> [volume\_path](#input\_volume\_path) | (Required) A unique file path for the volume. Used when creating mount targets. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_name"></a> [account\_name](#output\_account\_name) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_mount_ip_addresses"></a> [mount\_ip\_addresses](#output\_mount\_ip\_addresses) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_pool_name"></a> [pool\_name](#output\_pool\_name) | n/a |
| <a name="output_service_level"></a> [service\_level](#output\_service\_level) | n/a |
<!-- END_TF_DOCS -->