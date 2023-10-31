resource "azurerm_storage_share" "this" {
  name                 = var.name
  storage_account_name = local.storage_account_name
  access_tier          = var.access_tier
  dynamic "acl" {
    for_each = { for idx,instance in (var.acl == null || var.acl == [] ? [] : var.acl) : idx => instance if ( instance == null || instance == {} ? false : true )  }
    content {
      id = each.key
      access_policy {
        permissions = acl.value.access_policy.permissions
        start       = acl.value.access.start
        expiry      = acl.value.access.expiry
      }
    }
  }
  enabled_protocol = var.enabled_protocol
  quota    = var.quota
  metadata = var.metadata
}