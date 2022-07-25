variable "PrivateDNSZones" {
  default = {}
}

module "Landscape-Private-DNS-Zones" {
  source          = "../../../AzureRM/Modules/PrivateDNS/Azure-PrivateDNSZone/1.0"
  for_each        = var.PrivateDNSZones
  name            = each.value.name == null ? each.key : each.value.name

  resource_group  = each.value.resource_group
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  soa_record      = try(each.value.soa_record, null)
  resource_groups = module.Landscape-Resource-Groups
}

output "PrivateDNSZones" {
  value = module.Landscape-Private-DNS-Zones
}

variable "PrivateDNSZonesVirtualNetworkLinks" {
  default = {}
}

module "Landscape-Private-DNS-Zones-Virtual-Network-Links" {
  source                = "../../../AzureRM/Modules/PrivateDNS/Azure-PrivateDNSZoneVirtualNetworkLink/1.0"
  for_each              = var.PrivateDNSZonesVirtualNetworkLinks
  name                  = each.value.name == null ? each.key : each.value.name

  resource_group        = each.value.resource_group
  tags                  = try(each.value.tags, local.tags)
  inherit_tags          = try(each.value.inherit_tags, false)
  private_dns_zone      = each.value.private_dns_zone
  virtual_network       = each.value.virtual_network
  registration_enabled  = try(each.value.registration_enabled, null)
  virtual_networks      = module.Landscape-Virtual-Networks
  resource_groups       = module.Landscape-Resource-Groups
  private_dns_zones     = module.Landscape-Private-DNS-Zones
}

output "PrivateDNSZonesVirtualNetworkLinks" {
  value = module.Landscape-Private-DNS-Zones-Virtual-Network-Links
}