resource "azurerm_image" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  # when specifying virtual machine ID, do not use OS and Data disk blocks.
  source_virtual_machine_id = local.source_virtual_machine_id

  # Multiple Blocks, Optional
  # To be only used when source_virtual_machine_id is not specified
  dynamic "os_disk" {
    for_each = var.os_disk == null || var.os_disk == {} ? {} : { for idx, instance in var.os_disk : idx => instance }
    content {
      os_type  = os_disk.os_type
      os_state = os_disk.os_state
      # Cannot add tag based lookup here. Only pre-existing os managed disks can be referenced here. 
      # This is meant to allow creation of VM from an OS disk that is left behind.
      managed_disk_id = os_disk.managed_disk_id
      blob_uri        = os_disk.blob_uri
      caching         = os_disk.caching
      size_gb         = os_disk.size_gb
    }
  }

  # Multiple Blocks, Optional
  # To be only used when source_virtual_machine_id is not specified
  dynamic "data_disk" {
    for_each = var.data_disk == null || var.data_disk == {} ? {} : { for idx, instance in var.data_disk : idx => instance }
    content {
      lun             = data_disk.lun
      managed_disk_id = data_disk.managed_disk_id
      blob_uri        = data_disk.blob_uri
      caching         = data_disk.caching
      size_gb         = data_disk.size_gb
    }
  }

  zone_resilient     = var.zone_resilient
  hyper_v_generation = var.hyper_v_generation
}