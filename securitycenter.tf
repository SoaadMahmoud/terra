resource "azurerm_log_analytics_workspace" "example" {
  name                = "tfex-security-workspace"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  sku                 = "PerGB2018"
}

resource "azurerm_security_center_workspace" "example" {
  scope        = "/subscriptions/00000000-0000-0000-0000-000000000000"
  workspace_id = "${azurerm_log_analytics_workspace.example.id}"
}
