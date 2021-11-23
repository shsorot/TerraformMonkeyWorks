# MODULE: Azure-KeyVault

## Description

This module creates a key vault with the specified properties as descibed below (the key vault will be assigned to the Azure AD tenant of the service principal or user creating or modifying it).

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| key_vault_name | string | - | Name of the key vault to create |
| resource_group_name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| tags | map (string) | - | Map (hashtable) of tags |
| sku_name | string | "standard" | SKU (pricing tier). Can be either "*standard*" or "*premium*" (the literals are case-sensitive). |
| enabled_for_deployment | bool | false | Specifies if virtual machines are allowed to retrieve contents of the key vault |
| enabled_for_template_deployment | bool | false | Specifies if Azure Resource Manager is allowed to retrieve contents of the key vault during ARM template deployments |
| enabled_for_disk_encryption | bool | false | Specifies if Azure Disk Encryption is allowed to use contents of the key vault during its operations |
| enable_rbac_authorization | bool | false | Specifies if RBAC or Access Polices mode is used to grant access to the key vault contents (*false* means Access Policies) |
| soft_delete_retention_days | number | 90 | Retention period (in days) for soft-deleted items |
| purge_protection_enabled | bool | false | Specifies if Purge Protection enabled for the key vault<br><br>NOTE: Enable with caution as this setting unconditionally prevents purging the key vault for 90 days (cannot be undone) |
| network_acls | object | *See `variables.tf` for the default value* | Firewall configuration for the key vault. See `variables.tf` for the definition of the object attributes. |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| key_vault_id | string | Full resource Id of the resulting key vault |
| key_vault_uri | string | URI of the key vault (i.e. an URL like https://*key_vault_name*.vault.azure.net/) |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
