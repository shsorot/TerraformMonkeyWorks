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

variable "Firewallpolicies"{
  default = {}
}


module "Landscape-Azure-Firewall-Policies"{
  source = "../../../AzureRM/Modules/Network-Firewall/Azure-FirewallPolicy/1.0"
  for_each = var.Firewallpolicies
  name = each.value.name == null ? each.key : each.value.name
  resource_group = each.value.resource_group
  location = try(each.value.location, null)
  tags = try(each.value.tags, local.tags)
  inherit_tags = try(each.value.inherit_tags, false)
  base_policy = try(each.value.base_policy,null)
  dns = try(each.value.dns, null)
  insights = try(each.value.insights,null)
  intrusion_detection = try(each.value.intrusion_detection,null)
  private_ip_ranges = try(each.value.private_ip_ranges,null)
  sku = try(each.value.sku,"Standard")
  threat_intelligence_allowlist = try(each.value.threat_intelligence_allowlist,null)
  threat_intelligence_mode = try(each.value.threat_intelligence_mode,"Alert")
  tls_certificate  = try(each.value.tls_certificate,null)

  log_analytics_workspaces = module.Landscape-Log-Analytics-Workspaces
  resource_groups = module.Landscape-Resource-Groups
  keyvault_certificates = module.Landscape-Key-Vault-Certificates
  user_assigned_identities                        = module.Landscape-User-Assigned-Identities
}

output "Firewallpolicies"{
  value = module.Landscape-Azure-Firewall-Policies
}