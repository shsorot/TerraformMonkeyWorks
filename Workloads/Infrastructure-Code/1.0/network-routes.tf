

variable "RouteTables" {
  default = {}
}

module "Landscape-Route-Tables" {
  source                        = "../../../AzureRM/Modules/Network/Azure-RouteTable/1.1"
  for_each                      = var.RouteTables
  name                          = each.value.name == null ? each.key : each.value.name
  resource_group                = each.value.resource_group
  location                      = try(each.value.location, null)
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  route                         = each.value.route
  tags                          = try(each.value.tags, local.tags)
  inherit_tags                  = try(each.value.inherit_tags, false)
  resource_groups               = module.Landscape-Resource-Groups
}


output "RouteTables" {
  value = module.Landscape-Route-Tables
}


variable "Routes" {
  default = {}
}

module "Landscape-Routes" {
  source                 = "../../../AzureRM/Modules/Network/Azure-Route/1.0"
  for_each               = var.Routes
  name                   = each.value.name == null ? each.key : each.value.name
  resource_group_name    = each.value.resource_group_name
  route_table            = each.value.route_table
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
  route_tables           = module.Landscape-Route-Tables
}

output "Routes" {
  value = module.Landscape-Routes
}

variable "RouteFilters" {
  default = {}
}

module "Landscape-Route-Filters" {
  source          = "../../../AzureRM/Modules/Network/Azure-RouteFilter/1.0"
  for_each        = var.RouteFilters
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, {})
  inherit_tags    = try(each.value.inherit_tags, false)
  rule            = each.value.rule
  resource_groups = module.Landscape-Resource-Groups
}

output "RouteFilters" {
  value = module.Landscape-Route-Filters
}

variable "SubnetRouteTableAssociations" {
  default = {}
}

module "Landscape-Subnet-Route-Table-Association" {
  source           = "../../../AzureRM/Modules/Network/Azure-SubnetRouteTableAssociation/1.0"
  for_each         = var.SubnetRouteTableAssociations
  subnet           = each.value.subnet
  route_table      = each.value.route_table
  virtual_networks = module.Landscape-Virtual-Networks
  route_tables     = module.Landscape-Route-Tables
}

output "SubnetRouteTableAssociations" {
  value = module.Landscape-Subnet-Route-Table-Association
}
