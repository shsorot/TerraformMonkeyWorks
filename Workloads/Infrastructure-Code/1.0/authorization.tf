variable "UserAssignedIdentities" {
  default = {}
}


module "Landscape-User-Assigned-Identities" {
  source          = "../../../AzureRM/Modules/Authorization/Azure-UserAssignedIdentity/1.0"
  for_each        = var.UserAssignedIdentities
  name            = each.value.name == null ? each.key : each.value.name

  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, {})
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}


output "UserAssignedIdentities" {
  value = module.Landscape-User-Assigned-Identities
}


variable "RoleDefinitions" {
  default = {}
}


module "Landscape-Role-Definitions" {
  source             = "../../../AzureRM/Modules/Authorization/Azure-RoleDefinition/1.0"
  for_each           = var.RoleDefinitions
  role_definition_id = try(each.value.role_definition_name, null)
  name               = each.value.name == null ? each.key : each.value.name

  scope              = each.value.scope
  description        = try(each.value.description, null)
  permissions        = try(each.value.permissions, null)
  assignable_scopes  = try(each.value.assignable_scopes, [])
}

output "RoleDefinitions" {
  value = module.Landscape-Role-Definitions
}