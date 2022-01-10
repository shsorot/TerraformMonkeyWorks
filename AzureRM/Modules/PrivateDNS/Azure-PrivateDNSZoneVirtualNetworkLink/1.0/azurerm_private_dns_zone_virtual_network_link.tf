resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.name
  resource_group_name   = local.resource_group_name
  tags                  = local.tags
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id = var.virtual_network.id == null ? (
    var.virtual_network.name == null ? (
      var.virtual_networks[var.virtual_network.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.virtual_network.resource_group_name == null ? local.resource_group_name : var.virtual_network.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network.name}"
  ) : var.virtual_network.id
  registration_enabled = var.registration_enabled
}