resource_group_name = "NSG-rg"
location            = "North Europe"
name                = "TF-NSG-Test"
tags = {
  "env" = "dev"
}
inherit_tags = false

nsg_rule = [
  {
    name      = "testrule1"
    priority  = 100
    access    = "Allow"
    protocol  = "tcp"
    direction = "Inbound"
    source_application_security_group = [
      {
        name = "source-asg1"
      },
      {
        name = "source-asg2"
      }
    ]
    destination_application_security_group = [
      {
        name = "dest-asg1"
      },
      {
        tag = "test-ASG1"
      }
    ]

  }

]

application_security_groups = {
  "test-ASG1" = {
    "id" = "/subscriptions/ae894bb7-da9a-40de-b039-5018557f3df1/resourceGroups/network-rg/providers/Microsoft.Network/applicationSecurityGroups/test-asg"
  }
}