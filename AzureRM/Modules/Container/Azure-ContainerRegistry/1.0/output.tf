output "id"{
  value = azurerm_container_registry.this.id
}

output "name"{
  value = azurerm_container_registry.this.name
}

output "resource_group_name"{
  value = azurerm_container_registry.this.resource_group_name
}

output "location"{
  value = azurerm_container_registry.this.location
}

output "login_server"{
  value = azurerm_container_registry.this.login_server
}

output "admin_enabled"{
  value = azurerm_container_registry.this.admin_enabled
}

output "admin_username"{
  value = azurerm_container_registry.this.admin_username
}

# This should only be enabled post thorough audit of your pipeline and pipe outputs.
output "admin_password"{
  sensitive = true
  value = azurerm_container_registry.this.admin_password
}

output "identity"{
  value = azurerm_container_registry.this.identity
}

