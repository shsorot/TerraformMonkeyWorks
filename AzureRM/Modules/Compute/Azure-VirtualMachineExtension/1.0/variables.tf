variable "name" {
  type        = string
  description = "(Required) The name of the virtual machine extension peering. Changing this forces a new resource to be created."
}

variable "virtual_machine" {
  type = object({
    id                  = optional(string),
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Machine. Changing this forces a new resource to be created"
}


variable "virtual_machines" {
  type = map(object({
    id = optional(string),
  }))
}

variable "publisher" {
  type        = string
  description = "(Required) The publisher of the extension, available publishers can be found by using the Azure CLI. Changing this forces a new resource to be created."
}

variable "type" {
  type        = string
  description = "(Required) The type of extension, available types for a publisher can be found using the Azure CLI."
}

# The Publisher and Type of Virtual Machine Extensions can be found using the Azure CLI, via:
# az vm extension image list --location westus -o table

variable "type_handler_version" {
  type        = string
  description = "(Required) Specifies the version of the extension to use, available versions can be found using the Azure CLI."
}

variable "auto_upgrade_minor_version" {
  type        = bool
  description = "(Optional) Specifies if the platform deploys the latest minor version update to the type_handler_version specified."
  default     = true
}

variable "automatic_upgrade_enabled" {
  type        = bool
  description = "(Optional) Specifies if the extension should be automatically upgraded by the platform if there is a newer version of the extension available."
  default     = true
}

variable "settings" {
  type = object({
    json = optional(string)
    file = optional(string)
  })
  description = "(Required) The settings passed to the extension, these are specified as a JSON object in a string."
}

# Certain VM Extensions require that the keys in the settings block are case sensitive. 
#If you're seeing unhelpful errors, please ensure the keys are consistent with how Azure is expecting them 
#(for instance, for the JsonADDomainExtension extension, the keys are expected to be in TitleCase.)

variable "protected_settings" {
  type = object({
    json = optional(string)
    file = optional(string)
  })
  description = "(Optional) The protected_settings passed to the extension, like settings, these are specified as a JSON object in a string."
}

#Certain VM Extensions require that the keys in the protected_settings block are case sensitive. 
#If you're seeing unhelpful errors, please ensure the keys are consistent with how Azure is expecting them 
#(for instance, for the JsonADDomainExtension extension, the keys are expected to be in TitleCase.)

variable "tags" {
  type    = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default = {}
}