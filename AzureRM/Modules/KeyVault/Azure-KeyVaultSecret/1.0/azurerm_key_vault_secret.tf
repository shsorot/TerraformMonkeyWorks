resource "azurerm_key_vault_secret" "this" {
  name            = var.name
  value           = var.value
  key_vault_id    = local.key_vault_id
  content_type    = var.content_type
  tags            = var.tags
  not_before_date = var.not_before_date
  expiration_date = var.expiration_date
}