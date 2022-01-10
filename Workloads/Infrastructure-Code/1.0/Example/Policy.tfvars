PolicyDefinitions = {
  "Deny-Resource-Type" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Deny Specific Resource Type."
    description           = "This rule will prevent specified resource type."
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
      "if": {
        "field": "type",
        "in": "[parameters('listOfResourceTypeNotAllowed')]"
      },
      "then" :{
        "effect": "Deny"
      }
    }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "listOfResourceTypeNotAllowed": {
        "type" : "Array",
        "metadata": {
          "displayName": "Not Allowed resource type",
          "description": "The list of resource types that cannot be deployed",
          "strongType": "resourceTypes"
        }
      }
    }
    PARAMETERS
    }
    metadata = null
  }

  "Deny-NSG-With-Source-Any" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Deny NSG with rules with source as any."
    description           = "This rule will prevent any NSG from being created that as a rule with source as *."
    management_group_name = null
    policy_rule = {
      json = <<POLICY
                {
            "if": {
              "allOf": [
                {
                  "field": "type",
                  "equals": "Microsoft.Network/networkSecurityGroups"
                },
                {
                  "count": {
                    "field": "Microsoft.Network/networkSecurityGroups/securityRules[*]",
                    "where": {
                      "allOf": [
                        {
                          "field": "Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefix",
                          "equals": "*"
                        },
                        {
                          "anyOf": [
                            {
                              "not": {
                                "field": "Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefixes[*]",
                                "notIn": []
                              }
                            },
                            {
                              "field": "Microsoft.Network/networkSecurityGroups/securityRules[*].sourceAddressPrefixes[*]",
                              "exists": false
                            }
                          ]
                        },
                        {
                          "field": "Microsoft.Network/networkSecurityGroups/securityRules[*].access",
                          "equals": "Allow"
                        },
                        {
                          "field": "Microsoft.Network/networkSecurityGroups/securityRules[*].direction",
                          "equals": "Inbound"
                        }
                      ]
                    }
                  },
                  "greater": 0
                }
              ]
            },
            "then": {
              "effect": "[parameters('effectType')]"
            }
          }
        POLICY
    }
    parameters = {
      json = <<PARAMETERS
        {
            "effectType": {
                "type": "String",
                "metadata": {},
                "allowedValues": [
                    "Deny",
                    "Audit"
                ],
                "defaultValue": "Deny"
            }
        }
        PARAMETERS
    }
    metadata = null
  },

  // Diagnostic Settings Audit Policy
  "Diagnostic-Settings-Audit-Policy" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Verify Diagnostic Settings for Selected Resource Types"
    description           = "For the given resource types, audit any instances which do not have a configuration for all logs and metric data to be sent to an Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "in": "[parameters('diagnosticResourceTypes')]"
          }
        ]
      },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Insights/diagnosticSettings",
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                "equals": "true"
              },
              {
                "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                "equals": "true"
              },
              {
                "not": {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": ""
                }
              }
            ]
          }
        }
      }
    }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "diagnosticResourceTypes": {
        "type": "Array",
        "metadata": {
          "displayName": "Resource Types",
          "strongType": "resourceTypes"
        },
        "defaultValue": []
      }
    }
    PARAMETERS
    }
    metadata = null
  }

  // Log analytics policy definitions
  "storageAccount-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "Indexed"
    display_name          = "Apply diagnostic settings for Azure Storage Accounts - Log Analytics"
    description           = "Enabled Log analytics for storage account and all nested object types"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
      "if": {
       "allof" :[
        {
           "field": "type",
           "equals": "Microsoft.Storage/storageAccounts"
        },
        {
           "field": "location",
           "equals": "[parameters('locationFilter')]"
        }
       ]
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Insights/diagnosticSettings",
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
            "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
          ],
          "existenceCondition": {
            "allOf": [
              {
                "anyof": [
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                    "equals": "True"
                  },
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                    "equals": "True"
                  }
                ]
              },
              {
                "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                "equals": "[parameters('logAnalytics')]"
              }
            ]
          },
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "servicesToDeploy": {
                    "type": "array"
                  },
                  "diagnosticsSettingNameToUse": {
                    "type": "string"
                  },
                  "resourceName": {
                    "type": "string"
                  },
                  "logAnalytics": {
                    "type": "string"
                  },
                  "location": {
                    "type": "string"
                  },
                  "Transaction": {
                    "type": "string"
                  },
                  "StorageRead": {
                    "type": "string"
                  },
                  "StorageWrite": {
                    "type": "string"
                  },
                  "StorageDelete": {
                    "type": "string"
                  }
                },
                "variables": {},
                "resources": [
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'blobServices')]",
                    "type": "Microsoft.Storage/storageAccounts/blobServices/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/default/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "workspaceId": "[parameters('logAnalytics')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ],
                      "logs": [
                        {
                          "category": "StorageRead",
                          "enabled": "[parameters('StorageRead')]"
                        },
                        {
                          "category": "StorageWrite",
                          "enabled": "[parameters('StorageWrite')]"
                        },
                        {
                          "category": "StorageDelete",
                          "enabled": "[parameters('StorageDelete')]"
                        }
                      ]
                    }
                  },
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'fileServices')]",
                    "type": "Microsoft.Storage/storageAccounts/fileServices/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/default/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "workspaceId": "[parameters('logAnalytics')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ],
                      "logs": [
                        {
                          "category": "StorageRead",
                          "enabled": "[parameters('StorageRead')]"
                        },
                        {
                          "category": "StorageWrite",
                          "enabled": "[parameters('StorageWrite')]"
                        },
                        {
                          "category": "StorageDelete",
                          "enabled": "[parameters('StorageDelete')]"
                        }
                      ]
                    }
                  },
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'tableServices')]",
                    "type": "Microsoft.Storage/storageAccounts/tableServices/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/default/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "workspaceId": "[parameters('logAnalytics')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ],
                      "logs": [
                        {
                          "category": "StorageRead",
                          "enabled": "[parameters('StorageRead')]"
                        },
                        {
                          "category": "StorageWrite",
                          "enabled": "[parameters('StorageWrite')]"
                        },
                        {
                          "category": "StorageDelete",
                          "enabled": "[parameters('StorageDelete')]"
                        }
                      ]
                    }
                  },
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'queueServices')]",
                    "type": "Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/default/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "workspaceId": "[parameters('logAnalytics')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ],
                      "logs": [
                        {
                          "category": "StorageRead",
                          "enabled": "[parameters('StorageRead')]"
                        },
                        {
                          "category": "StorageWrite",
                          "enabled": "[parameters('StorageWrite')]"
                        },
                        {
                          "category": "StorageDelete",
                          "enabled": "[parameters('StorageDelete')]"
                        }
                      ]
                    }
                  },
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'storageAccounts')]",
                    "type": "Microsoft.Storage/storageAccounts/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "workspaceId": "[parameters('logAnalytics')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ]
                    }
                  }
                ],
                "outputs": {}
              },
              "parameters": {
                "diagnosticsSettingNameToUse": {
                  "value": "[parameters('diagnosticsSettingNameToUse')]"
                },
                "logAnalytics": {
                  "value": "[parameters('logAnalytics')]"
                },
                "location": {
                  "value": "[field('location')]"
                },
                "resourceName": {
                  "value": "[field('name')]"
                },
                "Transaction": {
                  "value": "[parameters('Transaction')]"
                },
                "StorageDelete": {
                  "value": "[parameters('StorageDelete')]"
                },
                "StorageWrite": {
                  "value": "[parameters('StorageWrite')]"
                },
                "StorageRead": {
                  "value": "[parameters('StorageRead')]"
                },
                "servicesToDeploy": {
                  "value": "[parameters('servicesToDeploy')]"
                }
              }
            }
          }
        }
      }
    }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Specify the Log Analytics workspace the storage account should be connected to.",
          "strongType": "omsWorkspace",
          "assignPermissions": true
        }
      },
      "servicesToDeploy": {
        "type": "Array",
        "metadata": {
          "displayName": "Storage services to deploy",
          "description": "List of Storage services to deploy"
        },
        "allowedValues": [
          "storageAccounts",
          "blobServices",
          "fileServices",
          "tableServices",
          "queueServices"
        ],
        "defaultValue": [
          "storageAccounts",
          "blobServices",
          "fileServices",
          "tableServices",
          "queueServices"
        ]
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "storageAccountsDiagnosticsLogsToWorkspace"
      },
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
          "DeployIfNotExists",
          "Disabled"
        ],
        "defaultValue": "DeployIfNotExists"
      },
      "StorageDelete": {
        "type": "String",
        "metadata": {
          "displayName": "StorageDelete - Enabled",
          "description": "Whether to stream StorageDelete logs to the Log Analytics workspace - True or False"
        },
        "allowedValues": [
          "True",
          "False"
        ],
        "defaultValue": "True"
      },
      "StorageWrite": {
        "type": "String",
        "metadata": {
          "displayName": "StorageWrite - Enabled",
          "description": "Whether to stream StorageWrite logs to the Log Analytics workspace - True or False"
        },
        "allowedValues": [
          "True",
          "False"
        ],
        "defaultValue": "True"
      },
      "StorageRead": {
        "type": "String",
        "metadata": {
          "displayName": "StorageRead - Enabled",
          "description": "Whether to stream StorageRead logs to the Log Analytics workspace - True or False"
        },
        "allowedValues": [
          "True",
          "False"
        ],
        "defaultValue": "True"
      },
      "Transaction": {
        "type": "String",
        "metadata": {
          "displayName": "Transaction - Enabled",
          "description": "Whether to stream Transaction logs to the Log Analytics workspace - True or False"
        },
        "allowedValues": [
          "True",
          "False"
        ],
        "defaultValue": "True"
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        }
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring",
      "version": "1.3.0"
    }
    METADATA
    }
  },

  "aa-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Automation Accounts - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Automation/automationAccounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Automation/automationAccounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "timeGrain": null,
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": [
                          {
                            "category": "JobLogs",
                            "enabled": true
                          },
                          {
                            "category": "JobStreams",
                            "enabled": true
                          },
                          {
                            "category": "DscNodeStatus",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                     "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
    }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureAutomationAccountDiagnosticsLogsToWorkspace"
      }
    }
    PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "aci-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Container Instances - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ContainerInstance/containerGroups"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ContainerInstance/containerGroups/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureContainerInstanceDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "acr-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Container Registry - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ContainerRegistry/registries"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ContainerRegistry/registries/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
            "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureContainerRegistyDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "aks-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Kubernetes Service - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ContainerService/managedClusters"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ContainerService/managedClusters/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "guard",
                            "enabled": true
                          },
                          {
                            "category": "kube-apiserver",
                            "enabled": true
                          },
                          {
                            "category": "kube-controller-manager",
                            "enabled": true
                          },
                          {
                            "category": "kube-scheduler",
                            "enabled": true
                          },
                          {
                            "category": "cluster-autoscaler",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureKubernetesServicesDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "analysisService-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Analysis Services - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.AnalysisServices/servers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.AnalysisServices/servers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Engine",
                            "enabled": true
                          },
                          {
                            "category": "Service",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureAnalysisServicesDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "apiMgmt-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure API management - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ApiManagement/service"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ApiManagement/service/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "Gateway Requests",
                            "enabled": true
                          },
                          {
                            "category": "Capacity",
                            "enabled": true
                          },
                          {
                            "category": "EventHub Events",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "GatewayLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureAPIManagementDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "appGw-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Application Gateways - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/applicationGateways"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/applicationGateways/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ApplicationGatewayAccessLog",
                            "enabled": true
                          },
                          {
                            "category": "ApplicationGatewayPerformanceLog",
                            "enabled": true
                          },
                          {
                            "category": "ApplicationGatewayFirewallLog",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureApplicationGatewayDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "batch-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Batch - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Batch/batchAccounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Batch/batchAccounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ServiceLog",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureBatchDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "cdnEndpoints-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for CDN Endpoints - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Cdn/profiles/endpoints"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Cdn/profiles/endpoints/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [],
                        "logs": [
                          {
                            "category": "CoreAnalytics",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('fullName')]"
                  },
                  "diagnosticsSettingNameToUse": {
                     "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureCDNEndpointDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "cognitive-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Cognitive Services - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.CognitiveServices/accounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.CognitiveServices/accounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Audit",
                            "enabled": true
                          },
                          {
                            "category": "RequestResponse",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureCognitiveServiceDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "cosmosDBs-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Cosmos DB - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DocumentDB/databaseAccounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DocumentDB/databaseAccounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "Requests",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "DataPlaneRequests",
                            "enabled": true
                          },
                          {
                            "category": "MongoRequests",
                            "enabled": true
                          },
                          {
                            "category": "QueryRuntimeStatistics",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureCosmoDBDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "dataFactory-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Data Factory - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DataFactory/factories"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DataFactory/factories/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ActivityRuns",
                            "enabled": true
                          },
                          {
                            "category": "PipelineRuns",
                            "enabled": true
                          },
                          {
                            "category": "TriggerRuns",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureDataFactoryDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "dlanalytics-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Data Lake Analytics - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DataLakeAnalytics/accounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DataLakeAnalytics/accounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Audit",
                            "enabled": true
                          },
                          {
                            "category": "Requests",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureDataLateAnalyticsDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "dlstore-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Data Lake Storage - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DataLakeStore/accounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DataLakeStore/accounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Audit",
                            "enabled": true
                          },
                          {
                            "category": "Requests",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureDataLateStorageDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "eventGridSub-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Event Grid Subscriptions - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.EventGrid/eventSubscriptions"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.EventGrid/eventSubscriptions/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureEventGridSubDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "eventGridTopic-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Event Grid Topics - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.EventGrid/topics"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.EventGrid/topics/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureEventGridTopicDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "eventHub-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Event Hub Namespaces - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.EventHub/namespaces"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.EventHub/namespaces/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ArchiveLogs",
                            "enabled": true
                          },
                          {
                            "category": "OperationalLogs",
                            "enabled": true
                          },
                          {
                            "category": "AutoScaleLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureEventHubSubDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "expressRoutes-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Express Routes Circuits - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/expressRouteCircuits"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/expressRouteCircuits/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "PeeringRouteLog",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureERCircuitSubDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "firewall-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Firewalls - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/azureFirewalls"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/azureFirewalls/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "AzureFirewallApplicationRule",
                            "enabled": true
                          },
                          {
                            "category": "AzureFirewallNetworkRule",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureFirewallDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "hdInsight-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for HDInsight - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
               "equals": "Microsoft.HDInsight/clusters"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.HDInsight/clusters/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureHDInsightDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "iotHub-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for IoT Hubs - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Devices/IotHubs"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Devices/IotHubs/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Connections",
                            "enabled": true
                          },
                          {
                            "category": "DeviceTelemetry",
                            "enabled": true
                          },
                          {
                            "category": "C2DCommands",
                            "enabled": true
                          },
                          {
                            "category": "DeviceIdentityOperations",
                            "enabled": true
                          },
                          {
                            "category": "FileUploadOperations",
                            "enabled": true
                          },
                          {
                            "category": "Routes",
                            "enabled": true
                          },
                          {
                            "category": "D2CTwinOperations",
                            "enabled": true
                          },
                          {
                            "category": "C2DTwinOperations",
                            "enabled": true
                          },
                          {
                            "category": "TwinQueries",
                            "enabled": true
                          },
                          {
                            "category": "JobsOperations",
                            "enabled": true
                          },
                          {
                            "category": "DirectMethods",
                            "enabled": true
                          },
                          {
                            "category": "E2EDiagnostics",
                            "enabled": true
                          },
                          {
                            "category": "Configurations",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureIOTHubDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "kv-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Key Vaults - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.KeyVault/vaults"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.KeyVault/vaults/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "AuditEvent",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureKeyVaultDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },


  "lb-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Load Balancers - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/loadBalancers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/loadBalancers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "timeGrain": null,
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": [
                          {
                            "category": "LoadBalancerAlertEvent",
                            "enabled": true
                          },
                          {
                            "category": "LoadBalancerProbeHealthStatus",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureLoadBalancerDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "logicApps-integrationAccounts-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Logic Apps Integration Accounts - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Logic/integrationAccounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Logic/integrationAccounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [],
                        "logs": [
                          {
                            "category": "IntegrationAccountTrackingEvents",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureLogicAppAccDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "logicApps-workflow-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Logic Workflows - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Logic/workflows"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Logic/workflows/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "WorkflowRuntime",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureLogicWorkflowDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "mySQL-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for MySQL Databases - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DBforMySQL/servers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DBforMySQL/servers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "MySqlSlowLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureMySQLDBDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "mySQL-workflow-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for MySQL Databases - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DBforMySQL/servers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DBforMySQL/servers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "MySqlSlowLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureMySQLWorkflowDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "nic-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Network Interfaces - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/networkInterfaces"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/networkInterfaces/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "timeGrain": null,
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureNetworkInterfaceDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "nsg-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Network Security Groups - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/networkSecurityGroups"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/networkSecurityGroups/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [],
                        "logs": [
                          {
                            "category": "NetworkSecurityGroupEvent",
                            "enabled": true
                          },
                          {
                            "category": "NetworkSecurityGroupRuleCounter",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureNSGDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "pip-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Public IPs - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/publicIPAddresses"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/publicIPAddresses/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "timeGrain": null,
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": [
                          {
                            "category": "DDoSProtectionNotifications",
                            "enabled": true
                          },
                          {
                            "category": "DDoSMitigationFlowLogs",
                            "enabled": true
                          },
                          {
                            "category": "DDoSMitigationReports",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azurePublicIPDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "postgreSQL-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for PostgreSQL Databases - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DBforPostgreSQL/servers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DBforPostgreSQL/servers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "PostgreSQLLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azurePSGRSQLDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "powerBIEmbedded-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Power BI Embedded - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.PowerBIDedicated/capacities"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.PowerBIDedicated/capacities/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Engine",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azurePowerBIDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "recoveryVault-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Recovery Vaults - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.RecoveryServices/vaults"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.RecoveryServices/vaults/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [],
                        "logs": [
                          {
                            "category": "AzureBackupReport",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryJobs",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryEvents",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryReplicatedItems",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryReplicationStats",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryRecoveryPoints",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryReplicationDataUploadRate",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryProtectedDiskDataChurn",
                            "enabled": true
                          },
                          {
                            "category": "CoreAzureBackup",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupJobs",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupAlerts",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupPolicy",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupStorage",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupProtectedInstance",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureRecoveryVaultDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "redisCache-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Redis Cache - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Cache/redis"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Cache/redis/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureRedisCacheDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "relay-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Relay - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Relay/namespaces"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Relay/namespaces/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureRelayDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "searchServices-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Search Services - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Search/searchServices"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Search/searchServices/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "OperationLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSearchServicesDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "serviceBus-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Service Bus namespaces - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ServiceBus/namespaces"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ServiceBus/namespaces/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "OperationalLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureServiceBusDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "signalR-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for SignalR - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.SignalRService/SignalR"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.SignalRService/SignalR/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSignalRDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "sql-mi-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for SQL Managed Instances - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Sql/managedInstances"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Sql/managedInstances/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "logs": [
                          {
                            "category": "ResourceUsageStats",
                            "enabled": true
                          },
                          {
                            "category": "SQLSecurityAuditEvents",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSQLMiDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "sqlDBs-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for SQL Databases - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Sql/servers/databases"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Sql/servers/databases/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "SQLInsights",
                            "enabled": true
                          },
                          {
                            "category": "AutomaticTuning",
                            "enabled": true
                          },
                          {
                            "category": "QueryStoreRuntimeStatistics",
                            "enabled": true
                          },
                          {
                            "category": "QueryStoreWaitStatistics",
                            "enabled": true
                          },
                          {
                            "category": "Errors",
                            "enabled": true
                          },
                          {
                            "category": "DatabaseWaitStatistics",
                            "enabled": true
                          },
                          {
                            "category": "Timeouts",
                            "enabled": true
                          },
                          {
                            "category": "Blocks",
                            "enabled": true
                          },
                          {
                            "category": "Deadlocks",
                            "enabled": true
                          },
                          {
                            "category": "SQLSecurityAuditEvents",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('fullName')]"
                  },
                  "diagnosticsSettingNameToUse": {
                     "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSQLDBDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "sqlElasticPools-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for SQL Elastic Pools - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Sql/servers/elasticPools"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Sql/servers/elasticPools/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('fullName')]"
                  },
                  "diagnosticsSettingNameToUse": {
                     "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSQLElasticPoolDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "streamAnalytics-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Stream Analytics - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.StreamAnalytics/streamingjobs"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.StreamAnalytics/streamingjobs/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Execution",
                            "enabled": true
                          },
                          {
                            "category": "Authoring",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureStreamAnalyticsDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "timeSeriesInsights-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Time Series Insights - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.TimeSeriesInsights/environments"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.TimeSeriesInsights/environments/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureTimeSeriesDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "trafficManager-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Traffic Manager - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/trafficManagerProfiles"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/trafficManagerProfiles/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ProbeHealthStatusEvents",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureTrafficManagerDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "vm-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Virtual Machines - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Compute/virtualMachines"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Compute/virtualMachines/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureVirtualMachineDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "vmss-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Virtual Machine Scale Sets - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Compute/virtualMachineScaleSets"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Compute/virtualMachineScaleSets/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureVMSSDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "vnet-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Virtual Networks - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/virtualNetworks"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/virtualNetworks/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "VMProtectionAlerts",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureVnetDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "vnetGW-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Virtual Network Gateways - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/virtualNetworkGateways"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/virtualNetworkGateways/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "GatewayDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "IKEDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "P2SDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "RouteDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "RouteDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "TunnelDiagnosticLog",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureVnetGWDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "webServerFarm-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Web App Service Plans - Log Analytics"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Web/serverfarms"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Web/serverfarms/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureEventGridSuWebServerfarmDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "website-logdiagnostic-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Web Sites"
    description           = "This policy automatically deploys and enable diagnostic settings to Log Analytics"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Web/sites"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "logAnalytics": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Web/sites/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "workspaceId": "[parameters('logAnalytics')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select the Log Analytics workspace from dropdown list",
          "strongType": "omsWorkspace"
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureWebSitesDiagnosticsLogsToWorkspace"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },


  // Eventhub policies
  "storageAccount-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "Indexed"
    display_name          = "Apply diagnostic settings for Azure Storage Accounts - Log Analytics"
    description           = "Enabled Log analytics for storage account and all nested object types"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
      "if": {
       "allof" :[
        {
           "field": "type",
           "equals": "Microsoft.Storage/storageAccounts"
        },
        {
           "field": "location",
           "equals": "[parameters('locationFilter')]"
        }
       ]
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Insights/diagnosticSettings",
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
            "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
          ],
          "existenceCondition": {
            "allOf": [
              {
                "anyof": [
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                    "equals": "True"
                  },
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                    "equals": "True"
                  }
                ]
              },
              {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
              }
            ]
          },
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "servicesToDeploy": {
                    "type": "array"
                  },
                  "diagnosticsSettingNameToUse": {
                    "type": "string"
                  },
                  "resourceName": {
                    "type": "string"
                  },
                  "eventHubRuleId": {
                      "type": "string"
                  },
                  "location": {
                    "type": "string"
                  },
                  "Transaction": {
                    "type": "string"
                  },
                  "StorageRead": {
                    "type": "string"
                  },
                  "StorageWrite": {
                    "type": "string"
                  },
                  "StorageDelete": {
                    "type": "string"
                  }
                },
                "variables": {},
                "resources": [
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'blobServices')]",
                    "type": "Microsoft.Storage/storageAccounts/blobServices/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/default/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ],
                      "logs": [
                        {
                          "category": "StorageRead",
                          "enabled": "[parameters('StorageRead')]"
                        },
                        {
                          "category": "StorageWrite",
                          "enabled": "[parameters('StorageWrite')]"
                        },
                        {
                          "category": "StorageDelete",
                          "enabled": "[parameters('StorageDelete')]"
                        }
                      ]
                    }
                  },
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'fileServices')]",
                    "type": "Microsoft.Storage/storageAccounts/fileServices/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/default/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ],
                      "logs": [
                        {
                          "category": "StorageRead",
                          "enabled": "[parameters('StorageRead')]"
                        },
                        {
                          "category": "StorageWrite",
                          "enabled": "[parameters('StorageWrite')]"
                        },
                        {
                          "category": "StorageDelete",
                          "enabled": "[parameters('StorageDelete')]"
                        }
                      ]
                    }
                  },
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'tableServices')]",
                    "type": "Microsoft.Storage/storageAccounts/tableServices/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/default/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ],
                      "logs": [
                        {
                          "category": "StorageRead",
                          "enabled": "[parameters('StorageRead')]"
                        },
                        {
                          "category": "StorageWrite",
                          "enabled": "[parameters('StorageWrite')]"
                        },
                        {
                          "category": "StorageDelete",
                          "enabled": "[parameters('StorageDelete')]"
                        }
                      ]
                    }
                  },
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'queueServices')]",
                    "type": "Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/default/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ],
                      "logs": [
                        {
                          "category": "StorageRead",
                          "enabled": "[parameters('StorageRead')]"
                        },
                        {
                          "category": "StorageWrite",
                          "enabled": "[parameters('StorageWrite')]"
                        },
                        {
                          "category": "StorageDelete",
                          "enabled": "[parameters('StorageDelete')]"
                        }
                      ]
                    }
                  },
                  {
                    "condition": "[contains(parameters('servicesToDeploy'), 'storageAccounts')]",
                    "type": "Microsoft.Storage/storageAccounts/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                      "metrics": [
                        {
                          "category": "Transaction",
                          "enabled": "[parameters('Transaction')]",
                          "retentionPolicy": {
                            "days": 0,
                            "enabled": false
                          },
                          "timeGrain": null
                        }
                      ]
                    }
                  }
                ],
                "outputs": {}
              },
              "parameters": {
                "diagnosticsSettingNameToUse": {
                  "value": "[parameters('diagnosticsSettingNameToUse')]"
                },
                "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                },
                "location": {
                  "value": "[field('location')]"
                },
                "resourceName": {
                  "value": "[field('name')]"
                },
                "Transaction": {
                  "value": "[parameters('Transaction')]"
                },
                "StorageDelete": {
                  "value": "[parameters('StorageDelete')]"
                },
                "StorageWrite": {
                  "value": "[parameters('StorageWrite')]"
                },
                "StorageRead": {
                  "value": "[parameters('StorageRead')]"
                },
                "servicesToDeploy": {
                  "value": "[parameters('servicesToDeploy')]"
                }
              }
            }
          }
        }
      }
    }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "servicesToDeploy": {
        "type": "Array",
        "metadata": {
          "displayName": "Storage services to deploy",
          "description": "List of Storage services to deploy"
        },
        "allowedValues": [
          "storageAccounts",
          "blobServices",
          "fileServices",
          "tableServices",
          "queueServices"
        ],
        "defaultValue": [
          "storageAccounts",
          "blobServices",
          "fileServices",
          "tableServices",
          "queueServices"
        ]
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "storageAccountsDiagnosticsToEventHub"
      },
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
          "DeployIfNotExists",
          "Disabled"
        ],
        "defaultValue": "DeployIfNotExists"
      },
      "StorageDelete": {
        "type": "String",
        "metadata": {
          "displayName": "StorageDelete - Enabled",
          "description": "Whether to stream StorageDelete logs to the Event Hub - True or False"
        },
        "allowedValues": [
          "True",
          "False"
        ],
        "defaultValue": "True"
      },
      "StorageWrite": {
        "type": "String",
        "metadata": {
          "displayName": "StorageWrite - Enabled",
          "description": "Whether to stream StorageWrite logs to the Event Hub - True or False"
        },
        "allowedValues": [
          "True",
          "False"
        ],
        "defaultValue": "True"
      },
      "StorageRead": {
        "type": "String",
        "metadata": {
          "displayName": "StorageRead - Enabled",
          "description": "Whether to stream StorageRead logs to the Event Hub - True or False"
        },
        "allowedValues": [
          "True",
          "False"
        ],
        "defaultValue": "True"
      },
      "Transaction": {
        "type": "String",
        "metadata": {
          "displayName": "Transaction - Enabled",
          "description": "Whether to stream Transaction logs to the Event Hub - True or False"
        },
        "allowedValues": [
          "True",
          "False"
        ],
        "defaultValue": "True"
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "displayName": "Location Filter",
          "strongType": "location"
        }
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring",
      "version": "1.3.0"
    }
    METADATA
    }
  },

  "aa-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Automation Accounts - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Automation/automationAccounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Automation/automationAccounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "timeGrain": null,
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": [
                          {
                            "category": "JobLogs",
                            "enabled": true
                          },
                          {
                            "category": "JobStreams",
                            "enabled": true
                          },
                          {
                            "category": "DscNodeStatus",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                     "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
    }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureAutomationAccountDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "aci-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Container Instances - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ContainerInstance/containerGroups"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ContainerInstance/containerGroups/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureContainerInstanceDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "acr-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Container Registry - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ContainerRegistry/registries"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ContainerRegistry/registries/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
            "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureContainerRegistyDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "aks-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Kubernetes Service - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ContainerService/managedClusters"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ContainerService/managedClusters/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "guard",
                            "enabled": true
                          },
                          {
                            "category": "kube-apiserver",
                            "enabled": true
                          },
                          {
                            "category": "kube-controller-manager",
                            "enabled": true
                          },
                          {
                            "category": "kube-scheduler",
                            "enabled": true
                          },
                          {
                            "category": "cluster-autoscaler",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureKubernetesServicesDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "analysisService-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Analysis Services - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.AnalysisServices/servers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.AnalysisServices/servers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Engine",
                            "enabled": true
                          },
                          {
                            "category": "Service",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureAnalysisServicesDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "apiMgmt-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure API management - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ApiManagement/service"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ApiManagement/service/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "Gateway Requests",
                            "enabled": true
                          },
                          {
                            "category": "Capacity",
                            "enabled": true
                          },
                          {
                            "category": "EventHub Events",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "GatewayLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureAPIManagementDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "appGw-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Application Gateways - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/applicationGateways"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/applicationGateways/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ApplicationGatewayAccessLog",
                            "enabled": true
                          },
                          {
                            "category": "ApplicationGatewayPerformanceLog",
                            "enabled": true
                          },
                          {
                            "category": "ApplicationGatewayFirewallLog",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureApplicationGatewayDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "batch-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Azure Batch - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Batch/batchAccounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Batch/batchAccounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ServiceLog",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureBatchDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "cdnEndpoints-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for CDN Endpoints - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Cdn/profiles/endpoints"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Cdn/profiles/endpoints/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [],
                        "logs": [
                          {
                            "category": "CoreAnalytics",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('fullName')]"
                  },
                  "diagnosticsSettingNameToUse": {
                     "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureCDNEndpointDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "cognitive-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom",
    mode                  = "All",
    display_name          = "Apply diagnostic settings for Cognitive Services - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.CognitiveServices/accounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.CognitiveServices/accounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Audit",
                            "enabled": true
                          },
                          {
                            "category": "RequestResponse",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureCognitiveServiceDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "cosmosDBs-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Cosmos DB - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DocumentDB/databaseAccounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DocumentDB/databaseAccounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "Requests",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "DataPlaneRequests",
                            "enabled": true
                          },
                          {
                            "category": "MongoRequests",
                            "enabled": true
                          },
                          {
                            "category": "QueryRuntimeStatistics",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureCosmoDBDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "dataFactory-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Data Factory - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DataFactory/factories"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DataFactory/factories/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ActivityRuns",
                            "enabled": true
                          },
                          {
                            "category": "PipelineRuns",
                            "enabled": true
                          },
                          {
                            "category": "TriggerRuns",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureDataFactoryDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "dlanalytics-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Data Lake Analytics - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DataLakeAnalytics/accounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DataLakeAnalytics/accounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Audit",
                            "enabled": true
                          },
                          {
                            "category": "Requests",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureDataLateAnalyticsDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "dlstore-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Data Lake Storage - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DataLakeStore/accounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DataLakeStore/accounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Audit",
                            "enabled": true
                          },
                          {
                            "category": "Requests",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureDataLateStorageDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "eventGridSub-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Event Grid Subscriptions - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.EventGrid/eventSubscriptions"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.EventGrid/eventSubscriptions/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureEventGridSubDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "eventGridTopic-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Event Grid Topics - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.EventGrid/topics"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.EventGrid/topics/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureEventGridTopicDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "eventHub-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Event Hub Namespaces - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.EventHub/namespaces"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.EventHub/namespaces/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ArchiveLogs",
                            "enabled": true
                          },
                          {
                            "category": "OperationalLogs",
                            "enabled": true
                          },
                          {
                            "category": "AutoScaleLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureEventHubSubDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "expressRoutes-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Express Routes Circuits - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/expressRouteCircuits"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/expressRouteCircuits/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "PeeringRouteLog",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureERCircuitSubDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "firewall-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Firewalls - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/azureFirewalls"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/azureFirewalls/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "AzureFirewallApplicationRule",
                            "enabled": true
                          },
                          {
                            "category": "AzureFirewallNetworkRule",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureFirewallDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "hdInsight-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for HDInsight - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
               "equals": "Microsoft.HDInsight/clusters"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.HDInsight/clusters/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureHDInsightDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "iotHub-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for IoT Hubs - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Devices/IotHubs"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Devices/IotHubs/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Connections",
                            "enabled": true
                          },
                          {
                            "category": "DeviceTelemetry",
                            "enabled": true
                          },
                          {
                            "category": "C2DCommands",
                            "enabled": true
                          },
                          {
                            "category": "DeviceIdentityOperations",
                            "enabled": true
                          },
                          {
                            "category": "FileUploadOperations",
                            "enabled": true
                          },
                          {
                            "category": "Routes",
                            "enabled": true
                          },
                          {
                            "category": "D2CTwinOperations",
                            "enabled": true
                          },
                          {
                            "category": "C2DTwinOperations",
                            "enabled": true
                          },
                          {
                            "category": "TwinQueries",
                            "enabled": true
                          },
                          {
                            "category": "JobsOperations",
                            "enabled": true
                          },
                          {
                            "category": "DirectMethods",
                            "enabled": true
                          },
                          {
                            "category": "E2EDiagnostics",
                            "enabled": true
                          },
                          {
                            "category": "Configurations",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureIOTHubDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "kv-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Key Vaults - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.KeyVault/vaults"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.KeyVault/vaults/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "AuditEvent",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureKeyVaultDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },


  "lb-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Load Balancers - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/loadBalancers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/loadBalancers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "timeGrain": null,
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": [
                          {
                            "category": "LoadBalancerAlertEvent",
                            "enabled": true
                          },
                          {
                            "category": "LoadBalancerProbeHealthStatus",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureLoadBalancerDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "logicApps-integrationAccounts-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Logic Apps Integration Accounts - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Logic/integrationAccounts"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Logic/integrationAccounts/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [],
                        "logs": [
                          {
                            "category": "IntegrationAccountTrackingEvents",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureLogicAppAccDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "logicApps-workflow-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Logic Workflows - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Logic/workflows"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Logic/workflows/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "WorkflowRuntime",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureLogicWorkflowDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "mySQL-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for MySQL Databases - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DBforMySQL/servers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DBforMySQL/servers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "MySqlSlowLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureMySQLDBDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "mySQL-workflow-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for MySQL Databases - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DBforMySQL/servers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DBforMySQL/servers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "MySqlSlowLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureMySQLWorkflowDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "nic-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Network Interfaces - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/networkInterfaces"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/networkInterfaces/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "timeGrain": null,
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureNetworkInterfaceDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "nsg-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Network Security Groups - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/networkSecurityGroups"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/networkSecurityGroups/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [],
                        "logs": [
                          {
                            "category": "NetworkSecurityGroupEvent",
                            "enabled": true
                          },
                          {
                            "category": "NetworkSecurityGroupRuleCounter",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureNSGDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "pip-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Public IPs - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/publicIPAddresses"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/publicIPAddresses/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "timeGrain": null,
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": [
                          {
                            "category": "DDoSProtectionNotifications",
                            "enabled": true
                          },
                          {
                            "category": "DDoSMitigationFlowLogs",
                            "enabled": true
                          },
                          {
                            "category": "DDoSMitigationReports",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azurePublicIPDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "postgreSQL-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for PostgreSQL Databases - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.DBforPostgreSQL/servers"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.DBforPostgreSQL/servers/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "PostgreSQLLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azurePSGRSQLDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "powerBIEmbedded-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Power BI Embedded - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.PowerBIDedicated/capacities"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.PowerBIDedicated/capacities/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Engine",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azurePowerBIDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "recoveryVault-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Recovery Vaults - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.RecoveryServices/vaults"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.RecoveryServices/vaults/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [],
                        "logs": [
                          {
                            "category": "AzureBackupReport",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryJobs",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryEvents",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryReplicatedItems",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryReplicationStats",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryRecoveryPoints",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryReplicationDataUploadRate",
                            "enabled": true
                          },
                          {
                            "category": "AzureSiteRecoveryProtectedDiskDataChurn",
                            "enabled": true
                          },
                          {
                            "category": "CoreAzureBackup",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupJobs",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupAlerts",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupPolicy",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupStorage",
                            "enabled": true
                          },
                          {
                            "category": "AddonAzureBackupProtectedInstance",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureRecoveryVaultDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "redisCache-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Redis Cache - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Cache/redis"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Cache/redis/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureRedisCacheDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "relay-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Relay - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Relay/namespaces"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Relay/namespaces/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureRelayDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "searchServices-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Search Services - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Search/searchServices"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Search/searchServices/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "OperationLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSearchServicesDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "serviceBus-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Service Bus namespaces - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.ServiceBus/namespaces"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.ServiceBus/namespaces/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "OperationalLogs",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureServiceBusDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "signalR-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for SignalR - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.SignalRService/SignalR"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.SignalRService/SignalR/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSignalRDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "sql-mi-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for SQL Managed Instances - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Sql/managedInstances"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Sql/managedInstances/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "logs": [
                          {
                            "category": "ResourceUsageStats",
                            "enabled": true
                          },
                          {
                            "category": "SQLSecurityAuditEvents",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSQLMiDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "sqlDBs-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for SQL Databases - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Sql/servers/databases"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Sql/servers/databases/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "SQLInsights",
                            "enabled": true
                          },
                          {
                            "category": "AutomaticTuning",
                            "enabled": true
                          },
                          {
                            "category": "QueryStoreRuntimeStatistics",
                            "enabled": true
                          },
                          {
                            "category": "QueryStoreWaitStatistics",
                            "enabled": true
                          },
                          {
                            "category": "Errors",
                            "enabled": true
                          },
                          {
                            "category": "DatabaseWaitStatistics",
                            "enabled": true
                          },
                          {
                            "category": "Timeouts",
                            "enabled": true
                          },
                          {
                            "category": "Blocks",
                            "enabled": true
                          },
                          {
                            "category": "Deadlocks",
                            "enabled": true
                          },
                          {
                            "category": "SQLSecurityAuditEvents",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('fullName')]"
                  },
                  "diagnosticsSettingNameToUse": {
                     "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSQLDBDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "sqlElasticPools-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for SQL Elastic Pools - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Sql/servers/elasticPools"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Sql/servers/elasticPools/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('fullName')]"
                  },
                  "diagnosticsSettingNameToUse": {
                     "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureSQLElasticPoolDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "streamAnalytics-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Stream Analytics - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.StreamAnalytics/streamingjobs"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.StreamAnalytics/streamingjobs/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "Execution",
                            "enabled": true
                          },
                          {
                            "category": "Authoring",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureStreamAnalyticsDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "timeSeriesInsights-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Time Series Insights - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.TimeSeriesInsights/environments"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.TimeSeriesInsights/environments/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureTimeSeriesDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "trafficManager-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Traffic Manager - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/trafficManagerProfiles"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/trafficManagerProfiles/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "ProbeHealthStatusEvents",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureTrafficManagerDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "vm-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Virtual Machines - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Compute/virtualMachines"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Compute/virtualMachines/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureVirtualMachineDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "vmss-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Virtual Machine Scale Sets - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Compute/virtualMachineScaleSets"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Compute/virtualMachineScaleSets/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true,
                            "retentionPolicy": {
                              "enabled": false,
                              "days": 0
                            }
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureVMSSDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "vnet-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Virtual Networks - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/virtualNetworks"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/virtualNetworks/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "VMProtectionAlerts",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureVnetDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "vnetGW-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Virtual Network Gateways - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Network/virtualNetworkGateways"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Network/virtualNetworkGateways/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": [
                          {
                            "category": "GatewayDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "IKEDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "P2SDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "RouteDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "RouteDiagnosticLog",
                            "enabled": true
                          },
                          {
                            "category": "TunnelDiagnosticLog",
                            "enabled": true
                          }
                        ]
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureVnetGWDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "webServerFarm-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Web App Service Plans - Event Hub"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Web/serverfarms"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Web/serverfarms/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureEventGridSuWebServerfarmDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },

  "website-eventhubdiag-settings-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply diagnostic settings for Azure Web Sites"
    description           = "This policy automatically deploys and enable diagnostic settings to Event Hub"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
          "allof" :[
            {
              "field": "type",
              "equals": "Microsoft.Web/sites"
            },
            {
              "field": "location",
              "equals": "[parameters('locationFilter')]"
            }
          ]
        },
        "then": {
          "effect": "deployIfNotExists",
          "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "existenceCondition": {
              "allOf": [
                {
                "anyof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                      "equals": "True"
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                      "equals": "True"
                    }
                  ]
                },
                {
                  "field": "Microsoft.Insights/diagnosticSettings/eventHubAuthorizationRuleId",
                  "equals": "[parameters('eventHubRuleId')]"
                }
              ]
            },
            "name": "[parameters('diagnosticsSettingNameToUse')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "resourceName": {
                      "type": "string"
                    },
                    "eventHubRuleId": {
                      "type": "string"
                    },
                    "location": {
                      "type": "string"
                    },
                    "diagnosticsSettingNameToUse": {
                     "type": "string"
                    }
                  },
                  "variables": {},
                  "resources": [
                    {
                      "type": "Microsoft.Web/sites/providers/diagnosticSettings",
                      "apiVersion": "2021-05-01-preview",
                      "name": "[concat(parameters('resourceName'), '/',  'Microsoft.Insights/', parameters('diagnosticsSettingNameToUse'))]",
                      "location": "[parameters('location')]",
                      "dependsOn": [],
                      "properties": {
                        "eventHubAuthorizationRuleId": "[parameters('eventHubRuleId')]",
                        "metrics": [
                          {
                            "category": "AllMetrics",
                            "enabled": true
                          }
                        ],
                        "logs": []
                      }
                    }
                  ],
                  "outputs": {}
                },
                "parameters": {
                  "eventHubRuleId": {
                    "value": "[parameters('eventHubRuleId')]"
                  },
                  "location": {
                    "value": "[field('location')]"
                  },
                  "resourceName": {
                    "value": "[field('name')]"
                  },
                  "diagnosticsSettingNameToUse": {
                    "value": "[parameters('diagnosticsSettingNameToUse')]"
                  }
                }
              }
            }
          }
        }
      }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "eventHubRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "Event Hub Authorization Rule Id",
          "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
          "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
          "assignPermissions": true
        }
      },
      "locationFilter": {
        "type": "String",
        "metadata": {
          "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
          "strongType": "location"
        },
        "defaultValue": "eastus2"
      },
      "diagnosticsSettingNameToUse": {
        "type": "String",
        "metadata": {
          "displayName": "Setting name",
          "description": "Name of the diagnostic settings."
        },
        "defaultValue": "azureWebSitesDiagnosticsToEventHub"
      }
    }
     PARAMETERS
    }
    metadata = {
      json = <<METADATA
    {
      "category": "Monitoring"
    }
    METADATA
    }
  },


  "deny-unapproved-OS-image-policyDef" = {
    policy_type           = "Custom"
    mode                  = "All"
    display_name          = "Apply OS version restrictions while creating VMs"
    description           = "This policy automatically denies creating VMs from images that are not approved"
    management_group_name = null
    policy_rule = {
      json = <<POLICY
    {
        "if": {
            "allOf": [
                {
                  "field": "type",
                  "in": [
                      "Microsoft.Compute/virtualMachines",
                      "Microsoft.Compute/VirtualMachineScaleSets"
                  ]
                },
                {
                  "not": {
                      "allOf": [
                          {
                              "field": "Microsoft.Compute/imagePublisher",
                              "in": "[parameters('listOfAllowedImagePublishers')]"
                          },
                          {
                              "field": "Microsoft.Compute/imageOffer",
                              "in": "[parameters('listOfAllowedImageOffers')]"
                          },
                          {
                              "field": "Microsoft.Compute/imageSku",
                              "in": "[parameters('listOfAllowedImageSkus')]"
                          }
                      ]
                  }
                }
            ]
        },
        "then": {
            "effect": "[parameters('effectType')]"
        }
    }
    POLICY
    }
    parameters = {
      json = <<PARAMETERS
    {
      "listOfAllowedImagePublishers": {
        "type": "Array",
        "metadata": {
            "displayName": "Allowed image publishers",
            "description": "The list of image publishers that are allowed"
        }
      },
      "listOfAllowedImageOffers": {
        "type": "Array",
        "metadata": {
            "displayName": "Allowed image offers",
            "description": "The list of image offers that are allowed"
        }
      },
      "listOfAllowedImageSkus": {
        "type": "Array",
        "metadata": {
            "displayName": "Allowed image SKUs",
            "description": "The list of image SKUs that are allowed"
        }
      },
      "effectType": {
        "type": "String",
        "metadata": {},
        "allowedValues": [
          "Deny",
          "Audit"
        ],
        "defaultValue": "Deny"
      }
    }
    PARAMETERS
    }
    metadata = null
  }
}

