resource "azurerm_container_group" "this" {
  name = var.name
  location = local.location
  resource_group_name = local.resource_group_name
  os_type = var.os_type

  # If os_type == Windows, only the first block is accepted.
  dynamic "container" {
    for_each = var.os_type == "Windows" && var.container != null ? var.container[0] : var.container
    content {
    }
  }
  # Single block
  dynamic "identity" {
  
  }

  # Single Block
  dynamic "dns_config" {
  
  }

  # Single block
  dynamic "diagnostics"{
  
  }

  dns_name_label = var.dns_name_label

  # Single block
  dynamic "exposed_port" {
  
  }
}