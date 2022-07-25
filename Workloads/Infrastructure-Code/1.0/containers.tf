variable "ContainerGroups" {
  default = {}
}

module "Landscape-Container-Groups" {
  source                    = "../../../AzureRM/Modules/Container/Azure-ContainerGroup/1.0"
  for_each                  = var.ContainerGroups
  name                      = each.value.name == null ? each.key : each.value.name
<<<<<<< HEAD

=======
>>>>>>> main
  resource_group            = each.value.resource_group
  location                  = try(each.value.location, null)
  tags                      = try(each.value.tags, local.tags)
  inherit_tags              = try(each.value.inherit_tags, false)
  identity                  = try(each.value.identity, null)
  init_container            = try(each.value.init_container, null)
  container                 = try(each.value.container, null)
  os_type                   = try(each.value.os_type, "Linux")
  dns_config                = try(each.value.dns_config, null)
  diagnostics               = try(each.value.diagnostics, null)
  dns_name_label            = try(each.value.dns_name_label, null)
  exposed_port              = try(each.value.exposed_port, null)
  ip_address_type           = try(each.value.ip_address_type, null)
  network_profile_id        = try(each.value.network_profile_id, null)
  image_registry_credential = try(each.value.image_registry_credential, null)
  restart_policy            = try(each.value.restart_policy, "Always")
  resource_groups           = module.Landscape-Resource-Groups
}

output "ContainerGroups" {
  value = module.Landscape-Container-Groups
}

variable "ContainerRegistries" {
  default = {}
}

module "Landscape-Container-Registries" {
  source                        = "../../../AzureRM/Modules/Container/Azure-ContainerRegistry/1.0"
  for_each                      = var.ContainerRegistries
  name                          = each.value.name == null ? each.key : each.value.name
  resource_group                = each.value.resource_group
  location                      = try(each.value.location, null)
  tags                          = try(each.value.tags, local.tags)
  inherit_tags                  = try(each.value.inherit_tags, false)
  sku                           = try(each.value.sku, "Basic")
  admin_enabled                 = try(each.value.admin_enabled, false)
  georeplications               = try(each.value.georeplications, null)
  network_rule_set              = try(each.value.network_rule_set, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, false)
  quarantine_policy_enabled     = try(each.value.quarantine_policy_enabled, false)
  retention_policy              = try(each.value.retention_policy, null)
  trust_policy                  = try(each.value.trust_policy, null)
  zone_redundancy_enabled       = try(each.value.zone_redundancy_enabled, false)
  export_policy_enabled         = try(each.value.export_policy_enabled, false)
  identity                      = try(each.value.identity, null)
  encryption                    = try(each.value.encryption, null)
  anonymous_pull_enabled        = try(each.value.anonymous_pull_enabled, false)
  network_rule_bypass_option    = try(each.value.network_rule_bypass_option, false)
  resource_groups               = module.Landscape-Resource-Groups
}

output "ContainerRegistries" {
  value = module.Landscape-Container-Registries
}