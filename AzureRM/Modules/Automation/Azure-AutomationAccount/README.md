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
| [azurerm_automation_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_identity"></a> [identity](#input\_identity) | id                  = #(Optional) The ID of the User Assigned Identity which should be assigned to this Automation Account.<br>      name                = #(Optional) The name of the User Assigned Identity which should be assigned to this Automation Account. Used to lookup ID using data blocks<br>      resource\_group\_name = #(Optional) Resource group name to be used with the property 'name'. If null, core resource group will be used.<br>      key                 = #(Optional) Terraform object key used to lookup ID using output of module Azure-UserAssignedIdentity supplied to variable 'user\_assigned\_identities' | <pre>object({<br>    type = string # (Required) The type of identity used for this Automation Account. Possible values are SystemAssigned, UserAssigned and SystemAssigned, UserAssigned.<br>    identity = optional(list(object({<br>      id                  = optional(string)  #(Optional) The ID of the User Assigned Identity which should be assigned to this Automation Account.<br>      name                = optional(string)  #(Optional) The name of the User Assigned Identity which should be assigned to this Automation Account. Used to lookup ID using data blocks<br>      resource_group_name = optional(string)  #(Optional) Resource group name to be used with the property 'name'. If null, core resource group will be used.<br>      key                 = optional(string)  #(Optional) Terraform object key used to lookup ID using output of module Azure-UserAssignedIdentity supplied to variable 'user_assigned_identities'<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | n/a | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the automation Account.) | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    key      = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU name of the account - only Basic is supported at this time. | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identities"></a> [user\_assigned\_identities](#input\_user\_assigned\_identities) | (Optional)Output of module Azure-UserAssignedIdentity. Used to lookup ID using Terraform Object Keys | <pre>map(object({<br>    id = optional(string) #(Optional) The property id from output of module Azure-UserAssignedIdentity<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dsc_primary_access_key"></a> [dsc\_primary\_access\_key](#output\_dsc\_primary\_access\_key) | The Primary Access Key for the DSC Endpoint associated with this Automation Account. |
| <a name="output_dsc_secondary_access_key"></a> [dsc\_secondary\_access\_key](#output\_dsc\_secondary\_access\_key) | The Secondary Access Key for the DSC Endpoint associated with this Automation Account. |
| <a name="output_dsc_server_endpoint"></a> [dsc\_server\_endpoint](#output\_dsc\_server\_endpoint) | The DSC Server Endpoint associated with this Automation Account. |
| <a name="output_id"></a> [id](#output\_id) | The Automation Account ID. |
| <a name="output_location"></a> [location](#output\_location) | Location of the resource. |
| <a name="output_name"></a> [name](#output\_name) | The Automation Account name. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource Group of the resource. |
<!-- END_TF_DOCS -->