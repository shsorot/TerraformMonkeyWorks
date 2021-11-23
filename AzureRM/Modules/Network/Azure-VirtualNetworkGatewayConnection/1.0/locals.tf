# This file contains local & data blocks
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
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}

data "azurerm_virtual_network_gateway" "this" {
  count               = var.virtual_network_gateway.name == null ? 0 : 1
  name                = var.virtual_network_gateway.name
  resource_group_name = coalesce(var.virtual_network_gateway.resource_group_name, local.resource_group_name)
}

data "azurerm_virtual_network_gateway" "peer" {
  count               = var.peer_virtual_network_gateway == null && var.peer_virtual_network_gateway.name == null && var.type != "Vnet2Vnet" ? 0 : 1
  name                = var.virtual_network_gateway.name
  resource_group_name = coalesce(var.virtual_network_gateway.resource_group_name, local.resource_group_name)
}

data "azurerm_express_route_circuit" "this" {
  count               = var.express_route_circuit == null && var.express_route_circuit.name == null && var.type != "ExpressRoute" ? 0 : 1
  name                = var.express_route_circuit.name
  resource_group_name = coalesce(var.express_route_circuit.resource_group_name, local.resource_group_name)
}

data "azurerm_local_network_gateway" "this" {
  count               = var.local_network_gateway == null && var.local_network_gateway.name == null && var.type != "IPsec" ? 0 : 1
  name                = var.local_network_gateway.name
  resource_group_name = coalesce(var.local_network_gateway.resource_group_name, local.resource_group_name)
}


locals {
  virtual_network_gateway_id = var.virtual_network_gateway.id == null ? (
    var.virtual_network_gateway.name == null ? (
      var.virtual_network_gateways[var.virtual_network_gateway.tag].id
    ) : data.azurerm_virtual_network_gateway.this[0].id
  ) : var.virtual_network_gateway.id

  express_route_circuit_id = var.express_route_circuit == null ? null : (
    var.express_route_circuit.id == null ? (
      var.express_route_circuit.name == null ? (
        var.express_route_circuits[var.express_route_circuit.tag].id
      ) : data.azurerm_express_route_circuit.this[0].id
    ) : var.express_route_circuit.id
  )

  local_network_gateway_id = var.local_network_gateway == null ? null : (
    var.local_network_gateway.id == null ? (
      var.local_network_gateway.name == null ? (
        var.local_network_gateways[var.local_network_gateway.tag].id
      ) : data.azurerm_local_network_gateway.this[0].id
    ) : var.local_network_gateway.id
  )

  peer_virtual_network_gateway_id = var.peer_virtual_network_gateway == null ? null : (
    var.peer_virtual_network_gateway.id == null ? (
      var.peer_virtual_network_gateway.name == null ? (
        var.virtual_network_gateways[var.peer_virtual_network_gateway.tag].id
      ) : data.azurerm_virtual_network_gateway.peer[0].id
    ) : var.peer_virtual_network_gateway.id
  )
}