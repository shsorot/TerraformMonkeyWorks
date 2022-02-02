resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  tags                = local.tags
  # single block
  dynamic "soa_record" {
    for_each = var.soa_record == null || var.soa_record == {} ? [] : [1]
    content {
      email        = var.soa_record.email
      expire_time  = var.soa_record.expire_time == null ? 2419200 : var.soa_record.expire_time
      minimum_ttl  = var.soa_record.minimum_ttl == null ? 10 : var.soa_record.minimum_ttl
      refresh_time = var.soa_record.refresh_time == null ? 3600 : var.soa_record.refresh_time
      retry_time   = var.soa_record.retry_time == null ? 300 : var.soa_record.retry_time
      ttl          = var.soa_record.ttl == null ? 3600 : var.soa_record.ttl
      tags         = var.soa_record.tags
    }
  }
}