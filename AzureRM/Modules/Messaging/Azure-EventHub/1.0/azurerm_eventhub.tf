# TODO : Add data block based lookup
resource "azurerm_eventhub" "this" {
  name                = var.name
  namespace_name      = var.name
  resource_group_name = local.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
  status              = var.status

  dynamic "capture_description" {
    for_each = var.capture_description == null || var.capture_description == {} ? [] : [1]
    content {
      enabled             = var.capture_description.enabled
      encoding            = var.capture_description.encoding
      interval_in_seconds = var.capture_description.interval_in_seconds
      size_limit_in_bytes = var.capture_description.size_limit_in_bytes
      skip_empty_archives = var.capture_description.skip_empty_archives

      destination {
        name                = var.capture_description.dynamic.name
        archive_name_format = var.capture_description.dynamic.archive_name_format
        blob_container_name = var.capture_description.dynamic.blob_container_name
        storage_account_id = var.capture_description.dynamic.storage_account.id == null ? (
          var.capture_description.dynamic.storage_account.name == null ? (
            var.storage_accounts[var.capture_description.dynamic.storage_account.key].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.capture_description.dynamic.storage_account.resource_group_name == null ? local.resource_group_name : var.capture_description.dynamic.storage_account.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.capture_description.dynamic.storage_account.name}"
        ) : var.capture_description.dynamic.storage_account.id
      }
    }
  }
}
