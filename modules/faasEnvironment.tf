resource "azurerm_app_service_plan" "function_app_service_plan" {
    name = "tc-eda-iac-${var.environment}-function-app-service-plan"
    location = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
    kind = "Windows"

    sku {
        tier = "Free"
        size = "F1"
    }
}

resource "azurerm_function_app" "customer_function_producer" {
    name = "tc-eda-iac-${var.environment}-function-customer-producer"
    location = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
    app_service_plan_id = azurerm_app_service_plan.function_app_service_plan.id
    storage_account_name = azurerm_storage_account.storage_account.name
    storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
    version = "~3"

    identity {
        type = "SystemAssigned"
    }
}

resource "azurerm_function_app" "customer_function_consumer" {
    name = "tc-eda-iac-${var.environment}-function-customer-consumer"
    location = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
    app_service_plan_id = azurerm_app_service_plan.function_app_service_plan.id
    storage_account_name = azurerm_storage_account.storage_account.name
    storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
    version = "~3"

    identity {
        type = "SystemAssigned"
    }
}