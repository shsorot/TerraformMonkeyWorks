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

data "azurerm_route_table" "this" {
  count               = var.route_table.name == null ? 0 : 1
  name                = var.route_table.name
  resource_group_name = var.resource_group_name
}

locals {
  route_table_name = var.route_table.name == null ? var.route_tables[var.route_table.key].name : data.azurerm_route_table.this[0].name
}
