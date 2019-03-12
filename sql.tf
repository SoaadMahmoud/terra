resource "azurerm_sql_server" "akwasql" {
  name                         = "akwasql"
  resource_group_name          = "${azurerm_resource_group.Akwa.name}"
  location                     = "${azurerm_resource_group.Akwa.location}"
  version                      = "12.0"
  administrator_login          = "admin"
  administrator_login_password = "P@$$w0rd"
}

resource "azurerm_sql_database" "akwasqldb" {
  name                = "akwasqldb"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"
  location            = "${azurerm_resource_group.Akwa.location}"
  server_name         = "${azurerm_sql_server.akwasql.name}"

  tags = {
    environment = "production"
  }
}
