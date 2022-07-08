resource "azurerm_private_endpoint" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  subnet_id           = local.subnet_id

  # Single block, Optional
  dynamic "private_dns_zone_group" {
    for_each = local.private_dns_zone_group == null ? [] : [1]
    content {
      name                 = local.private_dns_zone_group.name
      private_dns_zone_ids = local.private_dns_zone_group.private_dns_zone_ids
    }
  }

  # Single block, Mandatory
  # TODO : change from dynamic to static based on mandatory property
  dynamic "private_service_connection" {
    for_each = local.private_service_connection == null ? [] : [1]
    content {
      name                              = local.private_service_connection.name
      is_manual_connection              = local.private_service_connection.is_manual_connection
      private_connection_resource_id    = local.private_service_connection.private_connection_resource_id
      private_connection_resource_alias = local.private_service_connection.private_connection_resource_alias
      subresource_names                 = local.private_service_connection.subresource_names
      request_message                   = local.private_service_connection.request_message
    }
  }
  tags = local.tags
}