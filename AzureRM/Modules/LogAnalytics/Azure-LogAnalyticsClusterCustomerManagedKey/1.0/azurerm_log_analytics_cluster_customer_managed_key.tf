resource "azurerm_log_analytics_cluster_customer_managed_key" "this" {
  key_vault_key_id         = local.key_vault_key_id
  log_analytics_cluster_id = local.log_analytics_cluster_id
}

