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
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_id"></a> [application\_id](#input\_application\_id) | (Optional) The object ID of an Application in Azure Active Directory. | `string` | n/a | yes |
| <a name="input_certificate_permissions"></a> [certificate\_permissions](#input\_certificate\_permissions) | (Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, <br>    Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update. | `list(string)` | `[]` | no |
| <a name="input_key_permissions"></a> [key\_permissions](#input\_key\_permissions) | (Optional) List of key permissions, must be one or more from the following: Backup, Create, <br>  Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey. | `list(string)` | `[]` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | (Optional) Tag of the key vault, used to lookup resource ID from output of module Azure-KeyVault | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_key_vaults"></a> [key\_vaults](#input\_key\_vaults) | (Optional) Output of module Azure-KeyVault, used to perform lookup of key vault ID using Tag | <pre>map(object({<br>    id  = string<br>    uri = string<br>  }))</pre> | `{}` | no |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | (Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_secret_permissions"></a> [secret\_permissions](#input\_secret\_permissions) | (Optional) List of secret permissions, must be one or more from the following: Backup, Delete, get, list, purge, recover, restore and set. | `list(string)` | `[]` | no |
| <a name="input_storage_permissions"></a> [storage\_permissions](#input\_storage\_permissions) | (Optional) List of storage permissions, must be one or more from the following: Backup, Delete, <br>   DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update. | `list(string)` | `[]` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->