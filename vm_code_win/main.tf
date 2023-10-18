# Define your Azure provider configuration
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg1" {
  name = "HUB_RG_OG"
  location = "westus"
}

# Create the first virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "ram"
  address_space       = ["10.0.0.0/16"]
  location            = "west US" # Change to your desired location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "rg2-subnet-1" {
  name = "SPOKE-app-subnet-OG"
  resource_group_name = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.rg2.name
  address_prefixes = ["10.0.2.0/24"]
}


resource "azurerm_resource_group" "rg2" {
  name = "SPOKE_RG_AG"
  location = "westus"
}

# Create the second virtual network
resource "azurerm_virtual_network" "vnet2" {
  name                = "sham"
  address_space       = ["10.1.0.0/16"]
  location            = "West US" # Change to your desired location
  resource_group_name = azurerm_resource_group.rg2.name
}

resource "azurerm_subnet" "rg2-subnet-2" {
  name = "SPOKE-DB-subnet-1-AG"
  resource_group_name = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.rg2.name
  address_prefixes = ["10.0.3.0/24"]
}


resource "azurerm_subnet" "rg2-subnet-2" {
  name = "SPOKE-DB-subnet-2-AG"
  resource_group_name = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.rg2.name
  address_prefixes = ["10.0.3.0/24"]
}


# Create virtual network peering from vnet1 to vnet2
resource "azurerm_virtual_network_peering" "peer1_to_2" {
  name                      = "peer1_to_2"
  resource_group_name       = "my-resource-group"
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
}


# Create virtual network peering from vnet2 to vnet1
resource "azurerm_virtual_network_peering" "peer2_to_1" {
  name                      = "peer2_to_1"
  resource_group_name       = "my-resource-group"
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
}
