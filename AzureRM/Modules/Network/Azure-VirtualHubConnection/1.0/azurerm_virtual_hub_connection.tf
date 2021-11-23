# <TODO> add localized lookup for route table IDs in nested routing block
resource "azurerm_virtual_hub_connection" "this" {
  name                      = var.name
  virtual_hub_id            = local.virtual_hub_id
  remote_virtual_network_id = local.remote_virtual_network_id
  internet_security_enabled = var.internet_security_enabled
  # <TODO> add data blocks for nested route_table id lookups when enabled by Terraform Azure provider
  dynamic "routing" {
    for_each = var.routing == null ? [] : [1]
    content {
      associated_route_table_id = var.routing.associated_route_table.id == null ? (
        var.routing.associated_route_table.name ? (
          var.route_tables[var.routing.associated_route_table.tag].id
        ) :
        "${local.virtual_hub_id}/hubRouteTables/${var.routing.associated_route_table.name}"
      ) : var.routing.associated_route_table.id

      dynamic "propagated_route_table" {
        for_each = var.routing.propagated_route_table == null ? [] : [1]
        content {
          labels = var.routing.propagated_route_table.labels
          route_table_ids = [for instance in var.routing.propagated_route_table.route_table_ids : instance.id == null ? (
            instance.name == null ? (
              var.route_tables[instance.tag].id
            ) :
            "${local.virtual_hub_id}/hubRouteTables/${instance.name}"
          ) : instance.id]
        }
      }
      dynamic "static_vnet_route" {
        for_each = var.routing.static_vnet_route == null ? [] : [1]
        content {
          name                = var.routing.static_vnet_route.name
          address_prefixes    = var.routing.static_vnet_route.address_prefixes
          next_hop_ip_address = var.routing.static_vnet_route.next_hop_ip_address
        }
      }
    }
  }
}