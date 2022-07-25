data "azurerm_subscription" "current" {
}
data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "this" {
  count = var.resource_group.name == null ? 0 : 1
  name  = var.resource_group.name
}

#Create the local variables
locals {
  client_id               = data.azurerm_client_config.current.client_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  subscription_id         = data.azurerm_subscription.current.subscription_id
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}

# Data block used by azurerm_subnet.tf
data "azurerm_virtual_network" "this"{
  count = var.subnet.virtual_network_name == null ? 0 : 1
  name  = var.subnet.virtual_network_name
  resource_group_name = coalesce(var.subnet.virtual_network_name,local.resource_group_name)
}

locals {
  virtual_network_name = var.subnet.virtual_network_name == null ? (
    var.virtual_networks[var.subnet.virtual_network_key].name
  ) : data.azurerm_virtual_network.this[0].name
  virtual_network_resource_group_name = var.subnet.virtual_network_name == null ? (
    var.virtual_networks[var.subnet.virtual_network_key].resource_group_name
  ) : data.azurerm_virtual_network.this[0].resource_group_name

  address_prefixes = var.subnet.address_prefixes
}