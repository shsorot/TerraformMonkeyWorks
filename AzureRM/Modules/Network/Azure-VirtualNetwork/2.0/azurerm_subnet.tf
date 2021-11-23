
# Subnets
resource "azurerm_subnet" "this" {

  for_each                                       = local.subnet
  name                                           = each.value.name == null ? each.key : each.value.name
  resource_group_name                            = local.resource_group_name
  virtual_network_name                           = var.name
  address_prefixes                               = each.value["address_prefixes"]
  enforce_private_link_endpoint_network_policies = try(each.value.enforce_private_link_endpoint_network_policies, false)
  enforce_private_link_service_network_policies  = try(each.value.enforce_private_link_service_network_policies, false)
  service_endpoints                              = try(each.value["service_endpoints"], [])
  #service_endpoint_policy_ids = (var.se_policy_storage_id == null || each.value["enable_se_policy_storage"] != true || !try(contains(each.value["service_endpoints"], "Microsoft.Storage"), false) ) ? null : [var.se_policy_storage_id]
  dynamic "delegation" {
    for_each = each.value.delegation == null || each.value.delegation == {} ? [] : [1]
    content {
      name = each.value.delegation.name
      service_delegation {
        name    = each.value.delegation.service_delegation.name
        actions = each.value.delegation.service_delegation.actions
      }
    }
  }

  lifecycle {
    ignore_changes = [
      delegation[0].service_delegation[0].actions # this attribute is set by Azure automatically during deployment => Terraform will try to modify it on subsequent runs if ignore_changes is not set for this attribute
    ]
  }
  depends_on = [azurerm_virtual_network.this]
}


