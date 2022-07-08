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
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_key) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_key_rotation_enabled"></a> [auto\_key\_rotation\_enabled](#input\_auto\_key\_rotation\_enabled) | (Optional) Boolean flag to specify whether Azure Disk Encryption Set automatically rotates encryption Key to latest version. Defaults to false. | `bool` | `false` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | (Optional) The type of key used to encrypt the data of the disk. Possible values are EncryptionAtRestWithCustomerKey, EncryptionAtRestWithPlatformAndCustomerKeys and ConfidentialVmEncryptedWithCustomerKey. Defaults to EncryptionAtRestWithCustomerKey. | `string` | `"EncryptionAtRestWithCustomerKey"` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | n/a | <pre>object({<br>    type = string # (Required) The Type of Identity which should be used for this Disk Encryption Set. At this time the only possible value is SystemAssigned.<br>  })</pre> | <pre>{<br>  "type": "SystemAssigned"<br>}</pre> | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_key_vault_key"></a> [key\_vault\_key](#input\_key\_vault\_key) | (Required) Specifies the URL to a Key Vault Key (either from a Key Vault Key, or the Key URL for the Key Vault Secret).<br>    id                  = # (Optional) ID of the Key vault key to be used for disk encryption.<br>    name                = # (Optional) Name of the Key vault key to be used for Id lookup using data block<br>    key\_vault\_name      = # (Optional) Name of the keyvault, must be used when 'name' is used.<br>    resource\_group\_name = # (Optional) Resource group of the keyvault, if null when 'name' is used, then the resource group of the disk encryption set is used.<br>    key                 = # (Optional) Key to be used for Id lookup using output of module Azure-KeyVaultKey | <pre>object({<br>    id                  = optional(string)  # (Optional) ID of the Key vault key to be used for disk encryption.<br>    name                = optional(string)  # (Optional) Name of the Key vault key to be used for Id lookup using data block<br>    key_vault_name      = optional(string)  # (Optional) Name of the keyvault, must be used when 'name' is used.<br>    resource_group_name = optional(string)  # (Optional) Resource group of the keyvault, if null when 'name' is used, then the resource group of the disk encryption set is used.<br>    key                 = optional(string)  # (Optional) Key to be used for Id lookup using output of module Azure-KeyVaultKey<br>  })</pre> | n/a | yes |
| <a name="input_key_vault_keys"></a> [key\_vault\_keys](#input\_key\_vault\_keys) | (Optional) Output of module Azure-KeyVaultKey. Used to lookup Key Vault Key properties using Terraform Object Keys | <pre>map(object({<br>    id =  string # (Required) Resource ID of the keyvault key.<br>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the Azure Region where the Disk Encryption Set exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Disk Encryption Set. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->