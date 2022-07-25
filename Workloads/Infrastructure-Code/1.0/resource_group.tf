

# Template: Core Infrastructure
# Version:  1.0
# Date:     25.03.2021

#

variable "ResourceGroups" {
  default = {}
}

module "Landscape-Resource-Groups" {
  source               = "../../../AzureRM/Modules/Resources/Azure-ResourceGroup/1.0"
  for_each             = var.ResourceGroups
  name                 = each.value.name == null ? each.key : each.value.name

  location             = each.value.location
  management_lock_name = try(each.value.management_lock_name, null)
  lock_level           = try(each.value.lock_level, null)
  notes                = try(each.value.notes, null)
  tags                 = try(each.value.tags, local.tags)
}

output "ResourceGroups" {
  value = module.Landscape-Resource-Groups
}
