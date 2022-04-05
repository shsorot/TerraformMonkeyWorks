variable "ConsolidatedLoadbalancers" {
  default = {}
}


module "Landscape-Consolidated-Loadbalancers" {
  source         = "../../../AzureRM/Modules/Loadbalancer/Azure-Loadbalancer/2.0"
  for_each       = var.ConsolidatedLoadbalancers
  name           = each.value.name == null ? each.key : each.value.name
  resource_group = each.value.resource_group
  location       = try(each.value.location, null)
  sku            = try(each.value.sku, null)
  tags           = try(each.value.tags, local.tags)
  inherit_tags   = try(each.value.inherit_tags, false)

  frontend_ip_configuration    = try(each.value.frontend_ip_configuration, [])
  backend_address_pool         = try(each.value.backend_address_pool, null)
  backend_address_pool_address = try(each.value.backend_address_pool_address, null)
  probe                        = try(each.value.probe, null)
  loadbalancer_rule            = try(each.value.loadbalancer_rule, null)
  loadbalancer_outbound_rule   = try(each.value.loadbalancer_outbound_rule, null)
  loadbalancer_nat_pool        = try(each.value.loadbalancer_nat_pool, null)
  loadbalancer_nat_rule        = try(each.value.loadbalancer_nat_rule, null)
  virtual_networks             = module.Landscape-Virtual-Networks
  public_ip_addresses          = module.Landscape-Public-IP-Addresses
  public_ip_prefixes           = module.Landscape-Public-IP-Prefixes
  resource_groups              = module.Landscape-Resource-Groups
}


output "ConsolidatedLoadbalancers" {
  value = module.Landscape-Consolidated-Loadbalancers
}


variable "Loadbalancers" {
  default = {}
}


module "Landscape-Loadbalancers" {
  source         = "../../../AzureRM/Modules/Loadbalancer/Azure-Loadbalancer/1.0"
  for_each       = var.Loadbalancers
  name           = each.value.name == null ? each.key : each.value.name
  resource_group = each.value.resource_group
  location       = try(each.value.location, null)
  sku            = try(each.value.sku, null)
  tags           = try(each.value.tags, local.tags)
  inherit_tags   = try(each.value.inherit_tags, false)

  frontend_ip_configuration = try(each.value.frontend_ip_configuration, [])
  virtual_networks          = module.Landscape-Virtual-Networks
  public_ip_addresses       = module.Landscape-Public-IP-Addresses
  public_ip_prefixes        = module.Landscape-Public-IP-Prefixes
  resource_groups           = module.Landscape-Resource-Groups
}


output "Loadbalancers" {
  value = module.Landscape-Loadbalancers
}


variable "LoadbalancerBackendAddressPools" {
  default = {}
}

module "Landscape-Loadbalancer-Backend-Address-Pools" {
  source        = "../../../AzureRM/Modules/Loadbalancer/Azure-LoadbalancerBackendAddressPool/1.0"
  for_each      = var.LoadbalancerBackendAddressPools
  name          = each.value.name == null ? each.key : each.value.name
  loadbalancer  = each.value.loadbalancer
  loadbalancers = merge(module.Landscape-Loadbalancers, module.Landscape-Consolidated-Loadbalancers)
}

output "LoadbalancerBackendAddressPools" {
  value = module.Landscape-Loadbalancer-Backend-Address-Pools
}


variable "LoadbalancerBackendAddressPoolAddresses" {
  default = {}
}

module "Landscape-Loadbalancer-Backend-Address-Pool-Addresses" {
  source                = "../../../AzureRM/Modules/Loadbalancer/Azure-LoadbalancerBackendAddressPoolAddress/1.0"
  for_each              = var.LoadbalancerBackendAddressPoolAddresses
  backend_address_pool  = each.value.backend_address_pool
  ip_address            = each.value.ip_address
  name                  = each.value.name == null ? each.key : each.value.name
  virtual_network       = each.value.virtual_network
  virtual_networks      = module.Landscape-Virtual-Networks
  backend_address_pools = module.Landscape-Loadbalancer-Backend-Address-Pools
}

output "LoadbalancerBackendAddressPoolAddresses" {
  value = module.Landscape-Loadbalancer-Backend-Address-Pool-Addresses
}


variable "LoadbalancerProbes" {
  default = {}
}

module "Landscape-Loadbalancer-Probes" {
  source              = "../../../AzureRM/Modules/Loadbalancer/Azure-LoadbalancerProbe/1.0"
  for_each            = var.LoadbalancerProbes
  name                = each.value.name == null ? each.key : each.value.name
  resource_group_name = each.value.resource_group_name
  loadbalancer        = each.value.loadbalancer
  protocol            = try(each.value.protocol, null)
  port                = each.value.port
  request_path        = try(each.value.request_path, null)
  interval_in_seconds = try(each.value.interval_in_seconds, 15)
  number_of_probes    = try(each.value.number_of_probes, 2)
  loadbalancers       = module.Landscape-Loadbalancers
}

output "LoadbalancerProbes" {
  value = module.Landscape-Loadbalancer-Probes
}

variable "LoadbalancerRules" {
  default = {}
}

module "Landscape-Loadbalancer-Rules" {
  source                         = "../../../AzureRM/Modules/Loadbalancer/Azure-LoadbalancerRule/1.0"
  for_each                       = var.LoadbalancerProbes
  name                           = each.value.name == null ? each.key : each.value.name
  loadbalancer                   = each.value.loadbalancer
  backend_address_pool           = try(each.value.backend_address_pool,null)
  probe                          = try(each.value.probe, null)
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol                       = each.value.protocol
  backend_port                   = each.value.backend_port
  frontend_port                  = each.value.frontend_port
  enable_floating_ip             = try(each.value.enable_floating_ip, false)
  idle_timeout_in_minutes        = try(each.value.idle_timeout_in_minutes, 4)
  load_distribution              = try(each.value.load_distribution, "Default")
  disable_outbound_snat          = try(each.value.disable_outbound_snat, false)
  enable_tcp_reset               = try(each.value.enable_tcp_reset, false)
  loadbalancers                  = module.Landscape-Loadbalancers
  backend_address_pools          = module.Landscape-Loadbalancer-Backend-Address-Pools
  probes                         = module.Landscape-Loadbalancer-Probes
}

output "LoadbalancerRules" {
  value = module.Landscape-Loadbalancer-Rules
}