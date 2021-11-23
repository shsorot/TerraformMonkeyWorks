variable "VirtualWANs" {
  default = {}
}

module "Landscape-Virtual-WANs" {
  source                            = "../../../AzureRM/Modules/Network/Azure-VirtualWAN/1.0"
  for_each                          = var.VirtualWANs
  name                              = each.value.name == null ? each.key : each.value.name
  resource_group                    = each.value.resource_group
  location                          = each.value.location
  tags                              = each.value.tags
  inherit_tags                      = each.value.inherit_tags
  disable_vpn_encryption            = try(each.value.disable_vpn_encryption, false)
  allow_branch_to_branch_traffic    = try(each.value.allow_branch_to_branch_traffic, false)
  office365_local_breakout_category = try(each.value.office365_local_breakout_category, "None")
  type                              = try(each.value.type, "Standard")
  resource_groups                   = module.Landscape-Resource-Groups
}

output "VirtualWANs" {
  value = module.Landscape-Virtual-WANs
}




variable "ExpressRoutePorts" {
  default = {}
}

# <TODO> Add a refernce to key vault secret for use in Link1,link2 and identity block variables
module "Landscape-ExpressRoute-Ports" {
  source            = "../../../AzureRM/Modules/Network/Azure-ExpressRoutePort/1.0"
  for_each          = var.ExpressRoutePorts
  name              = each.value.name == null ? each.key : each.value.namepressRoutePorts
  resource_group    = each.value.resource_group
  location          = try(each.value.location, null)
  tags              = try(each.value.tags, {})
  inherit_tags      = try(each.value.inherit_tags, false)
  bandwidth_in_gbps = each.value.bandwidth_in_gbps
  encapsulation     = each.value.encapsulation
  peering_location  = each.value.peering_location
  link1             = try(each.value.link1, null)
  link2             = try(each.value.link2, null)
  identity          = try(each.value.identity, null)
  resource_groups   = module.Landscape-Resource-Groups
}

output "ExpressRoutePorts" {
  value = module.Landscape-ExpressRoute-Ports
}



variable "ExpressRouteCircuits" {
  default = {}
}


module "Landscape-ExpressRoute-Circuits" {
  source                   = "../../../AzureRM/Modules/Network/Azure-ExpressRouteCircuit/1.0"
  for_each                 = var.ExpressRouteCircuits
  name                     = each.value.name == null ? each.key : each.value.name
  resource_group           = each.value.resource_group
  location                 = try(each.value.location, null)
  tags                     = try(each.value.tags, {})
  inherit_tags             = try(each.value.inherit_tags, false)
  sku                      = each.value.sku
  service_provider_name    = try(each.value.service_provider_name, null)
  peering_location         = try(each.value.peering_location, null)
  bandwidth_in_mbps        = try(each.value.bandwidth_in_mbps, null)
  allow_classic_operations = try(each.value.allow_classic_operations, false)
  express_route_port       = try(each.value.express_route_port, null)
  bandwidth_in_gbps        = try(each.value.bandwidth_in_gbps, null)
  resource_groups          = module.Landscape-Resource-Groups
  express_route_ports      = module.Landscape-ExpressRoute-Ports
}


output "ExpressRouteCircuits" {
  value = module.Landscape-ExpressRoute-Circuits
}

variable "ExpressRouteCircuitAuthorizations" {
  default = {}
}

module "Landscape-ExpressRoute-Circuit-Authorization" {
  source                 = "../../../AzureRM/Modules/Network/Azure-ExpressRouteCircuitAuthorization/1.0"
  for_each               = var.ExpressRouteCircuitAuthorizations
  name                   = each.value.name == null ? each.key : each.value.name
  resource_group         = each.value.resource_group
  express_route_circuit  = each.value.express_route_circuit
  resource_groups        = module.Landscape-Resource-Groups
  express_route_circuits = module.Landscape-ExpressRoute-Circuits
}

