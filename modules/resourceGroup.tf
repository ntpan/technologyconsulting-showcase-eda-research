resource "azurerm_resource_group" "resourceGroup" {
        name = "tc-eda-iac-${var.environment}"
        location = var.location
}
