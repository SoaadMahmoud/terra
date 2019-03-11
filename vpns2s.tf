

resource "azurerm_resource_group" "Akwa" {
  name     = "Akwa"
  location = "West Europe"
}

resource "azurerm_virtual_network" "Akwa_vn" {
  name                = "Akwa_vn"
  location            = "${azurerm_resource_group.Akwa.location}"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"
  address_space       = ["10.6.0.0/16"]
}

resource "azurerm_subnet" "vpn-GWsbnt" {
  name                 = "vpn-GWsbnt"
  resource_group_name  = "${azurerm_resource_group.Akwa.name}"
  virtual_network_name = "${azurerm_virtual_network.Akwa_vn.name}"
  address_prefix       = "10.6.100.0/24"
}

resource "azurerm_local_network_gateway" "Akwa" {
  name                = "Akwa"
  location            = "${azurerm_resource_group.Akwa.location}"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"
  gateway_address     = "197.230.1.98"
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_public_ip" "Akwa-vpn-public-ip" {
  name                = "Akwa"
  location            = "${azurerm_resource_group.Akwa.location}"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "Akwavpn" {
  name                = "Akwavpn"
  location            = "${azurerm_resource_group.Akwa.location}"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    public_ip_address_id          = "${azurerm_public_ip.Akwa-vpn-public-ip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.vpn-GWsbnt.id}"
  }
}

resource "azurerm_virtual_network_gateway_connection" "Akwa" {
  name                = "Akwa"
  location            = "${azurerm_resource_group.Akwa.location}"
  resource_group_name = "${azurerm_resource_group.Akwa.name}"

  type                       = "IPsec"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.Akwavpn.id}"
  local_network_gateway_id   = "${azurerm_local_network_gateway.Akwa.id}"

  shared_key = "D5WWuSMJi/5hf7GF15lZuG85+zW5t7Wu"
}
