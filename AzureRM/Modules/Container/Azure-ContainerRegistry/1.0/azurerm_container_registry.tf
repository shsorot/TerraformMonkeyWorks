resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  # Single Block
  # Only if SKU is premium
  # Cannot contain locations where container registry exists
  dynamic "georeplications" {
    for_each = var.georeplications != null && var.sku == "Premium" ? [1] : []
    content {
      location                  = var.georeplications.locations
      regional_endpoint_enabled = var.georeplications.regional_endpoint_enabled
      zone_redundancy_enabled   = var.georeplications.zone_redundancy_enabled
      tags                      = var.georeplications.tag
    }
  }

  # Single Block
  # network_rule_set is only supported with the Premium SKU at this time.
  # Azure automatically configures Network Rules - to remove these you'll need to specify an network_rule_set block with default_action set to Deny.
  dynamic "network_rule_set" {
    for_each = var.network_rule_set != null && var.sku == "Premium" ? [1] : []
    content {
      default_action = var.network_rule_set.default_action
      # Single block
      dynamic "ip_rule" {
        for_each = var.network_rule_set.ip_rule != null || var.network_rule_set.ip_rule != {} ? [1] : []
        content {
          action   = var.network_rule_set.ip_rule.action
          ip_range = var.network_rule_set.ip_rule.ip_range
        }
      }
      # Multiple blocks
      # TODO : convert network_rule_set-->virtual_network-->subnet_id to lookup based model.
      dynamic "virtual_network" {
        for_each = var.network_rule_set.virtual_network != null ? var.network_rule_set.virtual_network : {}
        content {
          action    = virtual_network.value.action
          subnet_id = virtual_network.value.subnet_id
        }
      }
    }
  }
  public_network_access_enabled = var.public_network_access_enabled

  # only supported on premium SKU
  quarantine_policy_enabled = var.quarantine_policy_enabled

  # Single block
  # only supported on premium SKU
  # TODO : for some reason, terraform complains about this block not applicable here , against what is specified in documentation
  # Provider 3.70.0
  # dynamic "retention_policy "{
  #   for_each =  (var.retention_policy != null || var.retention_policy != {}) && (var.sku == "Premium") ? [1] : []
  #   content {
  #     days = var.retention_policy.days
  #     enabled =  var.retention_policy.days
  #   }
  # }

  # Single block
  # only supported on premium SKU
  dynamic "trust_policy" {
    for_each = var.trust_policy != null || var.trust_policy != {} ? [1] : []
    content {
      enabled = var.trust_policy.enabled
    }
  }
  # only supported on premium SKU
  zone_redundancy_enabled = var.zone_redundancy_enabled

  # In order to set it to false, make sure the public_network_access_enabled is also set to false.
  # only supported on premium SKU
  export_policy_enabled = var.public_network_access_enabled == true ? true : var.export_policy_enabled

  # Single block
  # TODO : add code for data and tag based identity id lookup
  dynamic "identity" {
    for_each = var.identity != null || var.identity != {} ? [1] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }
  #Single block
  # Todo : add code for data and tag based key vault key id lookup
  dynamic "encryption" {
    for_each = var.encryption != null || var.encryption != {} ? [1] : []
    content {
      enabled            = var.encryption.enabled
      key_vault_key_id   = var.encryption.key_vault_key_id
      identity_client_id = var.encryption.identity_client_id
    }
  }
  anonymous_pull_enabled     = var.anonymous_pull_enabled
  data_endpoint_enabled      = var.data_endpoint_enabled
  network_rule_bypass_option = var.network_rule_bypass_option

}
