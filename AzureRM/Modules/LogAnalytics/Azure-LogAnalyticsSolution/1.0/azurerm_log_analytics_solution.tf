resource "azurerm_log_analytics_solution" "this" {
  solution_name         = var.solution_name
  resource_group_name   = local.resource_group_name
  location              = local.location
  workspace_resource_id = local.workspace_resource_id
  workspace_name        = var.workspace_name
  plan {
    publisher      = var.plan.publisher
    product        = var.plan.product
    promotion_code = var.plan.promotion_code
  }
  tags = local.tags
}