resource "azurerm_private_dns_txt_record" "this" {
  name                = var.name
  zone_name           = var.zone_name
  resource_group_name = local.resource_group_name
  ttl                 = var.ttl

  tags = local.tags

  dynamic "record" {
    for_each = var.record
    content {
      preference = record.preference
      exchange   = record.exchange
    }
  }

}