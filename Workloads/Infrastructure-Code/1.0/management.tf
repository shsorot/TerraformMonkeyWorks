variable "ManagementGroups" {
  default = {}
}


module "Landscape-Management-Groups" {
  source   = "../../../AzureRM/Modules/Management/Azure-ManagementGroup/1.0"
  for_each = var.ManagementGroups
  name     = each.value.name == null ? each.key : each.value.name

  # Deprecated from provider > 3.0.0
  # group_id                = try(each.value.group_id, null)
  display_name            = try(each.value.display_name, null)
  parent_management_group = try(each.value.parent_management_group, null)
  subscription_ids        = try(each.value.subscription_ids, null)
}


output "ManagementGroups" {
  value = module.Landscape-Management-Groups
}