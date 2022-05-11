variable "PolicyDefinitions" {
  default = {}
}

module "Landscape-Policy-Definitions" {
  source            = "../../../AzureRM/Modules/Policy/Azure-PolicyDefinition/1.0"
  for_each          = var.PolicyDefinitions
  name              = each.key
  policy_type       = each.value.policy_type
  mode              = each.value.mode
  display_name      = each.value.display_name
  description       = each.value.description
  management_group  = try(each.value.management_group, null)
  policy_rule       = try(each.value.policy_rule, null)
  metadata          = try(each.value.metadata, null)
  parameters        = try(each.value.parameters, null)
  management_groups = module.Landscape-Management-Groups
}

output "PolicyDefinitions" {
  value = module.Landscape-Policy-Definitions
}

variable "PolicySetDefinitions" {
  default = {}
}

module "Landscape-Policy-Set-Definitions" {
  source                      = "../../../AzureRM/Modules/Policy/Azure-PolicySetDefinition/1.0"
  for_each                    = var.PolicySetDefinitions
  name                        = each.key
  policy_type                 = each.value.policy_type
  display_name                = each.value.display_name
  description                 = each.value.description
  parameters                  = try(each.value.parameters, null)
  management_group_name       = try(each.value.management_group_name, null)
  policy_definition_reference = try(each.value.policy_definition_reference, [])
  policy_definition_group     = try(each.value.policy_definition_group, [])
  policy_definitions          = module.Landscape-Policy-Definitions
}

output "PolicySetDefinitions" {
  value = module.Landscape-Policy-Set-Definitions
}

variable "ManagementGroupPolicyAssignments" {
  default = {}
}

module "Landscape-Management-Group-Policy-Assignment" {
  source                 = "../../../AzureRM/Modules/Policy/Azure-ManagementGroupPolicyAssignment/1.0"
  for_each               = var.ManagementGroupPolicyAssignments
  name                   = each.key
  display_name           = each.value.display_name
  location               = each.value.location
  enforce                = try(each.value.enforce, false)
  description            = try(each.value.description, null)
  management_group       = each.value.management_group
  policy_definition      = try(each.value.policy_definition, null)
  policy_definition_set  = try(each.value.policy_definition_set, null)
  identity               = try(each.value.identity, null)
  metadata               = try(each.value.metadata, null)
  not_scopes             = try(each.value.not_scopes, null)
  parameters             = try(each.value.parameters, null)
  policy_definitions     = module.Landscape-Policy-Definitions
  policy_definition_sets = module.Landscape-Policy-Set-Definitions
  management_groups      = module.Landscape-Management-Groups
}

output "ManagementGroupPolicyAssignments" {
  value = module.Landscape-Management-Group-Policy-Assignment
}

# Deprecated in provider > 3.00.0

# variable "PolicyRemediations" {
#   default = {}
# }


# module "Landscape-Policy-Remediations" {
#   source                      = "../../../AzureRM/Modules/Policy/Azure-PolicyRemediation/1.0"
#   for_each                    = var.PolicyRemediations
#   name                        = each.key
#   scope                       = each.value.scope
#   policy_assignment           = each.value.policy_assignment
#   policy_definition_reference = each.value.policy_definition_reference
#   location_filters            = try(each.value.location_filters, [])
#   resource_discovery_mode     = try(each.value.resource_discovery_mode, null)
#   policy_definitions          = module.Landscape-Policy-Definitions
#   policy_assignments          = module.Landscape-Management-Group-Policy-Assignment
# }


# output "PolicyRemediations" {
#   value = module.Landscape-Policy-Remediations
# }




