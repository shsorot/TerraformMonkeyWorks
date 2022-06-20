resource "azurerm_netapp_volume" "this" {
  name                             = var.name
  resource_group_name              = local.resource_group_name
  location                         = local.location
  tags                             = local.tags
  account_name                     = local.account_name
  volume_path                      = var.volume_path
  pool_name                        = local.pool_name
  service_level                    = local.service_level # Inherited from Pool properties. Do not specify from parameters.
  protocols                        = var.protocols == null || var.protocols == [] ? ["NFSv3"] : var.protocols
  security_style                   = var.security_style
  subnet_id                        = local.subnet_id # Mandatory, if changed, forces re-creation of resource
  storage_quota_in_gb              = var.storage_quota_in_gb
  snapshot_directory_visible       = var.snapshot_directory_visible
  create_from_snapshot_resource_id = local.create_from_snapshot_resource_id

  # # Single Block
  # Note: currently only paired region replication within same subscription is supported.
  # Both source and target can exist in the same resource group.
  # dynamic "data_protection_replication" {
  #   for_each = local.data_protection_replication == null || local.data_protection_replication == {} ? [] : [1]
  #   content {
  #     endpoint_type             = local.data_protection_replication.endpoint_type
  #     remote_volume_location    = local.data_protection_replication.remote_volume_location
  #     remote_volume_resource_id = local.data_protection_replication.remote_volume_resource_id
  #     replication_frequency     = local.data_protection_replication.replication_frequency
  #   }
  # }

  # Single Block
  # TODO : fix issue post Hashicorp update to provider
  dynamic "data_protection_snapshot_policy" {
    for_each = local.data_protection_snapshot_policy_id == null ? [] : [1]
    content {
      snapshot_policy_id = local.data_protection_snapshot_policy_id
    }
  }

  # Multiple Blocks
  dynamic "export_policy_rule" {
    for_each = { for instance in var.export_policy_rule : instance.rule_index => instance }
    content {
      rule_index          = export_policy_rule.key
      allowed_clients     = export_policy_rule.value.allowed_clients
      protocols_enabled   = coalesce(export_policy_rule.value.protocols_enabled, var.protocols)
      unix_read_only      = try(export_policy_rule.value.unix_read_only, null)
      unix_read_write     = try(export_policy_rule.value.unix_read_write, null)
      root_access_enabled = try(export_policy_rule.value.root_access_enabled)
    }
  }

  throughput_in_mibps = var.throughput_in_mibps
}