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

    app_settings = {
        EVENT_HUB_NAME = azurerm_eventhub.eventhub_customer_adress_changed.name
        CONNECTION_STRING = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.eventhub_customer_adress_changed_sas_connectionstring.id})"
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

        app_settings = {
        EVENT_HUB_NAME = azurerm_eventhub.eventhub_customer_adress_changed.name
        CONNECTION_STRING = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.eventhub_customer_adress_changed_sas_connectionstring.id})"
    }
}