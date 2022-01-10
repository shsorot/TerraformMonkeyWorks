
resource "azurerm_local_network_gateway" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  address_space       = var.address_space
  gateway_address     = try(var.gateway_address, null)
  gateway_fqdn        = try(var.gateway_fqdn, null)

  dynamic "bgp_settings" {
    for_each = var.bgp_settings != null ? var.bgp_settings : []
    content {
      asn                 = bgp_settings.value.asn
      bgp_peering_address = bgp_settings.value.peering_address
      peer_weight         = try(bgp_settings.value.peer_weight, null)
    }
  }
}