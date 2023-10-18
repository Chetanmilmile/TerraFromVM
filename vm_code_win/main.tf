# Define your Azure provider configuration
provider "azurerm" {
  features {}
}



resource "azurerm_resource_group" "rg1" {
  name = "cloud"
  location = "westus2"
}

# Create the first virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "shivani"
  address_space       = ["10.0.0.0/16"]
  location            = "west us 1" # Change to your desired location
  resource_group_name = azurerm_resource_group.rg1.name
}

# Create the second virtual network
resource "azurerm_virtual_network" "vnet2" {
  name                = "roshani"
  address_space       = ["10.1.0.0/16"]
  location            = "West US 2" # Change to your desired location
  resource_group_name = azurerm_resource_group.rg1.name
}

# Create virtual network peering from vnet1 to vnet2
resource "azurerm_virtual_network_peering" "peer1_to_2" {
  name                      = "peer1_to_2"
  resource_group_name = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
}

# Create virtual network peering from vnet2 to vnet1
resource "azurerm_virtual_network_peering" "peer2_to_1" {
  name                      = "peer2_to_1"
  resource_group_name = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
}
