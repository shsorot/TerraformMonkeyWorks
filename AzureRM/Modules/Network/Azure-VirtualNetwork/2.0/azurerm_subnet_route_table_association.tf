
# Route Table association to Subnets
resource "azurerm_subnet_route_table_association" "this" {
  for_each = local.route_tables
  #route_table_id = var.route_table_id
  route_table_id = each.value.id == null ? (
    each.value.name == null ? (
      each.value.tag == null ? null : var.route_tables[each.value.tag].id
      ) : (
      "/subscriptions/${data.azurerm_subscription.current.id}/resourceGroups/${each.value.resource_group_name == null ? local.resource_group_name : each.value.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/${each.value.name}"
    )
  ) : each.value.route_table_id
  subnet_id = azurerm_subnet.this[each.key].id
}