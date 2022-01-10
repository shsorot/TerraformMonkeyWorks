# MODULE: Azure-VNetPeering

## Description

This module creates a Vnet Peering between two virtual networks, Preferebly between two seperate subscriptions.

It is recommended to explicitly specify the Vnet resource ID's to avoid any kind of mistakes due to resource lookup using module outputs or complex objects.

The following table describes module variables:
| Variable | Type | Default | Description |
| name | string | - | (Required) The name of the virtual network peering. Changing this forces a new resource to be created. |
| local_resource_group_name | string | - | (Required) The name of the resource group in which to create the virtual network peering. Changing this forces a new resource to be created. | 
| local_vnet_name | string | - | (Required) The name of the virtual network. Changing this forces a new resource to be created. | 
| remote_virtual_network_id | string | - |  (Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created. | 
| remote_subscription_id | string - | (Optional) Remote subscription ID where the remote Vnet is hosted. This is only required if 'remote_virtual_network_id' is not specified. |
| remote_resource_group_name | string | - | (Optional) Remote resource group where the remote Vnet is hosted. This is only required if 'remote_virtual_network_id' is not specified. | 
| remote_virtual_network_name | string | - | (Optional) The remote virtual network name. This is required if 'remote_virtual_network_id is not specified. | 
| allow_forwarded_traffic | bool | false | (Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. | 
| allow_gateway_transit | bool | false | (Optional) Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. | 
| use_remote_gateways | bool | false | (Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false. | 


## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| virtual_network_peering_id | string | The ID of the Virtual Network Peering. |




<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
