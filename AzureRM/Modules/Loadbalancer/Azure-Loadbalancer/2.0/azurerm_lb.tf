resource "azurerm_lb" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = var.sku == null ? "Standard" : var.sku
  tags                = local.tags

  dynamic "frontend_ip_configuration" {
    for_each = { for instance in var.frontend_ip_configuration : instance.name => instance if(var.frontend_ip_configuration != null || var.frontend_ip_configuration != []) }
    content {
      name = try(frontend_ip_configuration.value.name, frontend_ip_configuration.key)

      subnet_id = frontend_ip_configuration.value.subnet == null ? null : (
        frontend_ip_configuration.value.subnet.id == null ? (
          try(frontend_ip_configuration.value.subnet.name, null) == null && try(frontend_ip_configuration.value.subnet.virtual_network_name, null) == null ? (
            var.virtual_networks[frontend_ip_configuration.value.subnet.virtual_network_tag].subnet[frontend_ip_configuration.value.subnet.tag].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${try(frontend_ip_configuration.value.subnet.resource_group_name, local.resource_group_name)}/providers/Microsoft.Network/virtualNetworks/${frontend_ip_configuration.value.subnet.virtual_network_name}/subnets/${frontend_ip_configuration.value.subnet.name}"
        ) : frontend_ip_configuration.value.subnet.id
      )

      private_ip_address = frontend_ip_configuration.value.private_ip_address == null && (frontend_ip_configuration.value.private_ip_address_allocation == null || frontend_ip_configuration.value.private_ip_address_allocation == "Dynamic") ? null : frontend_ip_configuration.value.private_ip_address

      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation == null || frontend_ip_configuration.value.private_ip_address == null ? "Dynamic" : frontend_ip_configuration.value.private_ip_address_allocation

      private_ip_address_version = frontend_ip_configuration.value.private_ip_address_version == null ? null : frontend_ip_configuration.value.private_ip_address_version

      public_ip_address_id = frontend_ip_configuration.value.public_ip_address == null ? null : (
        try(frontend_ip_configuration.value.public_ip_address.id, null) == null ? (
          try(frontend_ip_configuration.value.public_ip_address.name, null) == null ? (
            var.public_ip_addresses[frontend_ip_configuration.value.public_ip_address.tag].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${try(frontend_ip_configuration.value.public_ip_address.resource_group_name, local.resource_group_name)}/providers/Microsoft.Network/publicIPAddresses/${frontend_ip_configuration.value.public_ip_address.name}"
        ) : frontend_ip_configuration.value.public_ip_address.id
      )

      public_ip_prefix_id = frontend_ip_configuration.value.public_ip_prefix == null ? null : (
        try(frontend_ip_configuration.value.public_ip_prefix.id, null) == null ? (
          try(frontend_ip_configuration.value.public_ip_prefix.name, null) == null ? (
            var.public_ip_prefixes[frontend_ip_configuration.value.public_ip_prefix.tag].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${try(frontend_ip_configuration.value.public_ip_prefix.resource_group_name, local.resource_group_name)}/providers/Microsoft.Network/publicIPAddresses/${frontend_ip_configuration.value.public_ip_prefix.name}"
        ) : frontend_ip_configuration.value.public_ip_prefix.id
      )

      availability_zone = frontend_ip_configuration.value.availability_zone
    }
  }
}

