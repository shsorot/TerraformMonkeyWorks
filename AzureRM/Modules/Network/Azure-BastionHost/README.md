# MODULE: Azure-AvailabilitySet

## Description

This module creates an Azure bastion host with the specified name, in the specified location (Azure region) and with the specified fault and update domains.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| resource_group_name | string | - | Name of the resource group |
| location | string | - | Location (Azure region) |
| name |string | - | Name of the bastion host  |
| subnet_id | string | --- | (Required) Subnet ID to be used (once) for hosting Bastion service. | 
| virtual_network_tag | string | --- | (Optional) To be used when subnet_id is not provided. This is used to lookup the subnet_id from the output of Module Azure-VirtualNetwork |
| virtual_network_subnet_tag | string | --- | (Optional) To be used when subnet_id is not provided. This is used to lookup the subnet_id from the output of Module Azure-VirtualNetwork |
| virtual_network | map(object) | --- | (Optional) Output of the module Azure-VirtualNetwork |
| public_ip_address_name | string | - | (Required) Resource ID of the public ip address object. If not specified, var.public_ip_address_tag and var.public_ip_addresses must be used. |
| public_ip_address_name | string | - | (Optional) Name of the key signifying output from module Azure-PublicIPAddress . To be used when var.public_ip_address_id is null |
| public_ip_addresses | map(object) | --- | (Required) Output of Azure-PublicIPAddress |

## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| bastion_host_id | string | Resource ID of the resource created |
| bastion_host_fqdn | string | FQDN of the resource as per the public IP object assigned |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.