output "ExpressRouteCircuitAuthorizations" {
  value = module.Landscape-ExpressRoute-Circuit-Authorization
}



variable "ExpressRouteGateways" {
  default = {}
}


module "Landscape-ExpressRoute-Gateways" {
  source          = "../../../AzureRM/Modules/Network/Azure-ExpressRouteGateway/1.0"
  for_each        = var.ExpressRouteGateways
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, {})
  inherit_tags    = try(each.value.inherit_tags, false)
  scale_units     = each.value.scale_units
  virtual_hub     = each.value.virtual_hub
  resource_groups = module.Landscape-Resource-Groups
  virtual_hubs    = module.Landscape-Virtual-Hubs
}


output "ExpressRouteGateways" {
  value = module.Landscape-ExpressRoute-Gateways
}


variable "ExpressRouteCircuitPeerings" {
  default = {}
}



module "Landscape-ExpressRoute-Circuit-Peerings" {
  source                        = "../../../AzureRM/Modules/Network/Azure-ExpressRouteCircuitPeering/1.0"
  for_each                      = var.ExpressRouteCircuitPeerings
  peering_type                  = each.value.peering_type
  resource_group                = each.value.resource_group
  express_route_circuit         = each.value.express_route_circuit
  primary_peer_address_prefix   = each.value.primary_peer_address_prefix
  secondary_peer_address_prefix = each.value.secondary_peer_address_prefix
  vlan_id                       = each.value.vlan_id
  shared_key                    = try(each.value.shared_key, null)
  peer_asn                      = each.value.peer_asn
  microsoft_peering_config      = try(each.value.microsoft_peering_config, null)
  ipv6                          = try(each.value.ipv6, false)
  route_filter                  = try(each.value.route_filter, null)
  express_route_circuits        = module.Landscape-ExpressRoute-Circuits
  resource_groups               = module.Landscape-Resource-Groups
  route_filters                 = module.Landscape-Route-Filters
}

output "ExpressRouteCircuitPeerings" {
  value = module.Landscape-ExpressRoute-Circuit-Peerings
}

variable "ExpressRouteConnections" {
  default = {}
}

module "Landscape-ExpressRoute-Connections" {
  source                         = "../../../AzureRM/Modules/Network/Azure-ExpressRouteConnection/1.0"
  for_each                       = var.ExpressRouteConnections
  name                           = each.value.name == null ? each.key : each.value.name
  express_route_circuit_peering  = each.value.express_route_circuit_peering
  express_route_gateway          = each.value.express_route_gateway
  authorization_key              = each.value.authorization_key
  enable_internet_security       = each.value.enable_internet_security
  routing                        = try(each.value.routing, null)
  routing_weight                 = try(each.value.routing_weight, 0)
  virtual_hub_route_tables       = module.Landscape-Virtual-Hub-Route-Tables
  express_route_circuit_peerings = module.Landscape-ExpressRoute-Circuit-Peerings
  express_route_gateways         = module.Landscape-ExpressRoute-Gateways
}

output "ExpressRouteConnections" {
  value = module.Landscape-ExpressRoute-Connections
}

variable "ExpressRouteCircuitConnections" {
  default = {}
}

module "Landscape-ExpressRoute-Circuit-Connections" {
  source                         = "../../../AzureRM/Modules/Network/Azure-ExpressRouteCircuitConnection/1.0"
  for_each                       = var.ExpressRouteCircuitConnections
  name                           = each.value.name == null ? each.key : each.value.name
  peering                        = each.value.peering
  peer_peering                   = each.value.peer_peering
  address_prefix_ipv6            = each.value.address_prefix_ipv6
  address_prefix_ipv4            = each.value.address_prefix_ipv4
  authorization_key              = each.value.authorization_key
  express_route_circuit_peerings = module.Landscape-ExpressRoute-Circuit-Peerings[each.value.express_route_circuit_peering]
}


output "ExpressRouteCircuitConnections" {
  value = module.Landscape-ExpressRoute-Circuit-Connections
}