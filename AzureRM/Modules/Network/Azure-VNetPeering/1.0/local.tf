# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}




#Create the local variables
locals {
  client_id           = data.azurerm_client_config.current.client_id
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  subscription_id     = data.azurerm_subscription.current.subscription_id
  resource_group_name = var.resource_group_name
}

locals {
  remote_virtual_network_id = var.remote_virtual_network.id == null ? (
    var.remote_virtual_network.name == null && var.remote_virtual_network.resource_group_name == null ? (
      var.virtual_networks[var.remote_virtual_network.key].id
    ) : "/subscriptions/${var.remote_virtual_network.subscription_id == null ? local.subscription_id : var.remote_virtual_network.subscription_id}/resourceGroups/${var.remote_virtual_network.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.remote_virtual_network.name}"
  ) : var.remote_virtual_network.id
}
