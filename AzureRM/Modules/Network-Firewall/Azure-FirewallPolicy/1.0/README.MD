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
| [azurerm_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/firewall_policy) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_certificate.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_log_analytics_workspace.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_policy"></a> [base\_policy](#input\_base\_policy) | (Optional) The ID of the base Firewall Policy. | <pre>object({<br>    id                  = optional(string)<br>    name                = optional(string)<br>    resource_group_name = optional(string)<br>    key                 = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_dns"></a> [dns](#input\_dns) | n/a | <pre>object({<br>    # network_rule_fqdn_enabled = optional(bool)         # (Optional) Should the network rule fqdn be enabled?. Deprecated in provider version > 3.xx.x<br>    proxy_enabled = optional(bool)         #  (Optional) Whether to enable DNS proxy on Firewalls attached to this Firewall Policy? Defaults to false.<br>    servers       = optional(list(string)) #  (Optional) Whether to enable DNS proxy on Firewalls attached to this Firewall Policy? Defaults to false.<br>  })</pre> | `null` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Required) Specifies the type of Managed Service Identity that should be configured on this Firewall Policy. Only possible value is UserAssigned. | <pre>object({<br>    type = string<br>    identity = optional(list(object({<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'. | `bool` | `false` | no |
| <a name="input_insights"></a> [insights](#input\_insights) | n/a | <pre>object({<br>    enabled = bool                                        # (Required) Whether the insights functionality is enabled for this Firewall Policy.<br>    default_local_analytics_workspace = optional(object({ #  (Required) The ID of the default Log Analytics Workspace that the Firewalls associated with this Firewall Policy will send their logs to, when there is no location matches in the log_analytics_workspace.<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    }))<br>    retention_in_days = optional(number)             # (Optional) The number of days to retain the firewall logs.<br>    log_analytics_workspace = optional(list(object({ # (Optional) A list of log_analytics_workspace block as defined below.<br>      id                  = optional(string)<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      key                 = optional(string)<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_intrusion_detection"></a> [intrusion\_detection](#input\_intrusion\_detection) | n/a | <pre>object({<br>    mode = optional(string)<br>    signature_overrides = optional(list(object({<br>      id    = optional(string) # (Optional) 12-digit number (id) which identifies your signature.<br>      state = optional(string) # (Optional) state can be any of "Off", "Alert" or "Deny".<br>    })))<br>    traffic_bypass = optional(list(object({<br>      name                  = string                 # (Required) The name which should be used for this bypass traffic setting.<br>      protocol              = string                 # (Required) The protocols any of "ANY", "TCP", "ICMP", "UDP" that shall be bypassed by intrusion detection.<br>      description           = optional(string)       # (Optional) The description for this bypass traffic setting.<br>      destination_addresses = optional(list(string)) # (Optional) The list of destination addresses to be bypassed by intrustion detection.<br>      destination_ip_groups = optional(list(string)) # (Optional) The list of destination IP groups to be bypassed by intrustion detection.<br>      destination_ports     = optional(list(string)) # (Optional) The list of destination ports to be bypassed by intrustion detection.<br>      source_addresses      = optional(list(string)) # (Optional) Specifies a list of source addresses that shall be bypassed by intrusion detection.<br>      source_ip_groups      = optional(list(string)) # (Optional) Specifies a list of source IP groups that shall be bypassed by intrusion detection.<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_keyvault_certificates"></a> [keyvault\_certificates](#input\_keyvault\_certificates) | (Optional) The output of module Azure-KeyVaultCertificate, used for lookup of certificate ID for tls\_certificate property. | <pre>map(object({<br>    id         = optional(string)<br>    version    = optional(string)<br>    thumbprint = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_log_analytics_workspaces"></a> [log\_analytics\_workspaces](#input\_log\_analytics\_workspaces) | (Optional) The output of module Azure-LogAnalyticsWorkspace, used for lookup of Workspace ID for insights.default\_local\_analytics\_workspace property. | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Firewall policy. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_private_ip_ranges"></a> [private\_ip\_ranges](#input\_private\_ip\_ranges) | (Optional) A list of private IP ranges to which traffic will not be SNAT. | `list(string)` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The SKU Tier of the Firewall Policy. Possible values are Standard, Premium. Changing this forces a new Firewall Policy to be created. | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_threat_intelligence_allowlist"></a> [threat\_intelligence\_allowlist](#input\_threat\_intelligence\_allowlist) | n/a | <pre>object({<br>    fqdns        = optional(list(string)) # (Optional) A list of FQDNs that will be skipped for threat detection.<br>    ip_addresses = optional(list(string)) # (Optional) A list of IP addresses or CIDR ranges that will be skipped for threat detection.<br>  })</pre> | `null` | no |
| <a name="input_threat_intelligence_mode"></a> [threat\_intelligence\_mode](#input\_threat\_intelligence\_mode) | (Optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert. | `string` | `"Alert"` | no |
| <a name="input_tls_certificate"></a> [tls\_certificate](#input\_tls\_certificate) | n/a | <pre>object({<br>    name = string # (Required) The name of the certificate.<br>    key_vault_secret = object({<br>      id                  = optional(string) # (Required) The ID of the Key Vault Secret<br>      name                = optional(string) # (Required) The name of the Key Vault Secret <br>      key_vault_name      = optional(string) # (Required) The name of the Key Vault<br>      resource_group_name = optional(string) # (Required) The name of the resource group<br>    })<br>  })</pre> | `null` | no |
| <a name="input_user_assigned_identities"></a> [user\_assigned\_identities](#input\_user\_assigned\_identities) | Used by "identity" | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->