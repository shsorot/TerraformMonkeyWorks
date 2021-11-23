# MODULE: Azure-AutomationAccount

## Description

This module creates an Automation Account with the specified name, in the specified location (Azure region) and with the specified fault and update domains.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| resource_group_name | string | --- | Name of the resource group |
| location | string | --- | Location (Azure region) |
| name |string | --- | Name of Automation Account |
| tags | number | --- | fault domain count in number |
| sku_name | number | Basic | Currently limited to "Basic" |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| automation_account_name | string | Name of the Resource |
| automation_account_id | string |  Full resource Id of the resulting resource |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.



