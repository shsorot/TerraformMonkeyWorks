variable "location" {
  description = " (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "resource_group" {
  type = object({
    name = optional(string) # Name of the resource group
    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"
  })
  description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
}

variable "resource_groups" {
  type = map(object({
    id       = optional(string)
    location = optional(string)
    tags     = optional(map(string))
    name     = optional(string)
  }))
  description = <<EOF
   (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"
    id       = # ID of the resource group
    location = # Location of the resource group
    tags     = # List of Azure tags applied to resource group
    name     = # Name of the resource group
  EOF
  default     = {}
}

variable "name" {
  description = "(Required) Specifies the name of the Container Group. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  type    = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "sku" {
  type        = string
  description = " (Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  default     = "Basic"
}


variable "admin_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  default     = false
}

variable "georeplications" {
  type = object({
    location                  = string                #  (Required) A location where the container registry should be geo-replicated.
    regional_endpoint_enabled = optional(bool)        # (Optional) Specifies whether the container registry should be configured for regional endpoint.
    zone_redundancy_enabled   = optional(bool)        # (Optional) Specifies whether the container registry should be configured for zone redundancy.
    tags                      = optional(map(string)) # (Optional) Tags to be applied to this replication service.
  })
  default = null
}

variable "network_rule_set" {
  type = object({
    default_action = optional(string) # (Optional) The default action to apply to requests that are not explicitly allowed or denied. Defaults to Allow.
    ip_rule = optional(object({
      action   = string # (Required) The behaviour for requests matching this rule. At this time the only supported value is Allow
      ip_range = string #  (Required) The CIDR block from which requests will match the rule.
    }))
    virtual_network = optional(object({
      action    = string # (Required) The behaviour for requests matching this rule. At this time the only supported value is Allow
      subnet_id = string # (Required) The ID of the subnet from which requests will match the rule.
    }))
  })
  default = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether public network access is allowed for the container registry. Defaults to true"
  default     = true
}

variable "quarantine_policy_enabled" {
  type        = bool
  description = "(Optional) Boolean value that indicates whether quarantine policy is enabled. Defaults to false."
  default     = false
}

variable "retention_policy" {
  type = object({
    days    = optional(number) # (Optional) The number of days to retain an untagged manifect after which it gets purged. Defaults to 7
    enabked = optional(bool)   # (Optional) Boolean value that indicates whether the retention policy is enabled. Defaults to false.
  })
  default = null
}

variable "trust_policy" {
  type = object({
    enabled = optional(bool) # (Optional) Boolean value that indicates whether the trust policy is enabled. Defaults to false.
  })
  default = null
}

variable "zone_redundancy_enabled" {
  type        = bool
  description = " (Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to false."
  default     = false
}

variable "export_policy_enabled" {
  type        = bool
  description = "(Optional) Boolean value that indicates whether export policy is enabled. Defaults to true. In order to set it to false, make sure the public_network_access_enabled is also set to false."
  default     = false
}

variable "identity" {
  type = object({
    type        = string                 # (Required) Specifies the type of Managed Service Identity that should be configured on this Container Registry. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).
    identity_id = optional(list(string)) # (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Registry.
    # identity = optional(list(object({
    #   id = optional(string) # (Optional) Specifies the ID of the User Assigned Managed Identity to be assigned to this Container Registry.
    #   name = optional(string) # (Optional) Specifies the name of the User Assigned Managed Identity to be assigned to this Container Registry.
    #   resource_group_name = optional(string) # (Optional) Specifies the name of the Resource Group of the User Assigned Managed Identity. If null, resource group of container registry is used.
    #   tag = optional(string) # (Optional) Use the output of module Azure-UserAssignedIdentity to lookup the identity tag.
    # })))
  })
  default = null
}

# variable "UserAssignedIdentities"{
#   type = map(object({
#     id = string
#     principal_id = optional(string)
#     tenant_id    = optional(string)
#     client_id    = optional(string)
#   }))
#   default = {}
#   description = "(Optional) Output of module Azure-UserAssignedIdentity."
# }

variable "encryption" {
  type = object({
    enabled            = optional(bool) # (Optional) Boolean value that indicates whether encryption is enabled.
    key_vault_key_id   = string         # (Required) The ID of the Key Vault Key.
    identity_client_id = string         # (Required) The client ID of the managed identity associated with the encryption key.
  })
  default = null
}
variable "anonymous_pull_enabled" {
  type        = bool
  description = "(Optional) Whether allows anonymous (unauthenticated) pull access to this Container Registry? Defaults to false. This is only supported on resources with the Standard or Premium SKU."
  default     = false
}

variable "data_endpoint_enabled" {
  type        = bool
  description = "(Optional) Whether to enable dedicated data endpoints for this Container Registry? Defaults to false. This is only supported on resources with the Premium SKU."
  default     = false
}

variable "network_rule_bypass_option" {
  type        = bool
  description = "(Optional) Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices. Defaults to AzureServices."
  default     = false
}
