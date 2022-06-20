output "id" {
  value       = azurerm_automation_certificate.this.id
  description = "The Automation Certificate ID."
}

output "thumbprint" {
  value       = azurerm_automation_certificate.this.thumbprint
  description = "The thumbprint for the certificate."
}