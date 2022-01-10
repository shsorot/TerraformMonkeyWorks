# MODULE: Azure-RecoveryServicesVault-BackupPolicy-VM

## Description

This module creates a backup policy for the Azure Virtual Machine resource type (in the specified Recovery Services vault).

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| name | string | - | Name of the backup policy to create |
| resource_group_name | string | - | Name of the resource group where the target Recovery Services vault resides |
| recovery_services_vault_name | string | - | Name of the target Recovery Services vault |
| backup_policy_settings | object | - | Backup policy settings. See `variables.tf` for the definition of the object attributes. |

## Output

This module does not export any attributes.

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
