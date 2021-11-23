
resource "azurerm_dedicated_host" "this" {
  name                    = var.name
  location                = var.location
  dedicated_host_group_id = local.dedicated_host_group_id
  sku_name                = var.sku_name
  platform_fault_domain   = var.platform_fault_domain
  auto_replace_on_failure = var.auto_replace_on_failure
  license_type            = var.license_type
  tags                    = var.tags
}