ResourceGroups = {
  "RG-FWPolicy" = {
    name     = "RG-FWPolicy"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "FirewallPolicy"
    }
  }
}

Firewallpolicies = {
  fwpol1 = {
    name           = "fwpol1"
    resource_group = { tag = "RG-FWPolicy" }
  }
}