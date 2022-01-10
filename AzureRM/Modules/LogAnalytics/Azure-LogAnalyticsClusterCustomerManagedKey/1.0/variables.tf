variable "key_vault_key" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    key_vault_name      = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
}

variable "key_vault_keys" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "log_analytics_cluster" {
  type = object({
    id                  = optional(string)
    resource_group_name = optional(string)
    name                = optional(string)
    tag                 = optional(string)
  })
}

variable "log_analytics_clusters" {
  type = map(object({
    id         = optional(string)
    cluster_id = optional(string)
  }))
  default = {}
}

