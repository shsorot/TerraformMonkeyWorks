# MODULE: Azure-NetworkDDOSProtectionPlan

## Description

This module creates a AzureNetwork DDoS Protection Plan. with the specified properties as descibed below.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| name | string | - | (Required) Specifies the name of the Network DDoS Protection Plan. Changing this forces a new resource to be created. |
| resource_group_name | string | - |  (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. |
| location | string | - |  (Required) The name of the resource group in which to create the resource. Changing this forces a new resource to be created. |
| tags | map (string) | - |  (Optional) A mapping of tags to assign to the resource. |


## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| network_ddos_protection_plan_id | string | The ID of the DDoS Protection Plan |
| network_ddos_protection_plan_virtual_network_id | list(atring) | A list of Virtual Network ID's associated with the DDoS Protection Plan. |


<br>
## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
