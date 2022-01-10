resource "azurerm_management_lock" "this" {
  count = var.lock_level != null ? 1 : 0

  name       = var.management_lock_name == null ? "${var.lock_level}-RG-Lock" : var.management_lock_name
  scope      = azurerm_resource_group.this.id
  lock_level = var.lock_level
  notes      = try(var.notes, "This resource group is locked with property ${var.lock_level}")

  depends_on = [azurerm_resource_group.this]
}



