resource "azurerm_route_filter" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  dynamic "rule" {
    for_each = var.rule == null ? [] : [1]
    content {
      access      = var.rule.access
      communities = var.rule.communities
      name        = var.rule.name
      rule_type   = var.rule.rule_type
    }
  }

}