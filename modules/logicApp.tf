resource "azurerm_logic_app_workflow" "logic_app_event_producer" {
    name = "ida-eac-customer-changed-event-producer"
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
    name = "Calling Customer Changed Function"
    logic_app_id = azurerm_logic_app_workflow.logic_app_event_producer.id
    body = <<BODY
    {
        "CustomerChanged": {
            "inputs": {
                "body": {
                    "Address": {
                        "City": "Teststadt",
                        "Street": "Teststraße",
                        "Zip": "Testzip"
                    },
                    "Id": "@rand(1,1000)",
                    "Name": " Test"
                },
                "function": {
                    "id": "${azurerm_function_app.customer_function_producer.id}/customerChanged"
                },
                "method": "PUT"
            },
            "runAfter": {},
            "type": "Function"
        }
    }
    BODY
}