PolicySetDefinitions = {
  resource-logdiagnostic-settings-policySet = {
    policy_type           = "Custom"
    display_name          = "Apply diagnostic settings for applicable resources - Log Analytics"
    description           = "This initiative configures application Azure resources to forward diagnostic logs and metrics to an Azure Log Analytics workspace."
    management_group_name = null
    metadata = {
      json = <<METADATA
            {
                "category": "Monitoring"
            }
            METADATA
    }
    parameters = {
      json = <<PARAMETERS
        {
            "logAnalytics": {
            "type": "String",
            "metadata": {
                "displayName": "Log Analytics workspace",
                "description": "Select the Log Analytics workspace from dropdown list",
                "strongType": "omsWorkspace"
            }
            },
            "locationFilter": {
            "type": "String",
            "metadata": {
                "displayName": "Location Filter",
                "description": "Select the resource location filter from dropdown list",
                "strongType": "location"
            }
            }
        }
        PARAMETERS
    }
    policy_definition_reference = [
      {
        policy_definition      = { tag = "nic-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "aa-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "pip-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "lb-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "nsg-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "kv-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "cognitive-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "dlanalytics-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "dlstore-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "eventHub-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "iotHub-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "logicApps-workflow-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "logicApps-integrationAccounts-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "recoveryVault-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "searchServices-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "serviceBus-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "sqlDBs-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "sqlElasticPools-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "apiMgmt-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "appGw-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "batch-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "mySQL-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "postgreSQL-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "cdnEndpoints-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "cosmosDBs-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "dataFactory-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "firewall-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "powerBIEmbedded-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "streamAnalytics-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "expressRoutes-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "aci-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "acr-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "vnet-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "vm-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "vmss-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "vnetGW-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "aks-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "website-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "analysisService-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "eventGridTopic-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "eventGridSub-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "hdInsight-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "redisCache-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "relay-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "signalR-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "trafficManager-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "webServerFarm-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "sql-mi-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "timeSeriesInsights-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition      = { tag = "storageAccount-logdiagnostic-settings-policyDef" }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      }
    ]
    policy_definition_group = []
  },

  resource-eventhubdiag-settings-policySet = {
    policy_type           = "Custom"
    display_name          = "Apply diagnostic settings for applicable resources - Event Hub"
    description           = "This initiative configures application Azure resources to forward diagnostic logs and metrics to an Azure Event Hub ."
    management_group_name = null
    metadata = {
      json = <<METADATA
        {
            "category": "Monitoring"
        }
        METADATA
    }
    parameters = {
      json = <<PARAMETERS
      {
        "eventHubRuleId": {
            "type": "String",
            "metadata": {
            "displayName": "Event Hub Authorization Rule Id",
            "description": "The Event Hub authorization rule Id for Azure Diagnostics. The authorization rule needs to be at Event Hub namespace level. e.g. /subscriptions/{subscription Id}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}",
            "strongType": "Microsoft.EventHub/Namespaces/AuthorizationRules",
            "assignPermissions": true
            }
        },
        "locationFilter": {
          "type": "string",
          "metadata": {
            "displayName": "Location Filter",
            "description": "The location the Event Hub resides in. Only resourced in this location will be linked to this Event Hub.",
            "strongType": "location"
          }
        }
      }
    PARAMETERS
    }
    policy_definition_reference = [
      {
        policy_definition = {
          tag = "nic-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "aa-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "pip-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "lb-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "nsg-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "kv-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "cognitive-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "dlanalytics-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "dlstore-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "eventHub-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "iotHub-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "logicApps-workflow-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "logicApps-integrationAccounts-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "recoveryVault-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "searchServices-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "serviceBus-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "sqlDBs-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "sqlElasticPools-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "apiMgmt-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "appGw-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "batch-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "mySQL-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "postgreSQL-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "cdnEndpoints-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "cosmosDBs-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "dataFactory-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "firewall-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "powerBIEmbedded-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "streamAnalytics-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "expressRoutes-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "aci-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "acr-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "vnet-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "vm-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "vmss-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "vnetGW-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "aks-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "website-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "analysisService-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "eventGridTopic-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "eventGridSub-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "hdInsight-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "redisCache-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "relay-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "signalR-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "trafficManager-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "webServerFarm-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "sql-mi-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "timeSeriesInsights-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      },
      {
        policy_definition = {
          tag = "storageAccount-eventhubdiag-settings-policyDef"
        }
        reference_id           = null
        policy_definition_name = null
        parameter_values = {
          json = <<VALUE
        {
          "eventHubRuleId": {
            "value": "[parameters('eventHubRuleId')]"
          },
          "locationFilter": {
            "value": "[parameters('locationFilter')]"
          }
        }
        VALUE
        }
        policy_group_names = []
      }
    ]
    policy_definition_group = []
  }

}

ManagementGroupPolicyAssignments = {}

