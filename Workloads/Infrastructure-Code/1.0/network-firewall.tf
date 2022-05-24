variable "AzureFirewalls" {
  default = {}
}


module "Landscape-Azure-Firewalls" {
  source              = "../../../AzureRM/Modules/Network-Firewall/Azure-Firewall/1.0"
  for_each            = var.AzureFirewalls
  name                = each.value.name == null ? each.key : each.value.name
  resource_group      = each.value.resource_group
  location            = try(each.value.location, null)
  tags                = try(each.value.tags, local.tags)
  inherit_tags        = try(each.value.inherit_tags, false)
  sku_name            = try(each.value.sku_name, null)
  sku_tier            = try(each.value.sku_tier, null)
  firewall_policy     = try(each.value.firewall_policy, null)
  ip_configuration    = try(each.value.ip_configuration, null)
  dns_servers         = try(each.value.dns_servers, null)
  threat_intel_mode   = try(each.value.threat_intel_mode, null)
  virtual_hub         = try(each.value.virtual_hub, null)
  zones               = try(each.value.zones, null)
  firewall_policies   = {}
  virtual_networks    = module.Landscape-Virtual-Networks
  resource_groups     = module.Landscape-Resource-Groups
  virtual_hubs        = module.Landscape-Virtual-Hubs
  public_ip_addresses = module.Landscape-Public-IP-Addresses
}

output "AzureFirewalls" {
  value = module.Landscape-Azure-Firewalls
}