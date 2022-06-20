# TODO : Add data block based lookup
resource "azurerm_network_interface" "this" {
  name                          = var.name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  enable_accelerated_networking = var.enable_accelerated_networking
  enable_ip_forwarding          = var.enable_ip_forwarding
  internal_dns_name_label       = var.internal_dns_name_label
  tags                          = local.tags

  dynamic "ip_configuration" {
    for_each = var.ip_configuration
    content {
      name = ip_configuration.value.name
      subnet_id = ip_configuration.value.subnet.id == null ? (
        ip_configuration.value.subnet.name == null && ip_configuration.value.subnet.virtual_network_name == null ? (
          var.virtual_networks[ip_configuration.value.subnet.virtual_network_tag].subnet[ip_configuration.value.subnet.key].id
        ) : "/subscriptions/${local.subscription_id}/resourceGroups/${ip_configuration.value.subnet.resource_group_name == null ? local.resource_group_name : ip_configuration.value.subnet.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${ip_configuration.value.subnet.virtual_network_name}/subnets/${ip_configuration.value.subnet.name}"
      ) : ip_configuration.value.subnet.id

      private_ip_address_version    = ip_configuration.value.private_ip_address_version
      private_ip_address_allocation = ip_configuration.value.private_ip_address == null ? "Dynamic" : "Static"
      private_ip_address            = ip_configuration.value.private_ip_address

      public_ip_address_id = ip_configuration.value.public_ip_address == null ? null : (
        ip_configuration.value.public_ip_address.id == null ? (
          ip_configuration.value.public_ip_address.name == null ? (
            var.public_ip_addresses[ip_configuration.value.public_ip_address.key].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${ip_configuration.value.public_ip_address.resource_group_name == null ? local.resource_group_name : ip_configuration.value.public_ip_address.resource_group_name}/providers/Microsoft.Network/publicIPAddresses/${ip_configuration.value.public_ip_address.name}"
        ) : ip_configuration.value.public_ip_address.id
      )

      primary = ip_configuration.value.primary == null ? (var.ip_configuration[0].name == ip_configuration.value.name ? true : false) : ip_configuration.value.primary
    }
  }
}