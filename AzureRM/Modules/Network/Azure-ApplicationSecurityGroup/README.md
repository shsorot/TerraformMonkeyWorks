# MODULE: Azure-ApplicationSecurityGroup

## Description

This module creates an Application security group with the specified name, in the specified location (Azure region) and resource group.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| name | string | --- |  (Required) Specifies the name of the Application Security Group. Changing this forces a new resource to be created. |
| resource_grouo_name | string | --- |  (Required) The name of the resource group in which to create the Application Security Group. |
| location |string | --- | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created |
| tags | map(string) | {} | (Optional) A mapping of tags to assign to the resource. |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| application_security_group_id | string |  Full resource Id of the resulting resource |

<br>

## Change log

### v1.0

**Date:** 02-04-2021

**Author(s):** Shekhar Sorot(shsorot@microsoft.com_)

**Release notes:**
- Initial release