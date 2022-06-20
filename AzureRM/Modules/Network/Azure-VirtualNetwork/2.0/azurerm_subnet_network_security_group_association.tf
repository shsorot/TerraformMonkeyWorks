# Network Security Group association to Subnets
# TODO: Add data based lookup
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.security_groups

  network_security_group_id = each.value.id == null ? (
    each.value.name == null ? (
      each.value.tag == null ? null : var.network_security_groups[each.value.key].id
      ) : (
      "/subscriptions/${data.azurerm_subscription.current.id}/resourceGroups/${each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/${each.value.name}"
    )
  ) : each.value.id
  subnet_id = azurerm_subnet.this[each.key].id
}