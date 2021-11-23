# MODULE: Azure-VirtualNetwork

## Description

This module creates a Virtual Network (VNet) with the specified properties as descibed below.

## Variables

The following table describes module variables:
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| vnet_name | string | --- | Name of the VNet to create |
| resource_group_name | string | --- | Name of the resource group |
| location | string | --- | Location (Azure region) |
| tags | map (string) | --- | Map (hashtable) of tags |
| address_space | list (string) | --- | CIDR range(s) for the VNet<br><br>NOTE: Even if just one range is to be assigned it should still be specified as a list (e.g. *["192.168.0.0/24"]*) |
| dns_servers | list (string) | [] | IP addresses of DNS resolvers to assign at the VNet level. Empty array or *null* value means default (Azure-provided) DNS.<br><br>NOTE: Even if just one IP address is to be assigned it should still be specified as a list (e.g. *["192.168.0.1"]*) |
| default_nsg_id | string | --- | Resource Id of the NSG to assign to every subnet by default (unless custom NSG Id is specified for a particular subnet in its *custom_nsg_id* attribute) |
| default_nsg_tag | string | --- | Resource Tag of the NSG to assign to every subnet by default (unless custom NSG tag is specified for a particular subnet in its *custom_nsg_tag* attribute) |
| network_security_groups | map(objects) | --- | Output from module Azure-NetworkSecurityGroup , to be used for looking up NSG id using tags |
| default_udr_id | string | --- | Resource Id of the route table to assign to every subnet (unless UDR assignment is explicitly disabled for a particualr subnet by setting its *disable_default_udr* attribute to *true* --- as it may be required by the service deployed into the subnet, e.g. Azure Bastion) |
| default_udr_tag | string | --- | Resource tag of the route table to assign to every subnet (unless UDR assignment is explicitly disabled for a particualr subnet by setting its *disable_default_udr* attribute to *true* --- as it may be required by the service deployed into the subnet, e.g. Azure Bastion) |
| route_tables | map(object) | --- | Output from module Azure-RouteTable , to be used for looking up UDR id using tags |
| se_policy_storage_id | string | --- | Resource Id of the Service Endpoint Policy for Storage to assign to subnets that have *enable_se_policy_storage* attribute set to *true*, and *"Microsoft.Storage"* included into the *service_endpoints* attribute  |
| subnets | map (object) | --- | Subnets to create in the VNet. See `variables.tf` for the definition of the object attributes, map key is used as the subnet name. |
| ddos_protection_plan_enable | string | --- | (Required) Enable/disable DDoS Protection Plan on Virtual Network. | 
| ddos_protection_plan_tag | string | --- | (Optional) The TAG of DDoS Protection Plan created previously. Used to lookup the resource ID from output of module Azure-NetworkDDOSProtectionPlan. | 
| ddos_protection_plans | map(object) | --- | (Optional) Output of module Azure-NetworkDDOSProtectionPlan.Used to lookup in case resource ID is not available. | 
| enable_se_policy_storage | bool | false | Controls whether to assign the Service Endpoint Policy for Storage (provided via the se_policy_storage_id variable) to the subnet ("Microsoft.Storage" service endpoint must be included into the service_endpoints attribute for this feature to work) |


The following table describes variable object 'subnets'. The Key value of each block is the name of the subnet
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| name | string | --- | (Optional) Name of the subnet. If null/missing, Key is used instead, |
| address_prefixes | list(string) | --- | (Required) Address prefix to be provided as list format. |
| custom_nsg_type | string | --- | (Required) Specify "None" for no NSG, "Default" to use Vnet wide NSG or "Custom" to specify a custom NSG for this subnet. |
| custom_nsg_id | string | --- | (Optional) Resource ID of the NSG to be used in case of custom NSG. If empty, a tag must be specified in another variable. |
| custom_nsg_tag | string | --- | (Optional) Tag to be used to lookup NSG ID from output of module Azure-NetworkSecurityGroup. Needed when 'custom_nsg_id' is absent. |
| custom_udr_type | string | --- | (Required) Specify "None" for no udr, "Default" to use Vnet wide udr or "Custom" to specify a custom udr for this subnet. |
| custom_udr_id | string | --- | (Optional) Resource ID of the udr to be used in case of custom udr. If empty, a tag must be specified in another variable. |
| custom_udr_tag | string | --- | (Optional) Tag to be used to lookup udr ID from output of module Azure-RouteTables. Needed when 'custom_udr_id' is absent. |
| used_for_private_link_endpoints | bool | --- | Must be set to true if Private Link Endpoints is going be attached to the subnet | 
| service_endpoints | list(string) | [ ] |  List of Service Endpoints to assign to the subnet (a single entry should still be specified as a list, e.g. ["Microsoft.Storage"]) |
| service_delegation | string | --- | (Optional) Service name to delegate subnet for (e.g. "Microsoft.Web/serverFarms") | 


The following table describes variable object 'network_security_groups'. The Key value of each block is the name of the subnet
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| network_security_group_id | string | --- | (Required) Mandatory resource ID of the security group. |


The following table describes variable object 'route_tables'. The Key value of each block is the name of the subnet
| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| route_table_id | string | --- | (Required) Mandatory resource ID of the route table. |



## Output

The following table describes module output:
| Exported Attribute | Type | Description |
| --- | --- | --- |
| vnet_id | string | Full resource Id of the resulting VNet |
| vnet_name | string | Name of the VNet<br><br>NOTE: This exported attribute duplicates the *vnet_name* variable, and its purpose is to provide for building implicit depends_on when calling this module from another (e.g. root) one |
| map_subnet_ids | string | A map containing subnet names (as keys) and their respective resource Ids (as values) |

<br>

## Change log

### v1.0

**Date:** 12-04-2021

**Author(s):** Shekhar Sorot <shsorot@microsoft.com>

**Release notes:**
- The first production version.
