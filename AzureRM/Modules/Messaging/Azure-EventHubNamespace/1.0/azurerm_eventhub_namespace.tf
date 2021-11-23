resource "azurerm_eventhub_namespace" "this" {
  name                 = var.name
  resource_group_name  = local.resource_group_name
  location             = local.location
  tags                 = local.tags
  sku                  = var.sku
  capacity             = var.capacity
  auto_inflate_enabled = var.auto_inflate_enabled
  dedicated_cluster_id = var.dedicated_cluster == null ? null : (
    var.dedicated_cluster.id == null ? (
      var.dedicated_cluster.name == null ? (
        var.dedicated_clusters[var.dedicated_cluster.tag].id
      ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.dedicated_cluster.resource_group_name == null ? local.resource_group_name : var.dedicated_cluster.resource_group_name}/providers/Microsoft.EventHub/clusters/${var.dedicated_cluster.name}"
    ) : var.dedicated_cluster.id
  )
  dynamic "identity" {
    for_each = var.identity == null || var.identity == {} ? [] : [1]
    content {
      type = var.identity.type
    }
  }
  maximum_throughput_units = var.maximum_throughput_units
  zone_redundant           = var.zone_redundant
  dynamic "network_rulesets" {
    for_each = var.network_rulesets == null || var.network_rulesets == {} ? [] : [1]
    content {
      default_action                 = var.network_rulesets.default_action
      trusted_service_access_enabled = var.network_rulesets.trusted_service_access_enabled
      dynamic "virtual_network_rule" {
        for_each = var.network_rulesets.virtual_network_rule == null ? [] : var.network_rulesets.virtual_network_rule
        content {
          subnet_id = virtual_network_rule.subnet.id == null ? (
            virtual_network_rule.subnet.name == null && virtual_network_rule.subnet.virtual_network_name == null ? (
              var.virtual_networks[virtual_network_rule.subnet.tag].subnets[virtual_network_rule.subnet.virtual_network_tag].id
            ) : "/subscriptions/${local.subscription_id}/resourceGroups/${virtual_network_rule.subnet.resource_group_name == null ? local.resource_group_name : virtual_network_rule.subnet.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${virtual_network_rule.subnet.virtual_network_name}/subnets/${virtual_network_rule.subnet.name}"
          ) : virtual_network_rule.subnet.id
        }
      }
      dynamic "ip_rule" {
        for_each = var.network_rulesets.ip_rule == null ? [] : var.network_rulesets.ip_rule
        content {
          ip_mask = ip_rule.ip_mask
          action  = ip_rule.ip_mask
        }
      }
    }
  }

}