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

  # Added in provider > 3.xx.x
  disk_iops_read_only = var.disk_iops_read_only
  # Added in provider > 3.xx.x
  disk_mbps_read_only = var.disk_mbps_read_only
  disk_size_gb        = var.disk_size_gb
  # added in provider > 3.xx.x
  edge_zone = var.edge_zone

  # TODO : add data block lookup for secret url, source_vault_id and key_url
  # Single Block, Optional
  dynamic "encryption_settings" {
    for_each = var.encryption_settings == null || var.encryption_settings == null ? [] : [1]
    content {
      enabled = true
      # Single Block, Optional
      dynamic "disk_encryption_key" {
        for_each = var.encryption_settings.disk_encryption_key == null ? [] : [1]
        content {
          secret_url      = var.encryption_settings.disk_encryption_key.secret_url
          source_vault_id = var.encryption_settings.disk_encryption_key.source_vault_id
        }
      }
      # Single Block, Optional
      dynamic "key_encryption_key" {
        for_each = var.encryption_settings.key_encryption_key == null ? [] : [1]
        content {
          key_url         = var.encryption_settings.key_encryption_key.key_url
          source_vault_id = var.encryption_settings.key_encryption_key.source_vault_id
        }
      }
    }
  }

  # added in provider > 3.xx.x
  hyper_v_generation = var.hyper_v_generation

  image_reference_id = var.create_option == "FromImage" ? var.image_reference_id : null
  # added in provider > 3.xx.x
  # TODO: add data block lookup for gallery_image_reference_id
  gallery_image_reference_id = local.gallery_image_reference_id
  # added in provider > 3.xx.x
  # only supported for UltraSSD_LRS disks.
  logical_sector_size = var.storage_account_type == "UltraSSD_LRS" ? var.logical_sector_size : null

  os_type            = var.create_option == "Import" || var.create_option == "Copy" ? var.os_type : null
  source_resource_id = var.create_option == "Copy" || var.create_option == "Restore" ? var.source_resource_id : null
  source_uri         = var.create_option == "Import" ? var.source_uri : null
  # TODO : data lookup for storage account id
  storage_account_id = var.create_option == "Import" ? local.storage_account_id : null
  tier               = var.tier

  # added in provider > 3.xx.x
  # only applicable for PSSD & USSD
  max_shares = var.max_shares
  # added in provider > 3.xx.x
  # only supported when create_option is from_image or import.
  trusted_launch_enabled = var.trusted_launch_enabled
  # added in provider > 3.xx.x
  on_demand_bursting_enabled = var.on_demand_bursting_enabled

  network_access_policy = var.network_access_policy
  # TODO : data lookup for disk_access_id
  disk_access_id = var.network_access_policy == "AllowPrivate" ? var.disk_access_id : null

  # added in provider > 3.xx.x
  public_network_access_enabled = var.public_network_access_enabled
}