# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  scope           = var.scope
}
