resource "azurerm_virtual_hub" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  address_prefix      = var.address_prefix

  dynamic "route" {
    for_each = var.route == null ? [] : var.route
    content {
      address_prefixes    = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }

  sku            = var.sku
  virtual_wan_id = local.virtual_wan_id

}