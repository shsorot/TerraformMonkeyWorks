variable "KeyVaults" {
  default = {}
}

module "Landscape-Key-Vaults" {
  source                          = "../../../AzureRM/Modules/KeyVault/Azure-KeyVault/1.0"
  for_each                        = var.KeyVaults
  name                            = each.value.name == null ? each.key : each.value.name

  resource_group                  = each.value.resource_group
  location                        = try(each.value.location, null)
  sku_name                        = try(each.value.sku_name, null)
  enabled_for_deployment          = try(each.value.enabled_for_deployment, null)
  enabled_for_template_deployment = try(each.value.enabled_for_template_deployment, null)
  enabled_for_disk_encryption     = try(each.value.enabled_for_template_deployment, null)
  enable_rbac_authorization       = try(each.value.enable_rbac_authorization, null)
  soft_delete_retention_days      = try(each.value.soft_delete_retention_days, null)
  purge_protection_enabled        = try(each.value.purge_protection_enabled, null)
  access_policy                   = try(each.value.access_policy, null)
  contact                         = try(each.value.contact, null)
  network_acls                    = try(each.value.network_acls, null)
  virtual_networks                = module.Landscape-Virtual-Networks
  tags                            = try(each.value.tags, local.tags)
  inherit_tags                    = try(each.value.inherit_tags, false)
  resource_groups                 = module.Landscape-Resource-Groups
}

output "KeyVaults" {
  value = module.Landscape-Key-Vaults
}

variable "KeyVaultAccessPolicies" {
  default = {}
}

module "Landscape-Key-vault-Access-Policies" {
  source                  = "../../../AzureRM/Modules/KeyVault/Azure-KeyVaultAccessPolicy/1.0"
  for_each                = var.KeyVaultAccessPolicies
  key_vault               = each.value.key_vault
  key_vaults              = module.Landscape-Key-Vaults
  tenant_id               = try(each.value.tenant_id, null)
  object_id               = try(each.value.object_id, null)
  application_id          = try(each.value.application_id, null)
  certificate_permissions = try(each.value.certificate_permissions, [])
  key_permissions         = try(each.value.key_permissions, [])
  secret_permissions      = try(each.value.secret_permissions, [])
  storage_permissions     = try(each.value.storage_permissions, [])
}

output "KeyVaultAccessPolicies" {
  value = module.Landscape-Key-vault-Access-Policies
}

variable "KeyVaultKeys" {
  default = {}
}

module "Landscape-Key-Vault-Keys" {
  source          = "../../../AzureRM/Modules/KeyVault/Azure-KeyVaultKey/1.0"
  for_each        = var.KeyVaultKeys
  name            = each.value.name == null ? each.key : each.value.name

  key_vault       = each.value.key_vault
  key_vaults      = module.Landscape-Key-Vaults
  key_type        = each.value.key_type
  key_size        = try(each.value.key_size, null)
  curve           = try(each.value.curve, "P-256")
  key_opts        = each.value.key_opts
  expiration_date = try(each.value.expiration_date, null)
  tags            = try(each.value.tags, local.tags)
}

output "KeyVaultKeys" {
  value = module.Landscape-Key-Vault-Keys
}

variable "KeyVaultSecrets" {
  default = {}
}

module "Landscape_Key-Vault-Secrets" {
  source          = "../../../AzureRM/Modules/KeyVault/Azure-KeyVaultSecret/1.0"
  for_each        = var.KeyVaultSecrets
  name            = each.value.name == null ? each.key : each.value.name

  value           = each.value.value
  key_vault       = each.value.key_vault
  key_vaults      = module.Landscape-Key-Vaults
  content_type    = try(each.value.content_type, null)
  not_before_date = try(each.value.not_before_date, null)
  expiration_date = try(each.value.expiration_date, null)
  tags            = try(each.value.tags, local.tags)
}

output "KeyVaultSecrets" {
  value = module.Landscape_Key-Vault-Secrets
}

variable "KeyVaultCertificates" {
  default = {}
}

module "Landscape-Key-Vault-Certificates" {
  source             = "../../../AzureRM/Modules/KeyVault/Azure-KeyVaultCertificate/1.0"
  for_each           = var.KeyVaultCertificates
  name               = each.value.name == null ? each.key : each.value.name

  key_vault          = each.value.key_vault
  key_vaults         = module.Landscape-Key-Vaults
  certificate        = try(each.value.certificate, null)
  certificate_policy = each.value.certificate_policy
  tags               = try(each.value.tags, local.tags)
}

output "KeyVaultCertificates" {
  value = module.Landscape-Key-Vault-Certificates
}