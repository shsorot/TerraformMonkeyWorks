variable "name" {
  type        = string
  description = "(Required) The name of the Policy Remediation. Changing this forces a new resource to be created."
}

variable "scope" {
  type        = string
  description = "(Required) The Scope at which the Policy Remediation should be applied. Changing this forces a new resource to be created. A scope must be a Resource ID out of one of the following list:"
}

# Examples for Scopes

# A subscription, e.g. /subscriptions/00000000-0000-0000-0000-000000000000
# A resource group, e.g. /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup
# A resource, e.g. /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Compute/virtualMachines/myVM
# A management group, e.g. /providers/Microsoft.Management/managementGroups/00000000-0000-0000-0000-000000000000

variable "policy_assignment" {
  type = object({
    id  = optional(string)
    tag = optional(string)
  })
  description = "(Required) The ID of the Policy Assignment that should be remediated."
}

variable "policy_assignments" {
  type = map(object({
    id = optional(string)
  }))
}

variable "policy_definition_reference" {
  type = object({
    id  = optional(string)
    tag = optional(string)
  })
  description = "(Optional) The unique ID for the policy definition within the policy set definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition."
}

variable "policy_definitions" {
  type = map(object({
    id = optional(string)
  }))
}

variable "location_filters" {
  type        = list(string)
  description = "(Optional) A list of the resource locations that will be remediated."
  default     = null
}

variable "resource_discovery_mode" {
  type        = string
  description = "(Optional) The way that resources to remediate are discovered. Possible values are ExistingNonCompliant, ReEvaluateCompliance. Defaults to ExistingNonCompliant."
  default     = "ExistingCompliant"
}

