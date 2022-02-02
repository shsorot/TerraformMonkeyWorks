variable "name" {
  description = "(Required) Specifies the name of the Firewall policy. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group" {
  type = object({
    name = optional(string)
    tag  = optional(string)
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
  description = "(Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Tags"
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
  type    = bool
  default = false
}


variable "base_policy" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) The ID of the base Firewall Policy."
  default     = null
}

variable "firewall_policies" {
  type = map(object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  }))
  description = "(Optional) The output of module Azure-FirewallPolicy, used for lookup of Policy ID for base_policy_id property."
  default     = {}
}

variable "dns" {
  type = object({
    network_rule_fqdn_enabled = optional(bool)         # (Optional) Should the network rule fqdn be enabled?
    proxy_enabled             = optional(bool)         #  (Optional) Whether to enable DNS proxy on Firewalls attached to this Firewall Policy? Defaults to false.
    servers                   = optional(list(string)) #  (Optional) Whether to enable DNS proxy on Firewalls attached to this Firewall Policy? Defaults to false.
  })
  default = null
}



variable "insights" {
  type = object({
    enabled = bool                                        # (Required) Whether the insights functionality is enabled for this Firewall Policy.
    default_local_analytics_workspace = optional(object({ #  (Required) The ID of the default Log Analytics Workspace that the Firewalls associated with this Firewall Policy will send their logs to, when there is no location matches in the log_analytics_workspace.
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    }))
    retention_in_days = optional(int)                # (Optional) The number of days to retain the firewall logs.
    log_analytics_workspace = optional(list(object({ # (Optional) A list of log_analytics_workspace block as defined below.
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
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

  })
}

variable "threat_intelligence_mode" {
  type        = string
  description = "(Optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert."
  default     = "Alert"
}
