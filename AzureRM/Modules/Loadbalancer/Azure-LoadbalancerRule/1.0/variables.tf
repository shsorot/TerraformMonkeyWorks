variable "name" {
  type        = string
  description = "(Required) Specifies the name of the LB Rule."
}

variable "loadbalancer" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Load Balancer in which to create the Rule."
}

variable "loadbalancers" {
  type = map(object({
    ifd = optional(string)
  }))
}

variable "frontend_ip_configuration_name" {
  type        = string
  description = "(Required) The name of the frontend IP configuration to which the rule is associated."
}

variable "protocol" {
  type        = string
  description = "(Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All."
}

variable "frontend_port" {
  type        = number
  description = "(Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 0 and 65534, inclusive."
}

variable "backend_port" {
  type        = number
  description = "(Required) The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive."
}

variable "backend_address_pool" {
  type = list(object({
    id   = optional(string)
    name = optional(string)
    key  = optional(string)
  }))
  description = "(Optional) A list of reference to a Backend Address Pool over which this Load Balancing Rule operates."
  default     = null
}

variable "backend_address_pools" {
  type = map(object({
    id = optional(string)
  }))
}

variable "probe" {
  type = object({
    id   = optional(string)
    name = optional(string)
    key  = optional(string)
  })
  default     = null
  description = "Optional) A reference to a Probe used by this Load Balancing Rule."
}

variable "probes" {
  type = map(object({
    id = optional(string)
  }))
}

variable "enable_floating_ip" {
  type        = bool
  description = "(Optional) Are the Floating IPs enabled for this Load Balncer Rule? A floating IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false."
  default     = false
}

variable "idle_timeout_in_minutes" {
  type        = number
  description = "(Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30 minutes. Defaults to 4 minutes."
  default     = 4
}

variable "load_distribution" {
  type        = string
  description = <<HELP
                (Optional) Specifies the load balancing distribution type to be used by the Load Balancer.
                Possible values are: Default – The load balancer is configured to use a 5 tuple hash to map traffic to available servers.
                SourceIP – The load balancer is configured to use a 2 tuple hash to map traffic to available servers.
                SourceIPProtocol – The load balancer is configured to use a 3 tuple hash to map traffic to available servers. 
                Also known as Session Persistence, where the options are called None, Client IP and Client IP and Protocol respectively.
                HELP
  default     = "Default"
}

variable "disable_outbound_snat" {
  type        = bool
  description = "(Optional) Is snat enabled for this Load Balancer Rule? Default false."
  default     = false
}

variable "enable_tcp_reset" {
  type        = bool
  description = "(Optional) Is TCP Reset enabled for this Load Balancer Rule? Defaults to false."
  default     = false
}