resource "azurerm_management_lock" "this" {
  name       = var.name
  scope      = local.scope
  lock_level = var.lock_level
  notes      = var.notes
}