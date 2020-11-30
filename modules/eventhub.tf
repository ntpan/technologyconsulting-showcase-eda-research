resource "azurerm_eventhub_namespace" "customer_eventhub_namespace" {
    name = "tc-eda-iac-${var.environment}-customer-eventhub"
    location = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
    sku = "Standard"
    capacity = 1
}

resource "azurerm_eventhub" "eventhub_customer_changed" {
    name = "customerchanged"
    namespace_name = azurerm_eventhub_namespace.customer_eventhub_namespace.name
    resource_group_name = azurerm_resource_group.resourceGroup.name
    partition_count = 2
    message_retention = 1

    capture_description {
      enabled = true
      encoding = "Avro"

        destination {
            name = "EventHubArchive.AzureBlockBlob"
            archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}-{Month}-{Day}T{Hour}:{Minute}:{Second}"
            blob_container_name = azurerm_storage_container.storage_container_eventhub.name
            storage_account_id  = azurerm_storage_account.storage_account.id
        }
    }
}

resource "azurerm_eventhub_authorization_rule" "eventhub_customer_changed_shared_access_policy" {
    name = "pubsub"
    namespace_name = azurerm_eventhub_namespace.customer_eventhub_namespace.name
    eventhub_name = azurerm_eventhub.eventhub_customer_changed.name
    resource_group_name = azurerm_resource_group.resourceGroup.name
    listen = true
    send = true 
    manage = false
}

resource "azurerm_key_vault_secret" "eventhub_customer_changed_sas_connectionstring" {
    name = "EVENTHUBCUSTOMERCHANGEDSASCONNECTIONSTRING"
    value = azurerm_eventhub_authorization_rule.eventhub_customer_changed_shared_access_policy.primary_connection_string
    key_vault_id = azurerm_key_vault.key_vault.id
}
