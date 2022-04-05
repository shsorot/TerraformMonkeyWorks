resource "azurerm_policy_set_definition" "this" {
  name         = var.name
  policy_type  = var.policy_type
  display_name = var.display_name
  dynamic "policy_definition_reference" {
    for_each = var.policy_definition_reference == null || var.policy_definition_reference == [] ? [] : var.policy_definition_reference
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition.id == null ? (
        var.policy_definitions[policy_definition_reference.value.policy_definition.tag].id
      ) : policy_definition_reference.value.policy_definition.id
      parameter_values = policy_definition_reference.value.parameter_values == null ? null : (
        policy_definition_reference.value.parameter_values.json == null ? (
          file(policy_definition_reference.value.parameter_values.file)
        ) : policy_definition_reference.value.parameter_values.json
      )
      reference_id       = policy_definition_reference.value.reference_id
      policy_group_names = policy_definition_reference.value.policy_group_names
    }
  }

  dynamic "policy_definition_group" {
    for_each = var.policy_definition_group == null || var.policy_definition_group == [] ? [] : var.policy_definition_group
    content {
      name                            = policy_definition_group.value.name
      display_name                    = policy_definition_group.value.display_name
      category                        = policy_definition_group.value.category
      description                     = policy_definition_group.value.description
      additional_metadata_resource_id = policy_definition_group.value.additional_metadata_resource_id
    }
  }

  description           = var.description
  # Deprecated from provider > 3.00.0
  # management_group_name = var.management_group_name
  metadata              = local.metadata
  parameters            = local.parameters
}