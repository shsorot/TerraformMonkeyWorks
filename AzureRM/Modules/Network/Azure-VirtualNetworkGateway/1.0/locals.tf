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
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}

data "azurerm_subnet" "this" {
  count                = var.ip_configuration.subnet.virtual_network_name == null ? 0 : 1
  name                 = "GatewaySubnet"
  virtual_network_name = var.ip_configuration.subnet.virtual_network_name
  resource_group_name  = coalesce(var.ip_configuration.subnet.resource_group_name, local.resource_group_name)
}

data "azurerm_public_ip" "this" {
  count               = var.ip_configuration.public_ip_address.name == null ? 0 : 1
  name                = var.ip_configuration.public_ip_address.name
  resource_group_name = coalesce(var.ip_configuration.public_ip_address.resource_group_name, local.resource_group_name)
}

data "azurerm_local_network_gateway" "this" {
  count               = var.default_local_network_gateway == null ? 0 : (var.default_local_network_gateway.name == null ? 0 : 1)
  name                = var.default_local_network_gateway.name
  resource_group_name = coalesce(var.default_local_network_gateway.resource_group_name, local.resource_group_name)
}


locals {
  subnet_id = var.ip_configuration.subnet.id == null ? (
    var.ip_configuration.subnet.virtual_network_name == null ? (
      "${var.virtual_networks[var.ip_configuration.subnet.virtual_network_tag].id}/subnets/GatewaySubnet"
    ) : data.azurerm_subnet.this[0].id
  ) : "${var.ip_configuration.subnet.id}/subnets/GatewaySubnet"

  public_ip_address_id = var.ip_configuration.public_ip_address.id == null ? (
    var.ip_configuration.public_ip_address.name == null ? (
      var.public_ip_addresses[var.ip_configuration.public_ip_address.key].id
    ) : data.azurerm_public_ip.this[0].id
  ) : var.ip_configuration.public_ip_address.id


  default_local_network_gateway_id = var.default_local_network_gateway == null ? null : (
    var.default_local_network_gateway.id == null ? (
      var.default_local_network_gateway.name == null ? (
        var.local_network_gateways[var.default_local_network_gateway.key].id
      ) : data.azurerm_local_network_gateway.this[0].id
    ) : var.default_local_network_gateway.id
  )
}