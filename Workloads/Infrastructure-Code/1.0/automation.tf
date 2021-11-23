variable "AutomationAccounts" {
  default = {}
}

module "Landscape-Automation-Accounts" {
  source          = "../../../AzureRM/Modules/Automation/Azure-AutomationAccount/1.0"
  for_each        = var.AutomationAccounts
  name            = each.value.name == null ? each.key : each.value.name
  location        = try(each.value.location, null)
  resource_group  = each.value.resource_group
  sku_name        = try(each.value.sku_name, null)
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}


output "AutomationAccounts" {
  value = module.Landscape-Automation-Accounts
}