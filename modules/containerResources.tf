resource "azurerm_container_registry" "container_registry" {
    name = "TcEdaIac${var.environment}ContainerRegistry"
    location = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
    admin_enabled = true
    sku = "Standard"
}
