resource "azurerm_virtual_network" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  tags                = local.tags
  location            = local.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  bgp_community       = var.bgp_community

  #v added DDOS block
  dynamic "ddos_protection_plan" {
    for_each = local.ddos_protection_plan_id == null ? [] : [1]
    content {
      id     = local.ddos_protection_plan_id
      enable = true
    }
  }
}
