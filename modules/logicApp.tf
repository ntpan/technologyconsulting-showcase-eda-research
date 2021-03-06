resource "azurerm_logic_app_workflow" "logic_app_event_producer" {
    name = "tc-eda-iac-${var.environment}-customer-changed-event-producer"
    location = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
}

resource "azurerm_logic_app_trigger_recurrence" "logic_app_event_producer_trigger" {
    name = "To be triggered manually"
    logic_app_id = azurerm_logic_app_workflow.logic_app_event_producer.id
    # We just want to trigger it manually, so we'll set the frequency as low as possible
    frequency = "Month"
    interval = 2
}

resource "azurerm_logic_app_action_custom" "logic_app_event_producer_action_1" {
    name = "Initialize_variable"
    logic_app_id = azurerm_logic_app_workflow.logic_app_event_producer.id
    body = <<BODY
    {
                "inputs": {
                    "variables": [
                        {
                            "name": "i",
                            "type": "integer",
                            "value": 0
                        }
                    ]
                },
                "runAfter": {},
                "type": "InitializeVariable"
            }
    BODY
}

resource "azurerm_logic_app_action_custom" "logic_app_event_producer_action_5" {
    name = "Until"
    //Depends_on needed because terraform will throw the following error, basically deleting the logic app in the wrong order
    //Error: Error removing Action "Initialize_variable" from Logic App "tc-eda-iac-dev-customer-changed-event-producer" (Resource Group "tc-eda-iac-dev"): Error removing Action "Initialize_variable" from Logic App Workspace "tc-eda-iac-dev-customer-changed-event-producer" (Resource Group "tc-eda-iac-dev"): logic.WorkflowsClient#CreateOrUpdate: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="InvalidTemplate" Message="The template validation failed: 'The 'runAfter' property of template action 'Until' at line '1' and column '180' contains non-existent action: 'Initialize_variable'.'."
    depends_on = [azurerm_logic_app_action_custom.logic_app_event_producer_action_1]
    logic_app_id = azurerm_logic_app_workflow.logic_app_event_producer.id
    body = <<BODY
    {
        
                "actions": {
                    "HTTP": {
                        "inputs": {
                            "body": {
                                "Address": {
                                    "city": "Random-gibt-es-in-Logic-Apps-Nicht-Stadt",
                                    "street": "Leider-Alle-Gleich-Straße @{variables('i')}",
                                    "zip": "54321"
                                },
                                "id": "@variables('i')",
                                "name": "Test User"
                            },
                            "method": "PUT",
                            "uri": "https://${azurerm_function_app.customer_function_producer.default_hostname}/api/CustomerChanged"
                        },
                        "runAfter": {},
                        "type": "Http"
                    },
                    "Increment_Variable": {
                        "inputs": {
                            "name": "i",
                            "value": 1
                        },
                        "runAfter": {
                            "HTTP": [
                                "Succeeded"
                            ]
                        },
                        "type": "IncrementVariable"
                    }
                },
                "expression": "@equals(variables('i'), 50)",
                "limit": {
                    "count": 100,
                    "timeout": "PT1H"
                },
                "runAfter": {
                    "Initialize_variable": [
                        "Succeeded"
                    ]
                },
                "type": "Until"
            }
    BODY
}