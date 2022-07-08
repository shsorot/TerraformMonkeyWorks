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
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy"></a> [access\_policy](#input\_access\_policy) | A list of up to 16 objects describing access policies, as described below.<br>  NOTE<br>  Since access\_policy can be configured both inline and via the <br>  separate azurerm\_key\_vault\_access\_policy resource, <br>  we have to explicitly set it to empty slice ([]) to remove it.<br><br>  NOTE: This block does not configures anything if enable\_rbac\_authorization is set to true. | <pre>list(object({<br>    tenant_id               = string                 #   (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Must match the tenant_id used above.<br>    object_id               = string                 #   (Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies.<br>    application_id          = optional(string)       #   (Optional) The object ID of an Application in Azure Active Directory.<br>    certificate_permissions = optional(list(string)) #   (Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update.<br>    key_permissions         = optional(list(string)) #   (Optional) List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey.<br>    secret_permissions      = optional(list(string)) #   (Optional) List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set.<br>    storage_permissions     = optional(list(string)) #   (Optional) List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update.<br>  }))</pre> | `null` | no |
| <a name="input_contact"></a> [contact](#input\_contact) | n/a | <pre>list(object({<br>    email = string<br>    name  = optional(string)<br>    phone = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | (Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | (Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false | `bool` | `null` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | (Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false. | `bool` | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Key vault. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | n/a | <pre>object({<br>    default_action = optional(string)       # Can be "Allow" or "Deny"<br>    bypass         = optional(string)       # Can be "AzureServices" or "None"<br>    ip_rules       = optional(list(string)) # IP ranges. Notes: if only one value is specified it should be embraced in the square brackets; single IPs should be set as ranges with the /32 mask.<br>    virtual_network_subnet = optional(list(object({<br>      id                   = optional(string)<br>      name                 = optional(string)<br>      virtual_network_name = optional(string)<br>      resource_group_name  = optional(string)<br>      tag                  = optional(string)<br>      virtual_network_key  = optional(string)<br>    }))) # Full subnet resource Ids. Note: if only one value is specified it should be embraced in the square brackets.<br><br>  })</pre> | `{}` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | (Optional) Is Purge Protection enabled for this Key Vault? Defaults to false.<br>  Once Purge Protection has been Enabled it's not possible to Disable it. <br>  Support for disabling purge protection is being tracked in this Azure API issue. <br>  Deleting the Key Vault with Purge Protection Enabled will schedule the Key Vault to be deleted (which will happen by Azure in the configured number of days, <br>  currently 90 days - which will be configurable in Terraform in the future). | `bool` | `false` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | value | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | (Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. | `number` | `90` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. IF null, current context tenant ID is used. | `string` | `null` | no |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | (Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual\_network\_tag' and 'virtual\_tag' for ID lookup. | <pre>map(object({<br>    id   = string # Resource ID of the virtual Network<br>    name = string # Name of the Virtual Network<br>    subnet = map(object({<br>      id = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_uri"></a> [uri](#output\_uri) | n/a |
<!-- END_TF_DOCS -->