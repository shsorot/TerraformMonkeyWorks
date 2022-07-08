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
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | (Optional) Specifies whether the admin user is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_anonymous_pull_enabled"></a> [anonymous\_pull\_enabled](#input\_anonymous\_pull\_enabled) | (Optional) Whether allows anonymous (unauthenticated) pull access to this Container Registry? Defaults to false. This is only supported on resources with the Standard or Premium SKU. | `bool` | `false` | no |
| <a name="input_data_endpoint_enabled"></a> [data\_endpoint\_enabled](#input\_data\_endpoint\_enabled) | (Optional) Whether to enable dedicated data endpoints for this Container Registry? Defaults to false. This is only supported on resources with the Premium SKU. | `bool` | `false` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | n/a | <pre>object({<br>    enabled            = optional(bool) # (Optional) Boolean value that indicates whether encryption is enabled.<br>    key_vault_key_id   = string         # (Required) The ID of the Key Vault Key.<br>    identity_client_id = string         # (Required) The client ID of the managed identity associated with the encryption key.<br>  })</pre> | `null` | no |
| <a name="input_export_policy_enabled"></a> [export\_policy\_enabled](#input\_export\_policy\_enabled) | (Optional) Boolean value that indicates whether export policy is enabled. Defaults to true. In order to set it to false, make sure the public\_network\_access\_enabled is also set to false. | `bool` | `false` | no |
| <a name="input_georeplications"></a> [georeplications](#input\_georeplications) | n/a | <pre>object({<br>    location                  = string                #  (Required) A location where the container registry should be geo-replicated.<br>    regional_endpoint_enabled = optional(bool)        # (Optional) Specifies whether the container registry should be configured for regional endpoint.<br>    zone_redundancy_enabled   = optional(bool)        # (Optional) Specifies whether the container registry should be configured for zone redundancy.<br>    tags                      = optional(map(string)) # (Optional) Tags to be applied to this replication service.<br>  })</pre> | `null` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | n/a | <pre>object({<br>    type        = string                 # (Required) Specifies the type of Managed Service Identity that should be configured on this Container Registry. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).<br>    identity_id = optional(list(string)) # (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Registry.<br>    # identity = optional(list(object({<br>    #   id = optional(string) # (Optional) Specifies the ID of the User Assigned Managed Identity to be assigned to this Container Registry.<br>    #   name = optional(string) # (Optional) Specifies the name of the User Assigned Managed Identity to be assigned to this Container Registry.<br>    #   resource_group_name = optional(string) # (Optional) Specifies the name of the Resource Group of the User Assigned Managed Identity. If null, resource group of container registry is used.<br>    #   tag = optional(string) # (Optional) Use the output of module Azure-UserAssignedIdentity to lookup the identity tag.<br>    # })))<br>  })</pre> | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Container Group. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_rule_bypass_option"></a> [network\_rule\_bypass\_option](#input\_network\_rule\_bypass\_option) | (Optional) Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices. Defaults to AzureServices. | `bool` | `false` | no |
| <a name="input_network_rule_set"></a> [network\_rule\_set](#input\_network\_rule\_set) | n/a | <pre>object({<br>    default_action = optional(string) # (Optional) The default action to apply to requests that are not explicitly allowed or denied. Defaults to Allow.<br>    ip_rule = optional(object({<br>      action   = string # (Required) The behaviour for requests matching this rule. At this time the only supported value is Allow<br>      ip_range = string #  (Required) The CIDR block from which requests will match the rule.<br>    }))<br>    virtual_network = optional(object({<br>      action    = string # (Required) The behaviour for requests matching this rule. At this time the only supported value is Allow<br>      subnet_id = string # (Required) The ID of the subnet from which requests will match the rule.<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether public network access is allowed for the container registry. Defaults to true | `bool` | `true` | no |
| <a name="input_quarantine_policy_enabled"></a> [quarantine\_policy\_enabled](#input\_quarantine\_policy\_enabled) | (Optional) Boolean value that indicates whether quarantine policy is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | n/a | <pre>object({<br>    days    = optional(number) # (Optional) The number of days to retain an untagged manifect after which it gets purged. Defaults to 7<br>    enabked = optional(bool)   # (Optional) Boolean value that indicates whether the retention policy is enabled. Defaults to false.<br>  })</pre> | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium. | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_trust_policy"></a> [trust\_policy](#input\_trust\_policy) | n/a | <pre>object({<br>    enabled = optional(bool) # (Optional) Boolean value that indicates whether the trust policy is enabled. Defaults to false.<br>  })</pre> | `null` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | (Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_enabled"></a> [admin\_enabled](#output\_admin\_enabled) | n/a |
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | This should only be enabled post thorough audit of your pipeline and pipe outputs. |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->