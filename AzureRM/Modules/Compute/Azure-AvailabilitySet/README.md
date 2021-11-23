# MODULE: Azure-AvailabilitySet

## Description

This module creates an availability set with the specified name, in the specified location (Azure region) and with the specified fault and update domains.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| resource_group_name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| name |string | - | Name of Availability set string  |
| platform_fault_domain_count | number | - | fault domain count in number |
| platform_update_domain_count | number | - | update domain count in number |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| availability_set_name | string | Name of the Availability Set |
| availability_set_id | string |  Full resource Id of the resulting Availability Set<br><br>NOTE: This exported attribute duplicates the *name* variable, and its purpose is to provide for building implicit depends_on when calling this module from another (e.g. root) one |

<br>
## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.



