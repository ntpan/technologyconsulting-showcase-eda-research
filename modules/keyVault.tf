resource "azurerm_key_vault" "key_vault" {
  name                = "tcedaiacvault${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  enabled_for_disk_encryption = true
}

#Terraform for secret creation
resource "azurerm_key_vault_access_policy" "key_vault_terraform_access_policy" {
    key_vault_id = azurerm_key_vault.key_vault.id
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [ "delete", "get", "set", "list" ]
  }

# PA TC
resource "azurerm_key_vault_access_policy" "key_vault_pa_tc_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = "3f17a18b-59fc-4c13-a6d2-5852c4d8312a"

  secret_permissions = ["delete", "get", "set", "list"]
}

# Producer FaaS 
resource "azurerm_key_vault_access_policy" "key_vault_producer_function_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_function_app.customer_function_producer.identity[0].principal_id

  secret_permissions = ["delete", "get", "set", "list"]
}

# Consumer FaaS 
resource "azurerm_key_vault_access_policy" "key_vault_consumer_function_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_function_app.customer_function_consumer.identity[0].principal_id

  secret_permissions = ["delete", "get", "set", "list"]
}
