resource "azurerm_app_service_plan" "function_app_service_plan" {
    name = "tc-eda-iac-${var.environment}-function-app-service-plan"
    location = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name

    sku {
        tier = "Free"
        size = "F1"
    }
}

resource "azurerm_function_app" "customer_function" {
    name = "tc-eda-iac-${var.environment}-function-customer"
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