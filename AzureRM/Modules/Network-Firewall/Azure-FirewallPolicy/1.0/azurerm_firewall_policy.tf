resource "azurerm_firewall_policy" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  # Currently this can only be looked up when either policy ID or a policy name/resource group is excplicitly provided
  # Cannot be looked up using output of module Azure-FirewallPolicy as it would cause a circular link in Terrafrom dependency graph.
  base_policy_id = local.base_policy_id

  # Single block, Optional
  dynamic "dns" {
    for_each = var.dns == null ? [] : [1]
    content {
      proxy_enabled = var.dns.proxy_enabled
      servers       = var.dns.servers
    }
  }
  # Single block, Optional
  dynamic "identity" {
    for_each = local.identity == null ? [] : [1]
    content {
      type         = local.identity.type
      identity_ids = local.identity.identity_ids
    }
  }

  # Single block, Optional
  dynamic "insights" {
    for_each = local.insights == null ? [] : [1]
    content {
      enabled                            = local.insights.enabled
      default_log_analytics_workspace_id = local.insights.default_log_analytics_workspace_id
      retention_in_days                  = local.insights.retention_in_days
      # This is classified as List of blocks, investigate.
      dynamic "log_analytics_workspace" {
        for_each = local.insights.log_analytics_workspace
        content {
          id                = each.value.id
          firewall_location = each.value.firewall_location
        }
      }
    }
  }



  # Single block, Optional
  dynamic "intrusion_detection" {
    for_each = local.intrusion_detection == null ? [] : [1]
    content {
      mode = local.intrusion_detection.mode
      # Multi block
      dynamic "signature_overrides" {
        for_each = local.intrusion_detection.signature_overrides
        content {
          id    = each.value.id
          state = each.value.state
        }
      }
      # Multi block, Mandatory
      dynamic "traffic_bypass" {
        for_each = local.intrusion_detection.traffic_bypass
        content {
          name                  = each.value.name
          protocol              = each.value.protocol
          description           = each.value.description
          destination_addresses = each.value.destination_addresses
          destination_ip_groups = each.value.destination_ip_groups
          destination_ports     = each.value.destination_ports
          source_addresses      = each.value.source_addresses
          source_ip_groups      = each.value.source_ip_groups
        }
      }
    }
  }

  private_ip_ranges = var.private_ip_ranges
  sku               = var.sku

  # Single block, Optional
  dynamic "threat_intelligence_allowlist" {
    for_each = var.threat_intelligence_allowlist == null ? [] : [1]
    content {
      fqdns        = var.threat_intelligence_allowlist.fqdns
      ip_addresses = var.threat_intelligence_allowlist.ip_addresses
    }
  }

  threat_intelligence_mode = var.threat_intelligence_mode == null ? "Alert" : var.threat_intelligence_mode

  # Single block, Optional
  dynamic "tls_certificate" {
    for_each = local.tls_certificate == null ? [] : [1]
    content {
      key_vault_secret_id = local.tls_certificate.key_vault_secret_id
      name                = local.tls_certificate.name
    }
  }

}