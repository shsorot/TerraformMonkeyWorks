resource "azurerm_managed_disk_sas_token" "this"{
  managed_disk_id = local.managed_disk_id
  duration_in_seconds = var.duration_in_seconds
  access_level = var.access_level
}