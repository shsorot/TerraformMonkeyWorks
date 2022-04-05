resource "azurerm_managed_disk" "this" {
  name                   = var.name
  location               = local.location
  resource_group_name    = local.resource_group_name
  tags                   = local.tags
  zone                   = var.zone
  storage_account_type   = var.storage_account_type
  create_option          = var.create_option
  disk_encryption_set_id = local.disk_encryption_set_id

  #For ultra SSD only
  disk_iops_read_write = var.disk_iops_read_write
  disk_mbps_read_write = var.disk_mbps_read_write
  disk_size_gb         = var.disk_size_gb

  dynamic "encryption_settings" {
    for_each = var.disk_encryption_key == null || var.key_encryption_key == null ? [] : [1]
    content {
      enabled = true
      dynamic "disk_encryption_key" {
        for_each = var.disk_encryption_key == null ? [] : [1]
        content {
          secret_url      = var.disk_encryption_key.secret_url
          source_vault_id = var.disk_encryption_key.source_vault_id
        }
      }
      dynamic "key_encryption_key" {
        for_each = var.key_encryption_key == null ? [] : [1]
        content {
          key_url         = var.key_encryption_key.key_url
          source_vault_id = var.key_encryption_key.source_vault_id
        }
      }
    }
  }

  image_reference_id = var.create_option == "FromImage" ? var.image_reference_id : null
  os_type            = var.create_option == "Import" || var.create_option == "Copy" ? var.os_type : null
  source_resource_id = var.create_option == "Copy" || var.create_option == "Restore" ? var.source_resource_id : null
  source_uri         = var.create_option == "Import" ? var.source_uri : null
  storage_account_id = var.create_option == "Import" ? var.storage_account_id : null
  tier               = var.tier

  network_access_policy = var.network_access_policy
  disk_access_id        = var.network_access_policy == "AllowPrivate" ? var.disk_access_id : null


}