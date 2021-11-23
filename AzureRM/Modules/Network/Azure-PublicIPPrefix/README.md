# MODULE: Azure-PublicIPPrefix

## Description

This module creates an Azure PublicIPAddress with the specified name, in the specified location (Azure region) .

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 1.x.x       | >= 0.13.x         | >= 2.0.0        |


<!-- ## Variables -->

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | ---                               |
| resource_group_name | string | --- | Name of the resource group where the subnet 'AzureFirewallSubnet' is located. |
| location | string | --- | Location (Azure region) |
| name | string | --- | (Required) Specifies the name of the Public IP Prefix resource . Changing this forces a new resource to be created. |
| sku | string | Standard | (Optional) The SKU of the Public IP Prefix. Accepted values are Standard. Defaults to Standard. Changing this forces a new resource to be created. | 
| prefix_length | number | 28 | (Optional) Specifies the number of bits of the prefix. The value can be set between 0 (4,294,967,296 addresses) and 31 (2 addresses). Defaults to 28(16 addresses). Changing this forces a new resource to be created. |
| zones | number | [] | (Optional) A collection containing the availability zone to allocate the Public IP in. |
| tags | number | {} | (Optional) A mapping of tags to assign to the resource. |


> There may be Public IP address limits on the subscription
> Public IP Prefix can only be created with Standard SKUs at this time.


## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| public_ip_prefix_id | string | The Public IP Prefix ID. |
| public_ip_prefix_cidr | string | The IP address prefix value that was allocated. |


 Set<br><br>NOTE: This exported attribute duplicates the *name* variable, and its purpose is to provide for building implicit depends_on when calling this module from another (e.g. root) one |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.

