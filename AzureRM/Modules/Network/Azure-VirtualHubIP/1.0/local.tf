# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  client_id       = data.azurerm_client_config.current.client_id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azurerm_client_config.current.object_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}

data "azurerm_virtual_hub" "this" {
  count               = var.virtual_hub.name == null && var.virtual_hub.resource_group_name == null ? 0 : 1
  name                = var.virtual_hub.name
  resource_group_name = var.virtual_hub.resource_group_name
}

data "azurerm_subnet" "this" {
  count                = var.subnet.name == null && var.subnet.virtual_network_name == null && var.subnet.resource_group_name == null ? 0 : 1
  name                 = var.subnet.name
  virtual_network_name = var.subnet.virtual_network_name
  resource_group_name  = var.subnet.resource_group_name
}

data "azurerm_public_ip" "this" {
  count               = var.public_ip_address.name == null && var.public_ip_address.resource_group_name == null ? 0 : 1
  name                = var.public_ip_address.name
  resource_group_name = var.public_ip_address.resource_group_name
}

locals {
  virtual_hub_id = var.virtual_hub.id == null ? (
    var.virtual_hub.name == null ? (
      var.virtual_hubs[var.virtual_hub.key].id
    ) : data.azurerm_virtual_hub.this[0].id
  ) : var.virtual_hub.id

  subnet_id = var.subnet.id == null ? (
    var.subnet.name == null && var.subnet.virtual_network_name == null ? (
      var.virtual_networks[var.subnet.virtual_network_tag].subnet[var.subnet.key].id
    ) : data.azurerm_subnet.this[0].id
  ) : var.subnet.id

  public_ip_address_id = var.public_ip_address == null ? null : (
    var.public_ip_address.id == null ? (
      var.public_ip_address.name == null ? (
        var.public_ip_addresses[var.public_ip_address.key].id
      ) : data.azurerm_public_ip.this[0].id
    ) : var.public_ip_address.id
  )

}