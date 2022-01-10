# MODULE: Azure-NetworkSecurityGroup

## Description

This module creates a Network Security Group (NSG) resource with the specified properties as descibed below.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| nsg_name | string | - | Name of the NSG to create |
| resource_group_name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| tags | map (string) | - | Map (hashtable) of tags |
| custom_rules | map (object) | - | Rules configuration for the NSG. See `variables.tf` for the definition of the object attributes, map key is used as the rule name. |
| application_security_groups | map(object) | {} | (Optional) Output of the Module Azure-ApplicationSecurityGroup for lookup in case ASG Id's are not available |

The following table describes the custom_rules variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |



## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| network_security_group_id | string | Full resource Id of the resulting NSG |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
