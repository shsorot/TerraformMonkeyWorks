# MODULE: Azure-RouteTable

## Description

This module creates a route table (sometimes also referred to as UDR) with the specified properties as descibed below.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| route_table_name | string | - | Name of the route table to create |
| resource_group_name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| tags | map (string) | - | Map (hashtable) of tags |
| disable_bgp_route_propagation | bool | - | Controls where the route table should disable propagation of routes received from the gateway |
| routes | map (object) | - | Routes configuration for the route table. See `variables.tf` for the definition of the object attributes, map key is used as the route name.  |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| route_table_id | string | Full resource Id of the resulting route table |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
