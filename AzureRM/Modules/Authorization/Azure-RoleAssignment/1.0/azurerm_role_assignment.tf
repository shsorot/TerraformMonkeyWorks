resource "azurerm_role_assignment" "this" {
  name = var.name
  # Currently this must be explicitly specified.
  # TODO : investigate possible discovery using data block 
  scope              = local.scope
  role_definition_id = local.role_definition_id

  # Conflicts with role_definition_id
  role_definition_name = local.role_definition_id == null ? var.role_definition_name : null

  # The Principal ID is also known as the Object ID (ie not the "Application ID" for applications).
  principal_id = local.principal_id

  condition         = var.condition
  condition_version = var.condition_version

  # This is only used in cross tenant scenario
  delegated_managed_identity_resource_id = var.delegated_managed_identity_resource_id

  description                      = var.description
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}