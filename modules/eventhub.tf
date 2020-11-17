resource "azurerm_eventhub_namespace" "customer_eventhub_namespace" {
    name = "tc-eda-iac-${var.environment}-customer-eventhub"
    location = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
    sku = "Standard"
    capacity = 1
}

resource "azurerm_eventhub" "eventhub_customer_adress_changed" {
    name = "adresschanged"
    namespace_name = azurerm_eventhub_namespace.customer_eventhub_namespace.name
    resource_group_name = azurerm_resource_group.resourceGroup.name
    partition_count = 2 
    message_retention = 1
}

