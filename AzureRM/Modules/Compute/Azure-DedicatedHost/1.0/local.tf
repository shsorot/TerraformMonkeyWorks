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

data "azurerm_dedicated_host_group" "this" {
  count               = var.dedicated_host_group.name == null && var.dedicated_host_group.resource_group_name == null ? 0 : 1
  name                = var.dedicated_host_group.name
  resource_group_name = var.dedicated_host_group.resource_group_name
}

locals {
  dedicated_host_group_id = var.dedicated_host_group == null ? null : (
    var.dedicated_host_group.id == null ? (
      var.dedicated_host_group.name == null && var.dedicated_host_group.resource_group_name == null ? (
        var.dedicated_host_groups[var.dedicated_host_group.key].id
      ) : data.azurerm_dedicated_host_group.this[0].id
    ) : var.dedicated_host_group.id
  )
}