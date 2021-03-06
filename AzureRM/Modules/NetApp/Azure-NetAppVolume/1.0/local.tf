# Generate the Keyvault ID from userinput/output of Module Azure-KeyVault or generate from resource group and Key vault name
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

data "azurerm_netapp_account" "this" {
  count               = var.account.name == null ? 0 : 1
  resource_group_name = local.resource_group_name
  name                = var.account.name
}

# Local variables for NetApp Account
locals {
  account_name = var.account.name == null ? (
    var.netapp_accounts[var.account.key].name
  ) : data.azurerm_netapp_account.this[0].name
}


data "azurerm_netapp_pool" "this" {
  count               = var.pool.name == null ? 0 : 1
  resource_group_name = local.resource_group_name
  account_name        = local.account_name
  name                = var.pool.name
}

# Local variables for NetApp Pool
locals {
  pool_name = var.pool.name == null ? (
    var.netapp_pools[var.pool.key].name
  ) : data.azurerm_netapp_pool.this[0].name
}


# Local variables for Subnet_id

data "azurerm_subnet" "this" {
  count                = var.subnet.name == null && var.subnet.virtual_network_name == null ? 0 : 1
  name                 = var.subnet.name
  resource_group_name  = coalesce(var.subnet.resource_group_name, local.resource_group_name)
  virtual_network_name = var.subnet.virtual_network_name
}

locals {
  subnet_id = var.subnet.id == null ? (
    var.subnet.name == null ? (
      var.virtual_networks[var.subnet.virtual_network_key].subnet[var.subnet.key].id
    ) : data.azurerm_subnet.this[0].id
  ) : var.subnet.id
}

# Other local variables
locals {
  service_level = var.pool.name == null ? var.netapp_pools[var.pool.key].service_level : data.azurerm_netapp_pool.this[0].service_level
}

# TODO: Add a resource block for remote volume lookup
# Remote volume block cannot use output of Azure-NetappVolume as it will cause a circular loop
# data "azurerm_netapp_volume" "this"{
#   count = var.data_protection_replication == null || var.data_protection_replication == {} ? 0 : (
#     var.data_protection_replication.remote_volume_resource.name == null && var.data_protection_replication.remote_volume_resource.account_name == null && var.data_protection_replication.remote_volume_resource.pool_name == null ? 0 : 1
#   )
#   name                = var.data_protection_replication.remote_volume_resource.name
#   account_name        = var.data_protection_replication.remote_volume_resource.account_name
#   pool_name           = var.data_protection_replication.remote_volume_resource.pool_name
#   resource_group_name = coalesce(var.data_protection_replication.remote_volume_resource.resource_group_name,local.resource_group_name)
# }

data "azurerm_netapp_snapshot_policy" "this" {
  count = var.data_protection_snapshot_policy == null || var.data_protection_snapshot_policy == {} ? 0 : (
  var.data_protection_snapshot_policy.name == null ? 0 : 1)
  resource_group_name = local.resource_group_name
  account_name        = local.account_name
  name                = var.data_protection_snapshot_policy.name
}

# Snapshots must exist in the same capacity pool and account as the new destination volume.
# TODO : test cross account and pool capability
data "azurerm_netapp_snapshot" "this" {
  count               = var.create_from_snapshot_resource == null || var.create_from_snapshot_resource == {} ? 0 : (var.create_from_snapshot_resource.name == null ? 0 : 1)
  resource_group_name = coalesce(var.create_from_snapshot_resource.resource_group_name, local.resource_group_name)
  name                = var.create_from_snapshot_resource.name
  account_name        = coalesce(var.create_from_snapshot_resource.account_name, local.account_name)
  pool_name           = coalesce(var.create_from_snapshot_resource.pool_name, local.pool_name)
  volume_name         = var.create_from_snapshot_resource.volume_name
}

# Local variables for data protection replication block
locals {
  data_protection_replication = var.data_protection_replication == null || var.data_protection_replication == {} ? null : {
    endpoint_type             = coalesce(var.data_protection_replication.endpoint_type, "dst")
    remote_volume_location    = var.data_protection_replication.remote_volume_location
    remote_volume_resource_id = var.data_protection_replication.remote_volume_resource_id
    replication_frequency     = var.data_protection_replication.replication_frequency
  }

  data_protection_snapshot_policy_id = var.data_protection_snapshot_policy == null || var.data_protection_snapshot_policy == {} ? null : (var.data_protection_snapshot_policy.id == null ? (
    var.data_protection_snapshot_policy.name == null ? (
      var.data_protection_snapshot_policy.key == null ? null : var.snapshot_policies[var.data_protection_snapshot_policy.key].id
    ) : data.azurerm_netapp_snapshot_policy.this[0].id
    ) : var.data_protection_snapshot_policy.id
  )
  
  # Block for volume  Snapshot 
  create_from_snapshot_resource_id = var.create_from_snapshot_resource == null || var.create_from_snapshot_resource == {} ? null : (
    var.create_from_snapshot_resource.id == null ? (
      var.create_from_snapshot_resource.name == null ? (
        var.create_from_snapshot_resource.key == null ? null : var.netapp_snapshots[var.create_from_snapshot_resource.key].id
      ) : data.azurerm_netapp_snapshot.this[0].id
    ) : var.create_from_snapshot_resource.id
  )
}