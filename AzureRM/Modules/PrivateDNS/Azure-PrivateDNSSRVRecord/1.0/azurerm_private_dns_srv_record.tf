resource "azurerm_private_dns_srv_record" "this" {
  name                = var.name
  zone_name           = var.zone_name
  resource_group_name = local.resource_group_name
  ttl                 = var.ttl

  tags = local.tags

  dynamic "record" {
    for_each = var.record
    content {
      priority = record.priority
      weight   = record.weight
      port     = record.port
      target   = record.target
    }
  }

}