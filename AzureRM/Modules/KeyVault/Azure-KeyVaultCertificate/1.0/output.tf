output "id" {
  value = azurerm_key_vault_certificate.this.id
  description = "The ID of the certificate"
}

output "secret_id" {
  value = azurerm_key_vault_certificate.this.secret_id
  description = "The secret URL of the key vault certificate"
  sensitive = true
}

output "version" {
  value = azurerm_key_vault_certificate.this.version
  description = "The version of the certificate"
}

output "thumbprint" {
  value = azurerm_key_vault_certificate.this.thumbprint
  description = "Value of the certificate thumbprint"
  sensitive = true
}


output "certificate_attribute" {
  value = azurerm_key_vault_certificate.this.certificate_attribute
  description = "Certificate attributes & properties"
}
