
variable "location" {
  description = "(Optional) The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
  default     = null
}

# variable "resource_group_name" {
#   description = "(Required) The name of the resource group where the load balancer resources will be imported."
#   type        = string
# }

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
  type        = string
  description = "(Required) Specifies the name of the Load Balancer."
}

variable "sku" {
  type        = string
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard. Defaults to Basic."
  default     = "Basic"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "frontend_ip_configuration" {
  description = "(Optional) One or multiple frontend_ip_configuration blocks as documented below."
  type = list(object({
    name = string # Required) Specifies the name of the frontend ip configuration.
    subnet = optional(object({
      id                   = optional(string)
      name                 = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
      key                  = optional(string)
      virtual_network_key  = optional(string)
    }))

    private_ip_address            = optional(any)    # (Optional) Private IP Address to assign to the Load Balancer. The last one and first four IPs in any range are reserved and cannot be manually assigned.
    private_ip_address_allocation = optional(string) # (Optional) The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static.
    private_ip_address_version    = optional(string) # The version of IP that the Private IP Address is. Possible values are IPv4 or IPv6

    public_ip_address = optional(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    }))

    public_ip_prefix = optional(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    }))

    # availability_zone = optional(string) # (Optional) Refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#availability_zone 
    zones = optional(list(string)) #(Optional) Refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#availability_zone 
  }))
  default = []
}

variable "backend_address_pool" {
  type    = list(string)
  default = null
}


variable "backend_address_pool_address" {
  type = list(object({
    name                      = string # (Required) The name which should be used for this Backend Address Pool Address. Changing this forces a new Backend Address Pool Address to be created.
    backend_address_pool_name = string # (Required) The name of the Backend Address Pool. Changing this forces a new Backend Address Pool Address to be created.
    virtual_network = object({
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    })
    ip_address = string # (Required) The Static IP Address which should be allocated to this Backend Address Pool.
  }))
  default = null
}

variable "probe" {
  type = list(object({
    name                      = string           # (Required) Specifies the name of the Probe.
    probe_protocol            = optional(string) # (Optional) Specifies the protocol of the end point. Possible values are Http, Https or Tcp. If Tcp is specified, a received ACK is required for the probe to be successful. If Http is specified, a 200 OK response from the specified URI is required for the probe to be successful.
    probe_port                = any              # (Required) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive.
    request_path              = optional(string) # (Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed.
    probe_interval            = optional(any)    # (Optional) The interval, in seconds between probes to the backend endpoint for health status. The default value is 15, the minimum value is 5.
    probe_unhealthy_threshold = optional(any)    # (Optional) The number of failed probe attempts after which the backend endpoint is removed from rotation. The default value is 2. NumberOfProbes multiplied by intervalInSeconds value must be greater or equal to 10.Endpoints are returned to rotation when at least one probe is successful.
  }))
  default = null
}

variable "loadbalancer_rule" {
  type = list(object({
    name                           = string           # (Required) Specifies the name of the LB Rule.
    frontend_ip_configuration_name = string           # (Required) The name of the frontend IP configuration to which the rule is associated.
    protocol                       = any              # (Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All.
    frontend_port                  = any              # (Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 0 and 65534, inclusive.
    backend_port                   = any              # (Required) The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive.
    backend_address_pool_name      = optional(string) # (Optional) A reference to a Backend Address Pool over which this Load Balancing Rule operates.
    probe_name                     = optional(string) # (Optional) A reference to a Probe used by this Load Balancing Rule.
    enable_floating_ip             = optional(bool)   # (Optional) Are the Floating IPs enabled for this Load Balncer Rule? A "floating” IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false.
    idle_timeout_in_minutes        = optional(any)    # (Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30 minutes. Defaults to 4 minutes.
    load_distribution              = optional(string) # (Optional) Specifies the load balancing distribution type to be used by the Load Balancer. Possible values are: Default – The load balancer is configured to use a 5 tuple hash to map traffic to available servers. SourceIP – The load balancer is configured to use a 2 tuple hash to map traffic to available servers. SourceIPProtocol – The load balancer is configured to use a 3 tuple hash to map traffic to available servers. Also known as Session Persistence, where the options are called None, Client IP and Client IP and Protocol respectively.
    disable_outbound_snat          = optional(string) # (Optional) Is snat enabled for this Load Balancer Rule? Default false.
    enable_tcp_reset               = optional(bool)   # (Optional) Is TCP Reset enabled for this Load Balancer Rule? Defaults to false.
  }))
  default = []
}


