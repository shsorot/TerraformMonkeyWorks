

# Template: Core Infrastructure
# Version:  1.0
# Date:     25.03.2021

# Create Network components


variable "ApplicationSecurityGroups" {
  default = {}
}

module "Landscape-Application-Security-Groups" {
  source          = "../../../AzureRM/Modules/Network/Azure-ApplicationSecurityGroup/1.0"
  for_each        = var.ApplicationSecurityGroups
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}

output "ApplicationSecurityGroups" {
  value = module.Landscape-Application-Security-Groups
}


variable "NetworkSecurityGroups" {
  default = {}
}


module "Landscape-Network-Security-Groups" {
  source                      = "../../../AzureRM/Modules/Network/Azure-NetworkSecurityGroup/1.0"
  for_each                    = var.NetworkSecurityGroups
  name                        = each.value.name == null ? each.key : each.value.name
  resource_group              = each.value.resource_group
  location                    = try(each.value.location, null)
  tags                        = try(each.value.tags, local.tags)
  inherit_tags                = try(each.value.inherit_tags, false)
  nsg_rule                    = try(each.value.nsg_rule, [])
  application_security_groups = module.Landscape-Application-Security-Groups
  resource_groups             = module.Landscape-Resource-Groups
}

output "NetworkSecurityGroups" {
  value = module.Landscape-Network-Security-Groups
}


variable "SubnetNetworkSecurityGroupAssociations" {
  default = {}
}

module "Landscape-Subnet-Network-Security-Group-Associations" {
  source                  = "../../../AzureRM/Modules/Network/Azure-SubnetNetworkSecurityGroupAssociation/1.0"
  for_each                = var.SubnetNetworkSecurityGroupAssociations
  network_security_group  = each.value.network_security_group
  subnet                  = each.value.subnet
  network_security_groups = module.Landscape-Network-Security-Groups
  virtual_networks        = module.Landscape-Virtual-Networks
}

output "SubnetNetworkSecurityGroupAssociations" {
  value = module.Landscape-Subnet-Network-Security-Group-Associations
}

variable "DDOSProtectionPlans" {
  default = {}
}

module "Landscape-DDOS-Protection-Plans" {
  source          = "../../../AzureRM/Modules/Network/Azure-NetworkDDOSProtectionPlan/1.0"
  for_each        = var.DDOSProtectionPlans
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}


output "DDOSProtectionPlans" {
  value = module.Landscape-DDOS-Protection-Plans
}


variable "VirtualNetworks" {
  default = {}
}

module "Landscape-Virtual-Networks" {
  source         = "../../../AzureRM/Modules/Network/Azure-VirtualNetwork/2.0"
  for_each       = var.VirtualNetworks
  name           = each.value.name == null ? each.key : each.value.name
  resource_group = each.value.resource_group
  location       = try(each.value.location,null)
  address_space  = each.value.address_space
  dns_servers    = try(each.value.dns_servers, [])

  subnet                  = each.value.subnet
  network_security_groups = module.Landscape-Network-Security-Groups
  route_tables            = module.Landscape-Route-Tables


  ddos_protection_plan  = try(each.value.ddos_protection_plan, null)
  ddos_protection_plans = module.Landscape-DDOS-Protection-Plans

  bgp_community = try(each.value.bgp_community, null)

  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}

output "VirtualNetworks" {
  value = module.Landscape-Virtual-Networks
}


variable "VirtualSubnets" {
  default = {}
}

module "Landscape-Virtual-Subnets" {
  source                                         = "../../../AzureRM/Modules/Network/Azure-VirtualSubnet/1.0"
  for_each                                       = var.VirtualSubnets
  resource_group                                 = each.value.resource_group
  virtual_network_name                           = each.value.virtual_network_name
  name                                           = each.value.name == null ? each.key : each.value.name
  address_prefixes                               = each.value.address_prefixes
  service_endpoints                              = try(each.value.service_endpoints, [])
  service_endpoint_policy_ids                    = try(each.value.service_endpoint_policy_ids, null)
  enforce_private_link_endpoint_network_policies = try(each.value.enforce_private_link_endpoint_network_policies, null)
  enforce_private_link_service_network_policies  = try(each.value.enforce_private_link_service_network_policies, false)
  delegation                                     = try(each.value.delegation, null)
  resource_groups                                = module.Landscape-Resource-Groups
}

