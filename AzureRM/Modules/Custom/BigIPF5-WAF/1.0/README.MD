<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_BigF5-mgmt-Network-Interfaces"></a> [BigF5-mgmt-Network-Interfaces](#module\_BigF5-mgmt-Network-Interfaces) | ../../../Network/Azure-NetworkInterface/1.0 | n/a |
| <a name="module_BigF5-trusted-Network-Interfaces"></a> [BigF5-trusted-Network-Interfaces](#module\_BigF5-trusted-Network-Interfaces) | ../../../Network/Azure-NetworkInterface/1.1 | n/a |
| <a name="module_BigF5-untrusted-Network-Interfaces"></a> [BigF5-untrusted-Network-Interfaces](#module\_BigF5-untrusted-Network-Interfaces) | ../../../Network/Azure-NetworkInterface/1.1 | n/a |
| <a name="module_BigF5-waf-vms"></a> [BigF5-waf-vms](#module\_BigF5-waf-vms) | ../../../Compute/Azure-LinuxVirtualMachine/1.0 | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.waf-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [random_password.credential-value](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin-password"></a> [admin-password](#input\_admin-password) | n/a | `string` | `null` | no |
| <a name="input_admin-username"></a> [admin-username](#input\_admin-username) | n/a | `string` | n/a | yes |
| <a name="input_diagnostics-storage-account"></a> [diagnostics-storage-account](#input\_diagnostics-storage-account) | n/a | `string` | n/a | yes |
| <a name="input_inherit_tags"></a> [inherit\_tags](#input\_inherit\_tags) | n/a | `bool` | `true` | no |
| <a name="input_keyvault"></a> [keyvault](#input\_keyvault) | n/a | <pre>object({<br>    id  = optional(string)<br>    tag = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_keyvaults"></a> [keyvaults](#input\_keyvaults) | n/a | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_loadbalancers"></a> [loadbalancers](#input\_loadbalancers) | n/a | <pre>map(object({<br>    id = optional(string)<br>    backend_address_pool = optional(map(object({<br>      id = optional(string)<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `null` | no |
| <a name="input_mgmt-subnet-name"></a> [mgmt-subnet-name](#input\_mgmt-subnet-name) | n/a | `string` | n/a | yes |
| <a name="input_resource-group"></a> [resource-group](#input\_resource-group) | n/a | <pre>object({<br>    name = optional(string)<br>    key  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | n/a | <pre>map(object({<br>    location = optional(string)<br>    key      = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_trusted-subnet-name"></a> [trusted-subnet-name](#input\_trusted-subnet-name) | n/a | `string` | n/a | yes |
| <a name="input_untrusted-external-loadbalancer"></a> [untrusted-external-loadbalancer](#input\_untrusted-external-loadbalancer) | n/a | <pre>object({<br>    id  = optional(string)<br>    tag = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_untrusted-external-loadbalancer-backend-address-pool-name"></a> [untrusted-external-loadbalancer-backend-address-pool-name](#input\_untrusted-external-loadbalancer-backend-address-pool-name) | n/a | `string` | n/a | yes |
| <a name="input_untrusted-internal-loadbalancer"></a> [untrusted-internal-loadbalancer](#input\_untrusted-internal-loadbalancer) | n/a | <pre>object({<br>    id  = optional(string)<br>    tag = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_untrusted-internal-loadbalancer-backend-address-pool-name"></a> [untrusted-internal-loadbalancer-backend-address-pool-name](#input\_untrusted-internal-loadbalancer-backend-address-pool-name) | n/a | `string` | n/a | yes |
| <a name="input_untrusted-subnet-name"></a> [untrusted-subnet-name](#input\_untrusted-subnet-name) | n/a | `string` | n/a | yes |
| <a name="input_virtual-network"></a> [virtual-network](#input\_virtual-network) | n/a | <pre>object({<br>    id  = optional(string)<br>    tag = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | n/a | <pre>map(object({<br>    id = optional(string)<br>    subnet = map(object({<br>      id = optional(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_waf-vm"></a> [waf-vm](#input\_waf-vm) | n/a | <pre>list(object({<br>    name                            = string<br>    zone                            = number<br>    size                            = optional(string)<br>    timezone                        = optional(string)<br>    boot-siagnostics-storageaccount = optional(string)<br>    image-publisher                 = optional(string)<br>    image-offer                     = optional(string)<br>    image-sku                       = optional(string)<br>    image-version                   = optional(string)<br>    mgmt-private-ip-address         = string<br>    trusted-private-ip-address      = string<br>    untrusted-private-ip-address    = string<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->