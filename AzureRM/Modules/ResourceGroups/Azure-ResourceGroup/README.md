# MODULE: Azure-ResourceGroup

## Description

This module creates a resouce group with the specified name, in the specified location (Azure region) and with the specified tags assigned.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| tags | map (string) | - | Map (hashtable) of tags |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| resource_group_id | string | Full resource Id of the resulting resource group |
| rg_name | string | Name of the resource group<br><br>NOTE: This exported attribute duplicates the *name* variable, and its purpose is to provide for building implicit depends_on when calling this module from another (e.g. root) one |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
