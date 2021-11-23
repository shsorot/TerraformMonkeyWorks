resource "azurerm_storage_share" "this" {
  name                 = var.name
  storage_account_name = var.storage_account_name

  dynamic "acl" {
    for_each = var.acl == null || var.acl == {} ? {} : var.acl
    content {
      id = each.key
      access_policy {
        permissions = acl.value.access_policy.permissions
        start       = acl.value.access.start
        expiry      = acl.value.access.expiry
      }
    }
  }


  quota    = var.quota
  metadata = var.metadata
}