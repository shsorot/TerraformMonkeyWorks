# TODO : Add data block based lookup
resource "azurerm_virtual_network" "this" {
  resource_group_name = local.resource_group_name
  name                = var.name
  location            = local.location
  tags                = local.resource_tags
  address_space       = var.address_space
  dynamic "ddos_protection_plan" {
    for_each = local.ddos_protection_plan_id == null ? [] : [1]
    content {
      id     = local.ddos_protection_plan_id
      enable = true
    }
  }
  bgp_community = var.bgp_community
  dns_servers   = var.dns_servers

  dynamic "subnet" {
    for_each = local.subnet
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
      security_group = subnet.value.security_group == null ? null : (
        subnet.value.security_group.id == null ? (
          subnet.value.security_group.name == null ? (
            var.network_security_groups == null && subnet.value.security_group.tag == null ? null : var.network_security_groups[subnet.value.security_group.key].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${subnet.value.security_group.resource_group_name == null ? local.resource_group_name : subnet.value.security_group.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/${subnet.value.security_group.name}"
        ) : subnet.value.security_group.id
      )
    }
  }
}