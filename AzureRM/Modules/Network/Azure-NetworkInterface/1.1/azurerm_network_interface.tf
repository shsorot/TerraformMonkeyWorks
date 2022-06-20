resource "azurerm_network_interface" "this" {
  name                          = var.name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  enable_accelerated_networking = var.enable_accelerated_networking
  enable_ip_forwarding          = var.enable_ip_forwarding
  internal_dns_name_label       = var.internal_dns_name_label
  tags                          = local.tags

  # Multiple blocks, Mandatory
  # TODO : add idx,instance style loop to select first list object as primary
  # TODO : Add data block based lookup
  dynamic "ip_configuration" {
    for_each = { for idx, instance in local.ip_configuration : idx => instance }
    content {
      name = ip_configuration.value.name
      subnet_id = ip_configuration.value.subnet_id
      private_ip_address_version    = ip_configuration.value.private_ip_address_version
      private_ip_address_allocation = ip_configuration.value.private_ip_address == null ? "Dynamic" : "Static"
      private_ip_address            = ip_configuration.value.private_ip_address

      public_ip_address_id = ip_configuration.value.public_ip_address_id
      # TODO : find a way to detect and set first IPConfig as primary if none of the configs have this property
      primary = ip_configuration.value.primary
    }
  }

  # Added in provider > 3.xx.0
  edge_zone = var.edge_zone
  dns_servers = var.dns_servers


}