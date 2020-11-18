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

resource "azurerm_eventhub_authorization_rule" "eventhub_customer_adress_changed_shared_access_policy" {
    name = "pubsub"
    namespace_name = azurerm_eventhub_namespace.customer_eventhub_namespace.name
    eventhub_name = azurerm_eventhub.eventhub_customer_adress_changed.name
    resource_group_name = azurerm_resource_group.resourceGroup.name
    listen = true
    send = true 
    manage = false
}

resource "azurerm_key_vault_secret" "eventhub_customer_adress_changed_sas_connectionstring" {
    name = "eventhub-customer-adress-changed-sas-connectionstring"
    value = azurerm_eventhub_authorization_rule.eventhub_customer_adress_changed_shared_access_policy.primary_connection_string
    key_vault_id = azurerm_key_vault.key_vault.id
}