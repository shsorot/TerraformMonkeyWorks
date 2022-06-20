output "id"{
  value = azurerm_managed_disk_sas_token.this.id
  description = "The ID of the Disk Export resource."
}

output "sas_url"{
  value = azurerm_managed_disk_sas_token.this.sas_url
  description = "The computed Shared Access Signature (SAS) of the Managed Disk."
}