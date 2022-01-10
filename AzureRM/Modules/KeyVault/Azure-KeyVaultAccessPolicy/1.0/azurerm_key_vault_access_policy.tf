resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id            = local.key_vault_id
  tenant_id               = var.tenant_id
  object_id               = var.object_id
  application_id          = var.application_id
  certificate_permissions = var.certificate_permissions
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  storage_permissions     = var.storage_permissions
}