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

data "azurerm_firewall_policy" "this" {
  count               = var.firewall_policy == null ? 0 : (var.firewall_policy.name == null ? 0 : 1)
  name                = var.firewall_policy.name
  resource_group_name = coalesce(var.firewall_policy.resource_group_name, local.resource_group_name)
}

data "azurerm_virtual_network" "this" {
  count               = var.ip_configuration.subnet.virtual_network_name == null ? 0 : 1
  name                = var.ip_configuration.subnet.virtual_network_name
  resource_group_name = coalesce(var.ip_configuration.subnet.resource_group_name, local.resource_group_name)
}

data "azurerm_subnet" "this" {
  count                = var.ip_configuration.subnet.virtual_network_name == null ? 0 : 1
  name                 = "AzureFirewallSubnet"
  virtual_network_name = var.ip_configuration.subnet.virtual_network_name
  resource_group_name  = coalesce(var.ip_configuration.subnet.resource_group_name, local.resource_group_name)
}

data "azurerm_subnet" "management-this" {
  count                = var.management_ip_configuration == null ? 0 : (var.ip_configuration.subnet.virtual_network_name == null ? 0 : 1)
  name                 = "AzureFirewallManagementSubnet"
  virtual_network_name = var.ip_configuration.subnet.virtual_network_name
  resource_group_name  = coalesce(var.ip_configuration.subnet.resource_group_name, local.resource_group_name)
}


# Public IP is mandatory right now.
#https://docs.microsoft.com/en-us/azure/firewall/firewall-faq#can-i-deploy-azure-firewall-without-a-public-ip-address
data "azurerm_public_ip" "this" {
  count               = var.ip_configuration.public_ip_address.name == null ? 0 : 1
  name                = var.ip_configuration.public_ip_address.name
  resource_group_name = coalesce(var.ip_configuration.public_ip_address.resource_group_name, local.resource_group_name)
}

# Public IP is mandatory right now.
#https://docs.microsoft.com/en-us/azure/firewall/firewall-faq#can-i-deploy-azure-firewall-without-a-public-ip-address
data "azurerm_public_ip" "management-this" {
  count               = var.management_ip_configuration == null ? 0 : (var.ip_configuration.public_ip_address.name == null ? 0 : 1)
  name                = var.ip_configuration.public_ip_address.name
  resource_group_name = coalesce(var.ip_configuration.public_ip_address.resource_group_name, local.resource_group_name)
}


data "azurerm_virtual_hub" "this" {
  count               = var.virtual_hub == null ? 0 : (var.virtual_hub.virtual_hub.name == null ? 0 : 1)
  name                = var.virtual_hub.virtual_hub.name
  resource_group_name = coalesce(var.virtual_hub.virtual_hub.resource_group_name, local.resource_group_name)
}

locals {
  firewall_policy_id = var.firewall_policy == null ? null : (
    var.firewall_policy.id == null ? (
      var.firewall_policy.name == null ? (
        var.firewall_policies[var.firewall_policy.key].id
      ) : data.azurerm_firewall_policy.this[0].id
    ) : var.firewall_policy.id
  )

  ip_configuration = {
    name = var.ip_configuration.name == null ? "primary_configuration" : var.ip_configuration.name
    subnet_id = var.ip_configuration.subnet.id == null ? (
      var.ip_configuration.subnet.virtual_network_name == null ? (
        var.virtual_networks[var.ip_configuration.subnet.virtual_network_tag].subnet["AzureFirewallSubnet"].id
      ) : data.azurerm_subnet.this[0].id
    ) : var.ip_configuration.subnet.id
    public_ip_address_id = var.ip_configuration.public_ip_address.id == null ? (
      var.ip_configuration.public_ip_address.name == null ? (
        var.public_ip_addresses[var.ip_configuration.public_ip_address.key].id
      ) : data.azurerm_public_ip.this[0].id
    ) : var.ip_configuration.public_ip_address.id
  }

  management_ip_configuration = var.management_ip_configuration == null ? null : {
    name = var.management_ip_configuration.name == null ? "management_configuration" : var.management_ip_configuration.name
    subnet_id = var.management_ip_configuration.subnet.id == null ? (
      var.ip_configuration.subnet.virtual_network_name == null ? (
        var.virtual_networks[var.ip_configuration.subnet.virtual_network_tag].subnet["AzureFirewallManagementSubnet"].id
      ) : data.azurerm_subnet.management-this[0].id
    ) : var.management_ip_configuration.subnet.id
    public_ip_address_id = var.management_ip_configuration.public_ip_address.id == null ? (
      var.management_ip_configuration.public_ip_address.name == null ? (
        var.public_ip_addresses[var.management_ip_configuration.public_ip_address.key].id
      ) : data.azurerm_public_ip.management-this[0].id
    ) : var.management_ip_configuration.public_ip_address.id
  }

  virtual_hub = var.virtual_hub == null ? null : {
    public_ip_count = coalesce(var.virtual_hub.public_ip_count, 1)
    virtual_hub_id = var.virtual_hub.virtual_hub.id == null ? (
      var.virtual_hub.virtual_hub.name == null ? (
        var.virtual_hubs[var.virtual_hub.virtual_hub.key].id
      ) : data.azurerm_virtual_hub.this[0].id
    ) : var.virtual_hub.virtual_hub.id
  }
}

