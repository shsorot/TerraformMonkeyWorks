# TODO : Add data block based lookup
resource "azurerm_lb_backend_address_pool_address" "this" {
  for_each = { for instance in(var.backend_address_pool_address == null ? [] : var.backend_address_pool_address) : instance.name => instance }

  name                    = each.value.name == null ? each.key : each.value.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_name].id
  virtual_network_id = try(each.value.virtual_network.id, null) == null ? (
    try(each.value.virtual_network.name, null) == null ? (
      var.virtual_networks[each.value.virtual_network.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${try(each.value.virtual_network.resource_group_name, local.resource_group_name)}/providers/Microsoft.Network/virtualNetworks/${each.value.virtual_network.name}"
  ) : each.value.virtual_network.id

  ip_address = each.value.ip_address
}


