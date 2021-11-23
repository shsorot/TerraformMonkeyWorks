output "id" {
  value = azurerm_key_vault_certificate.this.id
}

output "secret_id" {
  value = azurerm_key_vault_certificate.this.secret_id
}

output "version" {
  value = azurerm_key_vault_certificate.this.version
}

output "thumbprint" {
  value = azurerm_key_vault_certificate.this.thumbprint
}


output "certificate_attribute" {
  value = azurerm_key_vault_certificate.this.certificate_attribute
}
