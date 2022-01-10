
variable "VirtualHubs" {
  default = {}
}

module "Landscape-Virtual-Hubs" {
  source          = "../../../AzureRM/Modules/Network/Azure-VirtualHub/1.0"
  for_each        = var.VirtualHubs
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location,null)
  tags            = try(each.value.tags,local.tags)
  inherit_tags    = each.value.inherit_tags
  address_prefix  = try(each.value.address_prefix, null)
  sku             = try(each.value.sku, null)
  route           = try(each.value.route, null)
  virtual_wan     = try(each.value.virtual_wan,null)
  virtual_wans    = module.Landscape-Virtual-WANs
  resource_groups = module.Landscape-Resource-Groups
}

output "VirtualHubs" {
  value = module.Landscape-Virtual-Hubs
}


variable "VirtualHubIPs" {
  default = {}
}

module "Landscape-Virtual-Hub-IPs" {
  source                       = "../../../AzureRM/Modules/Network/Azure-VirtualHubIP/1.0"
  for_each                     = var.VirtualHubIPs
  name                         = each.value.name == null ? each.key : each.value.name
  virtual_hub                  = each.value.virtual_hub
  subnet                       = each.value.subnet
  private_ip_address           = try(each.value.private_ip_address, null)
  private_ip_allocation_method = try(each.value.private_ip_allocation_method, "Dynamic")
  public_ip_address            = try(each.value.public_ip_address, null)
  virtual_hubs                 = module.Landscape-Virtual-Hubs
  virtual_networks             = module.Landscape-Virtual-Networks
  public_ip_addresses          = module.Landscape-Public-IP-Addresses
}

output "VirtualHubIPs" {
  value = module.Landscape-Virtual-Hub-IPs
}


variable "VirtualHubRouteTables" {
  default = {}
}


module "Landscape-Virtual-Hub-Route-Tables" {
  source       = "../../../AzureRM/Modules/Network/Azure-VirtualHubRouteTable/1.0"
  for_each     = var.VirtualHubRouteTables
  name         = each.value.name == null ? each.key : each.value.name
  virtual_hub  = each.value.virtual_hub
  labels       = try(each.value.labels, null)
  route        = each.value.route
  virtual_hubs = module.Landscape-Virtual-Hubs
}

output "VirtualHubRouteTables" {
  value = module.Landscape-Virtual-Hub-Route-Tables
}


variable "VirtualHubConnections" {
  default = {}
}

# <TODO>, Remote Virtual networks object should be coming from a remote state file as Terraform modules cannot accept dynamic providers at the moment.
module "Landscape-Virtual-Hub-Connections" {
  source                    = "../../../AzureRM/Modules/Network/Azure-VirtualHubConnection/1.0"
  for_each                  = var.VirtualHubConnections
  name                      = each.value.name == null ? each.key : each.value.name
  virtual_hub               = each.value.virtual_hub
  remote_virtual_network    = each.value.remote_virtual_network
  internet_security_enabled = try(each.value.internet_security_enabled, false)
  routing                   = each.value.routing
  virtual_hubs              = module.Landscape-Virtual-Hubs
  remote_virtual_networks   = module.Landscape-Virtual-Networks
  route_tables              = module.Landscape-Virtual-Hub-Route-Tables
}

output "VirtualHubConnections" {
  value = module.Landscape-Virtual-Hub-Connections
}


variable "VirtualHubRouteTableRoutes" {
  default = {}
}

module "Landscape-Virtual-Hub-Route-Table-Routes" {
  source                  = "../../../AzureRM/Modules/Network/Azure-VirtualHubRouteTableRoute/1.0"
  for_each                = var.VirtualHubRouteTableRoutes
  name                    = each.value.name == null ? each.key : each.value.name
  route_table             = each.value.route_table
  destinations            = each.value.destinations
  destinations_type       = each.value.destinations_type
  next_hop                = each.value.next_hop
  next_hop_type           = try(each.value.next_hop_type, "ResourceId")
  route_tables            = module.Landscape-Virtual-Hub-Route-Tables
  virtual_hub_connections = module.Landscape-Virtual-Hub-Connections
}

output "VirtualHubRouteTableRoutes" {
  value = module.Landscape-Virtual-Hub-Route-Table-Routes
}