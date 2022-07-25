variable "name" {
  description = "(Required) Specifies the name of the Firewall policy. Changing this forces a new resource to be created."
  type        = string
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

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
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


# Note: there is no key based lookup as it results in a self-referential loop, which is not allowed by Terraform.data 
# You could technically create two calls of module , one for base and one for child policies and pass the output of the base module to child module
# If this is the case, please uncomment line:57, 63:72 and in file local.tf:73
variable "base_policy" {
  type = object({
    id                  = optional(string)    # Resource ID of the base policy to be used
    name                = optional(string)    # Name of the base policy if the ID is unknown.
    resource_group_name = optional(string)    # Resource group where the policy resides. If null, primary resource_group will be used for lookup
    # key                = optional(string)    # Key value of the policy from output of module Azure-FirewallPolicy
  })
  description = "(Optional) The ID of the base Firewall Policy."
  default     = null
}

# variable "firewall_policies" {
#   type = map(object({
#     id                  = optional(string)
#     name                = optional(string)
#     resource_group_name = optional(string)
#     key                 = optional(string)
#   }))
#   description = "(Optional) The output of module Azure-FirewallPolicy, used for lookup of Policy ID for base_policy_id property."
#   default     = {}
# }

variable "dns" {
  type = object({
    # network_rule_fqdn_enabled = optional(bool)         # (Optional) Should the network rule fqdn be enabled?. Deprecated in provider version > 3.xx.x
    proxy_enabled = optional(bool)         #  (Optional) Whether to enable DNS proxy on Firewalls attached to this Firewall Policy? Defaults to false.
    servers       = optional(list(string)) #  (Optional) Whether to enable DNS proxy on Firewalls attached to this Firewall Policy? Defaults to false.
  })
  default = null
}


variable "identity" {
  type = object({
    type = string
    identity = optional(list(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    })))
  })
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this Firewall Policy. Only possible value is UserAssigned."
  default     = null
}


# Used by "identity"
variable "user_assigned_identities" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "insights" {
  type = object({
    enabled = bool                                        # (Required) Whether the insights functionality is enabled for this Firewall Policy.
    default_local_analytics_workspace = optional(object({ #  (Required) The ID of the default Log Analytics Workspace that the Firewalls associated with this Firewall Policy will send their logs to, when there is no location matches in the log_analytics_workspace.
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    }))
    retention_in_days = optional(number)             # (Optional) The number of days to retain the firewall logs.
    log_analytics_workspace = optional(list(object({ # (Optional) A list of log_analytics_workspace block as defined below.
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    })))
  })
  default = null
}

variable "log_analytics_workspaces" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) The output of module Azure-LogAnalyticsWorkspace, used for lookup of Workspace ID for insights.default_local_analytics_workspace property."
  default     = {}
}

variable "intrusion_detection" {
  type = object({
    mode = optional(string)
    signature_overrides = optional(list(object({
      id    = optional(string) # (Optional) 12-digit number (id) which identifies your signature.
      state = optional(string) # (Optional) state can be any of "Off", "Alert" or "Deny".
    })))
    traffic_bypass = optional(list(object({
      name                  = string                 # (Required) The name which should be used for this bypass traffic setting.
      protocol              = string                 # (Required) The protocols any of "ANY", "TCP", "ICMP", "UDP" that shall be bypassed by intrusion detection.
      description           = optional(string)       # (Optional) The description for this bypass traffic setting.
      destination_addresses = optional(list(string)) # (Optional) The list of destination addresses to be bypassed by intrustion detection.
      destination_ip_groups = optional(list(string)) # (Optional) The list of destination IP groups to be bypassed by intrustion detection.
      destination_ports     = optional(list(string)) # (Optional) The list of destination ports to be bypassed by intrustion detection.
      source_addresses      = optional(list(string)) # (Optional) Specifies a list of source addresses that shall be bypassed by intrusion detection.
      source_ip_groups      = optional(list(string)) # (Optional) Specifies a list of source IP groups that shall be bypassed by intrusion detection.
    })))
  })
  default = null
}

variable "private_ip_ranges" {
  type        = list(string)
  description = "(Optional) A list of private IP ranges to which traffic will not be SNAT."
  default     = null
}

variable "sku" {
  type        = string
  description = "(Optional) The SKU Tier of the Firewall Policy. Possible values are Standard, Premium. Changing this forces a new Firewall Policy to be created."
  default     = "Standard"
}

variable "threat_intelligence_allowlist" {
  type = object({
    fqdns        = optional(list(string)) # (Optional) A list of FQDNs that will be skipped for threat detection.
    ip_addresses = optional(list(string)) # (Optional) A list of IP addresses or CIDR ranges that will be skipped for threat detection.
  })
  default = null
}

variable "threat_intelligence_mode" {
  type        = string
  description = "(Optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert."
  default     = "Alert"
}

variable "tls_certificate" {
  type = object({
    name = string # (Required) The name of the certificate.
    key_vault_secret = object({
      id                  = optional(string) # (Required) The ID of the Key Vault Secret
      name                = optional(string) # (Required) The name of the Key Vault Secret 
      key_vault_name      = optional(string) # (Required) The name of the Key Vault
      resource_group_name = optional(string) # (Required) The name of the resource group
    })
  })
  default = null
}


variable "keyvault_certificates" {
  type = map(object({
    id         = optional(string)
    version    = optional(string)
    thumbprint = optional(string)
  }))
  description = "(Optional) The output of module Azure-KeyVaultCertificate, used for lookup of certificate ID for tls_certificate property."
}