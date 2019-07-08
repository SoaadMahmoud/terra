resource "azurerm_log_analytics_workspace" "Akwa" {
  name                = "Akwa-security-workspace"
  location            = "${azurerm_resource_group.Akwa.location}"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"
  sku                 = "PerGB2018"
}

resource "azurerm_security_center_workspace" "Akwa" {
  scope        = "/subscriptions/00000000-0000-0000-0000-000000000000"
  workspace_id = "${azurerm_log_analytics_workspace.Akwa.id}"
}
