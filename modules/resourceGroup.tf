resource "azurerm_resource_group" "resourceGroup" {
        name = "tc-showcase-edaresearch-${var.environment}"
        location = var.location
}
