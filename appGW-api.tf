

resource "azurerm_api_management" "Akwa_apim" {
  name                = "akwa-apim"
  location            = "${azurerm_resource_group.Akwa.location}"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"
  publisher_name      = "Akwa"
  publisher_email     = "company@terraform.io"

  sku {
    name     = "Developer"
    capacity = 1
  }
}



resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = "${azurerm_resource_group.Akwa.name}"
  virtual_network_name = "${azurerm_virtual_network.Akwa_vn.name}"
  address_prefix       = "10.6.104.0/24"
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = "${azurerm_resource_group.Akwa.name}"
  virtual_network_name = "${azurerm_virtual_network.Akwa_vn.name}"
  address_prefix       = "10.6.200.0/24"
}

resource "azurerm_public_ip" "Akwa-app-public-ip" {
 name                = "Akwa-app-public-ip"
 resource_group_name = "${azurerm_resource_group.Akwa.name}"
 location            = "${azurerm_resource_group.Akwa.location}"
 allocation_method   = "Dynamic"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.Akwa_vn.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.Akwa_vn.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.Akwa_vn.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.Akwa_vn.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.Akwa_vn.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.Akwa_vn.name}-rqrt"
}

resource "azurerm_application_gateway" "Akwa-appgateway" {
  name                = "Akwa-appgateway"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"
  location            = "${azurerm_resource_group.Akwa.location}"

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = "${azurerm_subnet.frontend.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.Akwa-app-public-ip.id}"
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}"
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    path         = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.http_setting_name}"
  }
}

