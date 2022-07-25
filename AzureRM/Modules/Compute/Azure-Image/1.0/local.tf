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

data "azurerm_virtual_machine" "this" {
  count               = var.source_virtual_machine == null || var.source_virtual_machine == {} ? null : (var.source_virtual_machine.name == null ? null : 1)
  name                = var.source_virtual_machine.name
  resource_group_name = coalesce(var.source_virtual_machine.resource_group_name, local.resource_group_name)
}

data "azurerm_managed_disk" "osdisk" {
  count               = var.os_disk == null || var.os_disk == {} ? 0 : (var.os_disk.managed_disk == null ? 0 : (var.os_disk.managed_disk.name == null ? 0 : 1))
  name                = var.os_disk.managed_disk.name
  resource_group_name = coalesce(var.os_disk.managed_disk.resource_group_name, local.resource_group_name)
}


data "azurerm_managed_disk" "datadisks" {
  for_each            = var.data_disk == null || var.data_disk == {} ? {} : { for idx, instance in var.data_disk : idx => instance if ((instance.managed_disk != null || instance.managed_disk != {}) && instance.managed_disk.name != null) }
  name                = each.value.managed_disk.name
  resource_group_name = coalesce(each.value.managed_disk.resource_group_name, local.resource_group_name)
}

# Data block used by os_disk storage blob uri
data "azurerm_storage_blob" "osdisk" {
  count     = var.os_disk.blob == null || var.os_disk.blob == {} ? 0 : ( var.os_disk.blob.name == null && var.os_disk.blob.storage_container_name == null && var.os_disk.blob.storage_account_name == null ? 0 : 1 )
  name = var.os_disk.blob.name
  storage_account_name = var.os_disk.blob.storage_account_name
  storage_container_name = var.os_disk.blob.storage_container_name
}


# Data block used by data_disk storage blob uri
data "azurerm_storage_blob" "datadisk" {
  for_each                = { for instance in var.data_disk : concat(instance.blob.name,"-",instance.blob.storage_account_name) => instance.blob if ( instance.blob == null || instance.blob == {} ? false : (instance.blob.name == null && instance.blob.storage_account_name == null && instance.blob.storage_container_name == null ? false : true)) }
  name                    = each.value.name
  storage_account_name    = each.value.storage_account_name
  storage_container_name  = each.value.blob.storage_container_name
}


locals {
  # No key or module output based lookup due to circular dependency. VM must pre-exist before this module is called.
  source_virtual_machine_id = var.source_virtual_machine == null || var.source_virtual_machine == {} ? null : (
    var.source_virtual_machine.id == null ? data.azurerm_virtual_machine.this[0].id : var.source_virtual_machine.id
  )

  # TODO : Add a common data block for managed disks for fetching OSDisk and DataDisks.
  os_disk = var.os_disk == null || var.os_disk == {} ? null : {
    os_type  = var.os_disk.os_type
    os_state = var.os_disk.os_state
    # only id or data based lookup is supported here.
    managed_disk_id = var.os_disk.managed_disk == null ? null : (
      var.os_disk.managed_disk.id == null ? (
        data.azurerm_managed_disk.osdisk[0].id
      ) : var.os_disk.managed_disk.id
    )
    blob_uri = var.os_disk.blob == null || var.os_disk.blob == {} ? null : (
      var.os_disk.blob.uri == null ? (
       data.azurerm_storage_blob.osdisk[0].url
      ) : var.os_disk.blob.uri
    )
    caching  = var.os_disk.caching
    size_gb  = var.os_disk.size_gb
  }

  # TODO : add data lookup for blob_uri property
  data_disk = var.data_disk == null || var.data_disk == [] ? null : [
    for idx, instance in var.data_disk : {
      lun      = instance.lun
      managed_disk_id = instance.managed_disk == null || instance.managed_disk == {} ? null : (
        instance.managed_disk.id == null ? (
          data.azurerm_managed_disk.datadisks[idx].id
        ) : instance.managed_disk.id
      )
      blob_uri = instance.blob_uri
      caching  = instance.caching
      size_gb  = instance.size_gb
    }
  ]
}