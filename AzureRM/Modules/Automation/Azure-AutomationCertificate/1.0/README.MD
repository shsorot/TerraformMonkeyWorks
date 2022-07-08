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
| [azurerm_automation_certificate.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_certificate) | resource |
| [azurerm_automation_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/automation_account) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_account"></a> [automation\_account](#input\_automation\_account) | (Required) The name of the automation account in which the Certificate is created. Changing this forces a new resource to be created.<br>    id                  = # (Optional)Resource ID of existing automation account. <br>    name                = # (Optional)Name of the automation account to be used for fetching resource ID using data blocks, when property'id' is not available.<br>    resource\_group\_name = # (Optional)Resource group name to be used by data block to lookup automation account when 'name' is used.  Mandatory when using 'name'<br>    key                 = # (Optional)Terraform Object Key to lookup automation account details from output of module Azure-AutomationAccount | <pre>object({<br>    id                  = optional(string) # (Optional)Resource ID of existing automation account. <br>    name                = optional(string) # (Optional)Name of the automation account to be used for fetching resource ID using data blocks, when property'id' is not available.<br>    resource_group_name = optional(string) # (Optional)Resource group name to be used by data block to lookup automation account when 'name' is used.  Mandatory when using 'name'<br>    key                 = optional(string) # (Optional)Terraform Object Key to lookup automation account details from output of module Azure-AutomationAccount<br>  })</pre> | n/a | yes |
| <a name="input_automation_accounts"></a> [automation\_accounts](#input\_automation\_accounts) | (Optional)Output of module Azure-AutomationAccount. Used to lookup automation account details using Terraform Object Keys | <pre>map(object({<br>    id       = string # (Optional)Resource ID of existing automation account from output of module Azure-AutomationAccount<br>    name     = string # (Optional)Name of the automation account existing automation account from output of module Azure-AutomationAccount<br>    location = string # (Optional)Location of existing automation account from output of module Azure-AutomationAccount<br>  }))</pre> | `{}` | no |
| <a name="input_base64"></a> [base64](#input\_base64) | (Required) Base64 encoded value of the certificate. Changing this forces a new resource to be created.<br>    raw  = # Base64 encoded certificate content<br>    file = # relative file path to the Terraform root code calling this module. File must be a PFX format certificate. | <pre>object({<br>    raw  = optional(string) # Base64 encoded certificate content<br>    file = optional(string) # relative file path to the Terraform root code calling this module. File must be a PFX format certificate.<br>  })</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of this Automation Certificate. | `string` | `null` | no |
| <a name="input_exportable"></a> [exportable](#input\_exportable) | (Optional) The is exportable flag of the certificate.Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the Automation account certificate | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The Automation Certificate ID. |
| <a name="output_thumbprint"></a> [thumbprint](#output\_thumbprint) | The thumbprint for the certificate. |
<!-- END_TF_DOCS -->