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
| [azurerm_image.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/image) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_managed_disk.datadisks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |
| [azurerm_managed_disk.osdisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_blob.datadisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_blob) | data source |
| [azurerm_storage_blob.osdisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_blob) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_disk"></a> [data\_disk](#input\_data\_disk) | n/a | <pre>list(object({<br>    lun = number # (Required) Specifies the logical unit number of the data disk. If null, array index is used.<br>    managed_disk = optional(object({<br>      id                  = optional(string) # (Optional) Specifies the ID of the managed disk resource that you want to use to create the image.<br>      name                = optional(string) # (Optional) Specifies the name of the managed disk resource that you want to use to create the image.<br>      resource_group_name = optional(string) # (Optional) Specifies the name of the resource group where the managed disk is located.<br>    }))                                      # (Optional) Specifies the managed disk ID to use for the virtual machine.<br>    blob_uri = optional(string)              # (Optional) Specifies the URI in Azure storage of the blob that you want to use to create the image.<br>    caching  = optional(string)              # (Optional) Specifies the caching mode as ReadWrite, ReadOnly, or None. The default is None.<br>    size_gb  = optional(number)              # (Optional) Specifies the size of the image to be created. The target size can't be smaller than the source size.<br>  }))</pre> | `null` | no |
| <a name="input_hyper_v_generation"></a> [hyper\_v\_generation](#input\_hyper\_v\_generation) | (Optional) The HyperVGenerationType of the VirtualMachine created from the image as V1, V2. The default is V1. | `string` | `"V1"` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specified the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the image. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_os_disk"></a> [os\_disk](#input\_os\_disk) | Note: Documentation states multiple blocks, Azure only accepts single os\_disk block | <pre>object({<br>    os_type  = string # (Optional) Specifies the operating system type of the virtual machine. Possible values include: 'Windows', 'Linux'<br>    os_state = string # (Optional) Specifies the state of the virtual machine. Possible values include: 'Generalized', 'Specialized'<br>    managed_disk = optional(object({<br>      id                  = optional(string) # (Optional) Specifies the ID of the managed disk resource that you want to use to create the image.<br>      name                = optional(string) # (Optional) Specifies the name of the managed disk resource that you want to use to create the image.<br>      resource_group_name = optional(string) # (Optional) Specifies the name of the resource group where the managed disk is located.<br>    }))                                      # (Optional) Specifies the managed disk ID to use for the virtual machine.<br>    blob     = optional(object({             # (Optional) Specifies the blob URI of the VHD to use for the virtual machine.<br>        uri   = optional(string)<br>        name  = optional(string)<br>        storage_account_name  = optional(string)<br>        storage_container_name= optional(string)<br>    }))<br>    caching  = optional(string)              # (Optional) Specifies the caching requirements. Possible values include: 'None', 'ReadOnly', 'ReadWrite'<br>    size_gb  = optional(number)              # (Optional) Specifies the size of the VHD to use for the virtual machine.<br>  })</pre> | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_source_virtual_machine"></a> [source\_virtual\_machine](#input\_source\_virtual\_machine) | n/a | <pre>object({<br>    id                  = optional(string) # (Optional) The Virtual Machine ID from which to create the image.<br>    name                = optional(string) # If ID is unknown, use name to retrieve resource ID via 'data' block<br>    resource_group_name = optional(string) # Resource group name to use along with 'name'. If Null, core resource group name is used instead.<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_zone_resilient"></a> [zone\_resilient](#input\_zone\_resilient) | (Optional) Is zone resiliency enabled? Defaults to false. Changing this forces a new resource to be created. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->