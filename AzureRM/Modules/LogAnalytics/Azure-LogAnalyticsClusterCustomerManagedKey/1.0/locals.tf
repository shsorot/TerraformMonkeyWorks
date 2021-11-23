# Generate the Keyvault ID from userinput/output of Module Azure-KeyVault or generate from resource group and Key vault name
# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


data "azurerm_client_config" "current" {
}

#Create the local variables
locals {
  client_id       = data.azurerm_client_config.current.client_id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azurerm_client_config.current.object_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}
locals {
  key_vault_key_id = var.key_vault_key.id == null ? (
    var.key_vault_key.key_identifier == null && var.key_vault_key.key_vault_name ? (
      var.key_vault_keys[var.key_vault_key.tag].id
    ) : "https://${var.key_vault_key.key_vault_name}.vault.azure.net/keys/${var.key_vault_key.key_identifer}"
  ) : var.key_vault_key.id
  log_analytics_cluster_id = var.log_analytics_cluster.id == null ? (
    var.log_analytics_cluster.name == null && var.log_analytics_cluster.resource_group_name == null ? (
      var.log_analytics_clusters[var.log_analytics_cluster.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourcegroups/${var.log_analytics_cluster.resource_group_name}/providers/Microsoft.OperationalInsights/clusters/${var.log_analytics_cluster.name}"
  ) : var.log_analytics_cluster.id
}

