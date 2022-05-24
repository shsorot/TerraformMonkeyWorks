resource "azurerm_virtual_network_gateway" "this" {
  name                             = var.name
  resource_group_name              = local.resource_group_name
  location                         = local.location
  tags                             = local.tags
  type                             = var.type
  vpn_type                         = var.vpn_type
  enable_bgp                       = var.enable_bgp
  active_active                    = var.active_active
  private_ip_address_enabled       = var.private_ip_address_enabled
  default_local_network_gateway_id = local.default_local_network_gateway_id
  sku                              = var.sku
  generation                       = var.generation == null ? "None" : var.generation

  # As an exception to our naming convention and code schema, virtual network information will be pulled seperately as a gateway cannot exist in two different virtual networks in active-active configuration.
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = local.public_ip_address_id
    private_ip_address_allocation = var.ip_configuration.private_ip_address_allocation
    subnet_id                     = local.subnet_id
  }

  dynamic "ip_configuration" {
    for_each = var.active_active == true ? [1] : []
    content {
      name                          = "vnetGatewayAAConfig"
      public_ip_address_id          = local.public_ip_address_id
      private_ip_address_allocation = var.ip_configuration.private_ip_address_allocation
      subnet_id                     = local.subnet_id
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration == null ? [] : [1]
    content {
      address_space = var.vpn_client_configuration.address_space
      aad_tenant    = var.vpn_client_configuration.aad_tenant
      aad_audience  = var.vpn_client_configuration.aad_audience
      aad_issuer    = var.vpn_client_configuration.aad_issuer
      dynamic "root_certificate" {
        for_each = var.vpn_client_configuration.root_certificate == null ? [] : [1]
        content {
          name             = var.vpn_client_configuration.root_certificates.name
          public_cert_data = var.vpn_client_configuration.root_certificates.public_cert_data
        }
      }
      dynamic "revoked_certificate" {
        for_each = var.vpn_client_configuration.revoked_certificate == null ? [] : [1]
        content {
          name       = var.vpn_client_configuration.revoked_certificate.name
          thumbprint = var.vpn_client_configuration.revoked_certificate.public_cert_data
        }
      }

      radius_server_address = var.vpn_client_configuration.radius_server_address
      radius_server_secret  = var.vpn_client_configuration.radius_server_secret
      vpn_client_protocols  = var.vpn_client_configuration.vpn_client_protocols
      vpn_auth_types        = var.vpn_client_configuration.vpn_auth_types
    }
  }

  dynamic "bgp_settings" {
    for_each = var.bgp_settings == null || var.bgp_settings == {} ? [] : { for idx, instance in var.bgp_settings : idx => instance }
    content {
      asn = bgp_settings.value.asn
      dynamic "peering_addresses" {
        for_each = { for idx, instance in bgp_settings.value.peering_addresses : idx => instance }
        content {
          ip_configuration_name = peering_addresses.value.ip_configuration_name
          apipa_addresses       = peering_addresses.value.apipa_addresses
        }
      }
      peer_weight = bgp_settings.value.peer_weight
    }
  }

  dynamic "custom_route" {
    for_each = var.custom_route == null ? [] : [1]
    content {
      address_prefixes = var.custom_route.address_prefixes
    }
  }
}