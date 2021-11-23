output "id" {
  value = azurerm_lb.this.id
}

output "frontend_ip_configuration" {
  #value = azurerm_lb.this.frontend_ip_configuration
  value = { for instance in azurerm_lb.this.frontend_ip_configuration : instance.name => {
    "id"                 = instance.id
    "private_ip_address" = instance.private_ip_address
    "public_ip_address_id" = instance.public_ip_address_id }
  }
}

output "private_ip_address" {
  value = azurerm_lb.this.private_ip_address
}

output "private_ip_addresses" {
  value = azurerm_lb.this.private_ip_addresses
}

output "backend_address_pool" {
  value = { for k, v in azurerm_lb_backend_address_pool.this : k => { "id" = v.id } }
}

output "backend_address_pool_address" {
  value = { for k, v in azurerm_lb_backend_address_pool_address.this : k => { "id" = v.id } }
}

output "probe" {
  value = { for k, v in azurerm_lb_probe.this : k => { "id" = v.id } }
}

output "rule" {
  value = { for k, v in azurerm_lb_rule.this : k => { "id" = v.id } }
}

output "outbount_rule" {
  value = { for k, v in azurerm_lb_outbound_rule.this : k => { "id" = v.id } }
}

output "nat_pool" {
  value = { for k, v in azurerm_lb_nat_pool.this : k => { "id" : v.id } }
}

output "nat_rule" {
  value = { for k, v in azurerm_lb_nat_rule.this : k => { "id" = v.id } }
}


