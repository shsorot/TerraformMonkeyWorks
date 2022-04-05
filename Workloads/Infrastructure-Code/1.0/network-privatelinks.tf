variable "PrivateEndpoints" {
  default = {}
}

module "Landscape-Private-Endpoints" {
  source                     = "../../../AzureRM/Modules/Network/Azure-PrivateEndpoint/1.0"
  for_each                   = var.PrivateEndpoints
  name                       = each.value.name == null ? each.key : each.value.name
  resource_group             = each.value.resource_group
  location                   = try(each.value.location, null)
  tags                       = try(each.value.tags, local.tags)
  inherit_tags               = try(each.value.inherit_tags, false)
  subnet                     = each.value.subnet
  private_dns_zone_group     = try(each.value.private_dns_zone_group, null)
  private_service_connection = try(each.value.private_service_connection, null)
  dns_zones                  = module.Landscape-Private-DNS-Zones
  virtual_networks           = module.Landscape-Virtual-Networks
  resource_groups            = module.Landscape-Resource-Groups
}


output "PrivateEndpoints" {
  value = module.Landscape-Private-Endpoints
}