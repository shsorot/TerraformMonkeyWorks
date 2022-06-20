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

# <TODO> assign data block and list based lookup for scope and resource types when scope is < subscription
locals {
  scope             = var.scope
  assignable_scopes = var.assignable_scopes
}