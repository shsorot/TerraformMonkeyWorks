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

locals {
  virtual_hub_id = var.virtual_hub.id == null ? (
    var.virtual_hub.name == null ? (
      var.virtual_hubs[var.virtual_hub.key].id
    ) : data.azurerm_virtual_hub.this[0].id
  ) : var.virtual_hub.id

  remote_virtual_network_id = var.remote_virtual_network.id == null ? (
    var.remote_virtual_network.name == null && var.remote_virtual_network.resource_group_name == null ? (
      var.remote_virtual_networks[var.remote_virtual_network.key].id
    ) : "/subscriptions/${coalesce(var.remote_virtual_network.subscription_id, local.subscription_id)}/resourceGroups/${var.remote_virtual_network.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.remote_virtual_network.name}"
  ) : var.remote_virtual_network.id

}