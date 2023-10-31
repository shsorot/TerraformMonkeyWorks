variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) Name of the automation Account.)"
  type        = string
}

# Added in provider > 3.xx.x 
variable "public_network_access_enabled"{
  type = bool
  description = "(Optional) Whether public network access is allowed for the container registry. Defaults to true."
  default = true
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

variable "sku_name" {
  description = "(Optional) The SKU name of the account - only Basic is supported at this time."
  type        = string
  default     = "Basic"
}

variable "local_authentication_enabled"{
  type = bool
  description = "(Optional)(Optional) Whether requests using non-AAD authentication are blocked."
  default = false
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "identity" {
  type = object({
    type = string # (Required) The type of identity used for this Automation Account. Possible values are SystemAssigned, UserAssigned and SystemAssigned, UserAssigned.
    identity = optional(list(object({
      id                  = optional(string) #(Optional) The ID of the User Assigned Identity which should be assigned to this Automation Account.
      name                = optional(string) #(Optional) The name of the User Assigned Identity which should be assigned to this Automation Account. Used to lookup ID using data blocks
      resource_group_name = optional(string) #(Optional) Resource group name to be used with the property 'name'. If null, core resource group will be used.
      key                 = optional(string) #(Optional) Terraform object key used to lookup ID using output of module Azure-UserAssignedIdentity supplied to variable 'user_assigned_identities'
    })))
  })
  description = <<EOF
      id                  = #(Optional) The ID of the User Assigned Identity which should be assigned to this Automation Account.
      name                = #(Optional) The name of the User Assigned Identity which should be assigned to this Automation Account. Used to lookup ID using data blocks
      resource_group_name = #(Optional) Resource group name to be used with the property 'name'. If null, core resource group will be used.
      key                 = #(Optional) Terraform object key used to lookup ID using output of module Azure-UserAssignedIdentity supplied to variable 'user_assigned_identities'
  EOF
  default     = null
}

variable "encryption"{
  type = object({
    user_assigned_identity = optional(object({
      id                  = optional(string) #(Optional) The ID of the User Assigned Identity which should be assigned to this Automation Account.
      name                = optional(string) #(Optional) The name of the User Assigned Identity which should be assigned to this Automation Account. Used to lookup ID using data blocks
      resource_group_name = optional(string) #(Optional) Resource group name to be used with the property 'name'. If null, core resource group will be used.
      key                 = optional(string) #(Optional) Terraform object key used to lookup ID using output of module Azure-UserAssignedIdentity supplied to variable 'user_assigned_identities'
    }))
    key_source            = optional(string) #(Optional) The source of the encryption key. Possible values are Microsoft.Keyvault and Microsoft.Storage.
    key_vault_key      = object({
      id               = optional(string) # Resource Id of the Key to be used for encrypting data in the automation account
      name             = optional(string) # Name of the key , to be used for lookup along with keyvault name when resource ID is not available
      key_vault_name   = optional(string) # To be used when 'name' is provided.
      resource_group_name = optional(string) # To be used with key_vault_name
      key              = optional(string) # To be used to perform  keypair lookup from the output of module Azure-KeyvaultKey
    })
  })
  default = null
}

variable "user_assigned_identities" {
  type = map(object({
    id = optional(string) #(Optional) The property id from output of module Azure-UserAssignedIdentity
  }))
  description = "(Optional)Output of module Azure-UserAssignedIdentity. Used to lookup ID using Terraform Object Keys"
  default     = {}
}


variable "key_vault_keys"{
  type = map(object({
    id = optional(string) # (Optional) the property ID from the output of module Azure-KeyVaultKey, used to lookup ID using terraform object Keys
  }))
    description = "(Optional) the property ID from the output of module Azure-KeyVaultKey, used to lookup ID using terraform object Keys"
    default = {}
}