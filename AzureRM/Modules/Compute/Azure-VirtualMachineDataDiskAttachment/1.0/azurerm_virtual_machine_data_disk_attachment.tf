resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  virtual_machine_id        = local.virtual_machine_id
  managed_disk_id           = local.managed_disk_id
  lun                       = var.lun
  caching                   = var.caching
  create_option             = var.create_option
  write_accelerator_enabled = var.caching != "None" || var.caching != null ? false : var.write_accelerator_enabled
}