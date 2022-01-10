# MODULE: Azure-PublicIPAddress

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
| name | string | --- | Name of the firewall |
| sku | string | Basic | (Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic | 
| allocation_method | string | --- | (Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic |
| ip_version | string | --- | (Optional) The IP Version to use, IPv6 or IPv4. |
| idle_timeout_in_minutes | number | 5 | (Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes |
| domain_name_label | string | --- | (Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |
| generate_domain_name_label | bool | false | (Optional) Switch/bool to generate domain name if required. Defaults to false |
| reverse_fqdn | map(object) | --- | (Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN. |
| public_ip_prefix_id | string | --- | (Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. |
| public_ip_prefix_tag | string | --- | (Optional) If specified then public IP address allocated will be looked up from the output of module Azure-PublicIPPrefix.. |
| public_ip_prefixes | map(object) | --- | (Optional Output of module Azure-PublicIPPRefix, used for lookup of variables when resource ID is unknown. See below for details. |
| zones | number | [] | (Optional) A collection containing the availability zone to allocate the Public IP in. |
| tags | number | {} | (Optional) A mapping of tags to assign to the resource. |

| 'public_ip_prefixes' object attributes | Type | Description |
| --- | --- | --- |
| public_ip_prefix_id | string | --- | Resource ID of the prefix |
| public_ip_prefix_cidr | string | --- | CIDR notation of the public IP block. |

> Public IP Standard SKUs require allocation_method to be set to Static.
> Only dynamic IP address allocation is supported for IPv6.


## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| firewall_id | string | Resource ID of the firewall |
| firewall_name | string | Logical name of the Azure firewall |
| firewall_resource_group_name | string | Resource group where the firewall / firewall subnet is hosted. |
| firewall_ip_configuration | map(object) | exported IP configuratation block of the Azure firewall. |


 Set<br><br>NOTE: This exported attribute duplicates the *name* variable, and its purpose is to provide for building implicit depends_on when calling this module from another (e.g. root) one |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.



