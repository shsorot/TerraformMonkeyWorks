# MODULE: Azure-RecoveryServicesVault

## Description

This module creates a Recovery Services vault with the specified properties as descibed below.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| recovery_services_vault_name | string | - | Name of the Recovery Services vault to create |
| resource_group_name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| tags | map (string) | - | Map (hashtable) of tags |
| soft_delete_enabled | bool | true | Controls whether soft delete should be enabled for the vault |
| sku | string | Standard | (Required) Sets the vault's SKU. Possible values include: Standard, RS0. | 
| identity_type | string | SystemAssigned | (Required) The Type of Identity which should be used for this Recovery Services Vault. At this time the only possible value is SystemAssigned. |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| recovery_services_vault_id | string | Full resource Id of the resulting Recovery Services vault |

<br>
## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