output "VirtualSubnets" {
  value = module.Landscape-Virtual-Subnets
}


variable "PublicIPPrefixes" {
  default = {}
}

module "Landscape-Public-IP-Prefixes" {
  source          = "../../../AzureRM/Modules/Network/Azure-PublicIPPrefix/1.0"
  for_each        = var.PublicIPPrefixes
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location,null)
  prefix_length   = each.value.prefix_length
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}


output "PublicIPPrefixes" {
  value = module.Landscape-Public-IP-Prefixes
}


variable "PublicIPAddresses" {
  default = {}
}

module "Landscape-Public-IP-Addresses" {
  source                  = "../../../AzureRM/Modules/Network/Azure-PublicIPAddress/1.0"
  for_each                = var.PublicIPAddresses
  name                    = each.value.name == null ? each.key : each.value.name
  resource_group          = each.value.resource_group
  location                = try(each.value.location, null)
  allocation_method       = try(each.value.allocation_method, "Dynamic")
  sku                     = try(each.value.sku, null)
  ip_version              = try(each.value.ip_version, null)
  idle_timeout_in_minutes = try(each.value.idle_timeout_in_minutes, 10)
  domain_name_label       = try(each.value.domain_name_label, null)
  reverse_fqdn            = try(each.value.reverse_fqdn, null)

  availability_zone = try(each.value.availability_zone, null)
  public_ip_prefix  = try(each.value.public_ip_prefix, null)

  public_ip_prefixes = module.Landscape-Public-IP-Prefixes

  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}

output "PublicIpAddresses" {
  value = module.Landscape-Public-IP-Addresses
}

variable "NetworkInterfaces" {
  default = {}
}



module "Landscape-Virtual-Network-Interfaces" {
  source                        = "../../../AzureRM/Modules/Network/Azure-NetworkInterface/1.1"
  for_each                      = var.NetworkInterfaces
  name                          = each.value.name == null ? each.key : each.value.name
  resource_group                = each.value.resource_group
  location                      = try(each.value.location, null)
  tags                          = try(each.value.tags, local.tags)
  inherit_tags                  = try(each.value.inherit_tags, false)
  dns_servers                   = try(each.value.dns_servers, [])
  enable_ip_forwarding          = try(each.value.enable_ip_forwarding, false)
  enable_accelerated_networking = try(each.value.enable_accelerated_networking, false)
  internal_dns_name_label       = try(each.value.internal_dns_name_label, null)
  ip_configuration              = each.value.ip_configuration
  application_security_group    = try(each.value.application_security_group,null)
  network_security_group        = try(each.value.network_security_group, null)
  virtual_networks              = module.Landscape-Virtual-Networks
  public_ip_addresses           = module.Landscape-Public-IP-Addresses
  application_security_groups   = module.Landscape-Application-Security-Groups
  network_security_groups       = module.Landscape-Network-Security-Groups
  loadbalancers                 = merge(module.Landscape-Consolidated-Loadbalancers, module.Landscape-Loadbalancer-Backend-Address-Pools)
  resource_groups               = module.Landscape-Resource-Groups
}

output "NetworkInterfaces" {
  value = module.Landscape-Virtual-Network-Interfaces
}

variable "NetworkInterfaceBackendAddressPoolAssociations" {
  default = {}
}

module "Landscape-Network-Interface-Backend-Address-Pool-Associations" {
  source                = "../../../AzureRM/Modules/Network/Azure-NetworkInterfaceBackendAddressPoolAssociation/1.0"
  for_each              = var.NetworkInterfaceBackendAddressPoolAssociations
  network_interface     = each.value.network_interface
  ip_configuration_name = each.value.ip_configuration_name
  backend_address_pool  = each.value.backend_address_pool
  network_interfaces    = module.Landscape-Virtual-Network-Interfaces
  backend_address_pools = module.Landscape-Loadbalancer-Backend-Address-Pools
}

output "NetworkInterfaceBackendAddressPoolAssociations" {
  value = module.Landscape-Network-Interface-Backend-Address-Pool-Associations
}