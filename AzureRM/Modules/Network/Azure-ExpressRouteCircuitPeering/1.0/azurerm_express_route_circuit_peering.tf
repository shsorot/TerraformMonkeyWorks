# TODO : Add data block based lookup
resource "azurerm_express_route_circuit_peering" "this" {
  peering_type                  = var.peering_type
  express_route_circuit_name    = local.express_route_circuit_name
  resource_group_name           = local.resource_group_name
  primary_peer_address_prefix   = var.primary_peer_address_prefix
  secondary_peer_address_prefix = var.secondary_peer_address_prefix
  vlan_id                       = var.vlan_id
  shared_key                    = var.shared_key
  peer_asn                      = var.peer_asn
  dynamic "microsoft_peering_config" {
    for_each = var.microsoft_peering_config == null && var.peering_type != "MicrosoftPeering" ? [] : [1]
    content {
      advertised_public_prefixes = var.microsoft_peering_config.advertised_public_prefixes
      customer_asn               = var.microsoft_peering_config.customer_asn
      routing_registry_name      = var.microsoft_peering_config.routing_registry_name
    }
  }
  dynamic "ipv6" {
    for_each = var.ipv6 == null ? [] : [1]
    content {
      microsoft_peering {
        advertised_public_prefixes = var.ipv6.microsoft_peering.advertised_public_prefixes
        customer_asn               = var.ipv6.microsoft_peering.customer_asn
        routing_registry_name      = var.ipv6.microsoft_peering.routing_registry_name
      }
      primary_peer_address_prefix   = var.ipv6.primary_peer_address_prefix
      secondary_peer_address_prefix = var.ipv6.secondary_peer_address_prefix
      route_filter_id = var.peering_type == "MicrosoftPeering" ? (
        var.ipv6.route_filter.id == null ? (
          var.ipv6.route_filter.name == null && var.ipv6.route_filter.resource_group_name == null ? (
            var.route_filters[var.ipv6.route.key].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.ipv6.route_filter.resource_group_name}/providers/Microsoft.Network/routeFilters/${var.ipv6.route_filter.name}"
        ) : var.ipv6.route_filter.id
      ) : null
    }
  }
  route_filter_id = var.peering_type != "MicrosoftPeering" ? null : (
    var.route_filter.id == null ? (
      var.route_filter.name == null && var.route_filter.resource_group_name == null ? (
        var.route_filters[var.route_filter.key].id
      ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.route_filter.resource_group_name}/providers/Microsoft.Network/routeFilters/${var.route_filter.name}"
    ) : var.route_filter.id
  )
}