variable "loadbalancer_outbound_rule" {
  type = list(object({
    name                           = string         # (Required) Specifies the name of the Outbound Rule. Changing this forces a new resource to be created.
    backend_address_pool_name      = string         # (Required) The name of the backend address pool to tag this rule to.
    protocol                       = string         # (Required) The transport protocol for the external endpoint. Possible values are Udp, Tcp or All
    enable_tcp_reset               = optional(bool) # (Optional) Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.
    allocated_outbound_ports       = optional(any)  #  (Optional) The number of outbound ports to be used for NAT.
    idle_timeout_in_minutes        = optional(any)  # (Optional) The timeout for the TCP idle connection
    frontend_ip_configuration_name = list(string)   # List of Frontend IP configuration names to tag rules to
  }))
  default = []
}

variable "loadbalancer_nat_pool" {
  type = list(object({
    name                           = string # (Required) Specifies the name of the NAT pool.
    frontend_ip_configuration_name = string # (Required) The name of the frontend IP configuration exposing this rule.
    protocol                       = string # (Required) The transport protocol for the external endpoint. Possible values are Udp or Tcp.
    frontend_port_start            = any    # (Required) The first port number in the range of external ports that will be used to provide Inbound Nat to NICs associated with this Load Balancer. Possible values range between 1 and 65534, inclusive.
    frontend_port_end              = any    # (Required) The last port number in the range of external ports that will be used to provide Inbound Nat to NICs associated with this Load Balancer. Possible values range between 1 and 65534, inclusive.
    backend_port                   = any    # (Required) The port used for the internal endpoint. Possible values range between 1 and 65535, inclusive.
  }))
  default = []
}


variable "loadbalancer_nat_rule" {
  type = list(object({
    name                           = string         # (Required) Specifies the name of the NAT Rule.
    frontend_ip_configuration_name = string         # (Required) The name of the frontend IP configuration exposing this rule.
    protocol                       = string         # Required) The transport protocol for the external endpoint. Possible values are Udp, Tcp or All
    frontend_port                  = any            # (Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 1 and 65534, inclusive.
    backend_port                   = any            # (Required) The port used for internal connections on the endpoint. Possible values range between 1 and 65535, inclusive.
    idle_timeout_in_minutes        = optional(any)  # (Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30 minutes. Defaults to 4 minutes.
    enable_floating_ip             = optional(bool) # (Optional) Are the Floating IPs enabled for this Load Balncer Rule? A "floating” IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false
    enable_tcp_reset               = optional(bool) # (Optional) Is TCP Reset enabled for this Load Balancer Rule? Defaults to false
  }))
  default = []
}

variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_network_tag'"
  type = map(object({
    id   = string # Resource ID of the virtual Network
    name = string # Name of the Virtual Network
    subnet = map(object({
      id = string
    }))
  }))
  default = {}
}

variable "public_ip_addresses" {
  type = map(object({
    fqdn    = optional(string)
    id      = string
    address = optional(string)
  }))
  description = "(Required) Public IP address output from Azure-PublicIPAddress module. IP address must be of type static and standard."
  default     = {}
}


variable "public_ip_prefixes" {
  description = "(Optional) Output of Module Azure-PublicIPPRefix, used to lookup resource ID when var.public_ip_prefix_tag is specified."
  type = map(object({
    id        = string           # Resource ID of the public ip prefix object
    ip_prefix = optional(string) # CIDR prefix count of prefix object.
  }))
  default = {}
}

