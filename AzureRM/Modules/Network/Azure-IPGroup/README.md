# MODULE: Azure-IPGroup

## Description

This module creates an IP Group to be used by Azure Firewall. This module is a supporting module for Azure Firewall rule collections.

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 1.x.x       | >= 0.13.x         | >= 2.0.0        |


## Variables

The following table describes module variables:
| Variable  | Type | Default | Description |
| --- | --- | --- | --- |
| resource_group_name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| availability_set_name |string | - | Name of Availability set string  |
| platform_fault_domain_count | number | - | fault domain count in number |
| platform_update_domain_count | number | - | update domain count in number |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| ip_group_id | string | Resource ID of IP Group. |

<br>

## Change log

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
