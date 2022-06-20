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

data "azurerm_disk_encryption_set" "this" {
  count               = var.disk_encryption_set == null ? 0 : (var.disk_encryption_set.name == null ? 0 : 1)
  name                = var.disk_encryption_set.name
  resource_group_name = coalesce(var.disk_encryption_set.resource_group_name, local.resource_group_name)
}

# data "azurerm_shared_image" "this"{

# }

# data "azurerm_storage_account" "this"{

# }

locals {
  disk_encryption_set_id = var.disk_encryption_set == null ? null : (
    var.disk_encryption_set.id == null ? (
      var.disk_encryption_set.name == null ? (
        var.disk_encryption_sets[var.disk_encryption_set.key].id
      ) : data.azurerm_disk_encryption_set.this[0].id
    ) : var.disk_encryption_set.id
  )
  # TODO : Data and tag based lookup
  storage_account_id         = var.storage_account_id
  gallery_image_reference_id = var.gallery_image_reference_id
}