variable "AutomationAccounts" {
  default = {}
}

module "Landscape-Automation-Accounts" {
  source                   = "../../../AzureRM/Modules/Automation/Azure-AutomationAccount/1.0"
  for_each                 = var.AutomationAccounts
  name                     = each.value.name == null ? each.key : each.value.name

  location                 = try(each.value.location, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled,null)
  resource_group           = each.value.resource_group
  sku_name                 = try(each.value.sku_name, null)
  identity                 = try(each.value.identity, null)
  tags                     = try(each.value.tags, local.tags)
  inherit_tags             = try(each.value.inherit_tags, false)
  resource_groups          = module.Landscape-Resource-Groups
  user_assigned_identities = module.Landscape-User-Assigned-Identities
}


output "AutomationAccounts" {
  value     = module.Landscape-Automation-Accounts
  sensitive = true
}


variable "AutomationAccountCertificates" {
  default = {}
}


module "Landscape-Automation-Account-Certificates" {
  source              = "../../../AzureRM/Modules/Automation/Azure-AutomationCertificate/1.0"
  for_each            = var.AutomationAccountCertificates
  name                = each.value.name == null ? each.key : each.value.name

  automation_account  = each.value.automation_account
  base64              = each.value.Base64
  description         = try(each.value.description, null)
  exportable          = try(each.value.exportable, false)
  automation_accounts = module.Landscape-Automation-Accounts
}

output "AutomationAccountCertificates" {
  value = module.Landscape-Automation-Account-Certificates
}