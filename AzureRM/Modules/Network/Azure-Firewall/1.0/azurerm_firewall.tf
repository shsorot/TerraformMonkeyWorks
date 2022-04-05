resource "azurerm_firewall" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  # Azure portal makes this mandatory, but not Terraform.  Potential Bug ?
  firewall_policy_id = local.firewall_policy_id
  # single block, Mandatory
  ip_configuration {
    name                 = local.ip_configuration.name
    public_ip_address_id = local.ip_configuration.public_ip_address_id
    subnet_id            = local.ip_configuration.subnet_id
  }
  dns_servers       = var.dns_servers
  private_ip_ranges = var.private_ip_ranges
  # single block
  dynamic "management_ip_configuration" {
    for_each = local.management_ip_configuration == null ? [] : [1]
    content {
      name                 = local.management_ip_configuration.name
      public_ip_address_id = local.management_ip_configuration.public_ip_address_id
      subnet_id            = local.management_ip_configuration.subnet_id
    }
  }
  threat_intel_mode = var.threat_intel_mode == null ? "" : var.threat_intel_mode
  # single block
  dynamic "virtual_hub" {
    for_each = local.virtual_hub == null ? [] : [1]
    content {
      public_ip_count = local.virtual_hub.public_ip_count
      virtual_hub_id  = local.virtual_hub.virtual_hub_id
    }
  }
  zones = var.zones
  tags  = local.tags
}