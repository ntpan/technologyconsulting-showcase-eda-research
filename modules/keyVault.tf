resource "azurerm_key_vault" "key_vault" {
  name                = "tcedaiacvault${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enabled_for_disk_encryption = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [ "delete", "get", "set", "list" ]
  }
}
