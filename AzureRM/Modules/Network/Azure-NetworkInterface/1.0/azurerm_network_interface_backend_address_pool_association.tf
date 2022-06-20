# TODO : Add data block based lookup
resource "azurerm_network_interface_backend_address_pool_association" "this" {
  for_each              = local.load_balanced_ip_configuration
  network_interface_id  = azurerm_network_interface.this.id
  ip_configuration_name = each.key
  backend_address_pool_id = each.value.id == null ? (
    each.value.name == null && each.value.load_balancer_name == null ? (
      var.loadbalancers[each.value.loadbalancer_tag].backend_address_pool[each.value.backend_pool_tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name}/providers/Microsoft.Network/loadBalancers/${each.value.load_balancer_name}/backendAddressPools/${each.value.name}"
  ) : each.value.id
}
