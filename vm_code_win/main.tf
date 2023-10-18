# Define your Azure provider configuration
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg1" {
  name = "HUB_RG_OU"
  location = "westus"
}
# Create the first virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "HUB-RG-VNET"
  address_space       = ["10.0.0.0/16"]
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "rg1-subnet-1" {
  name = "HUB-wan-subnet"
  resource_group_name = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.rg1.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "rg1-subnet-1" {
  name = "HUB-lan-subnet"
  resource_group_name = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.rg1.name
  address_prefixes = ["10.0.1.0/24"]
}



resource "azurerm_resource_group" "rg2" {
  name = "SPOKE_RG_OU"
  location = "westus"
}


# Create the second virtual network
resource "azurerm_virtual_network" "vnet2" {
  name                = "SPOKE-VNET-APP"
  address_space       = ["10.1.0.0/16"]
  location = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
}

resource "azurerm_subnet" "rg2-subnet-1" {
  name = "SPOKE-app-subnet"
  resource_group_name = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.rg2.name
  address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network" "vnet3" {
  name                = "SPOKE-VNET-DB"
  address_space       = ["10.1.0.0/16"]
  location = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
}

resource "azurerm_subnet" "rg2-subnet-2" {
  name = "SPOKE-db-subnet"
  resource_group_name = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.rg2.name
  address_prefixes = ["10.0.2.0/24"]
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
resource "azurerm_virtual_network_peering" "peer1_to_3" {
  name                      = "peer1_to_3"
  resource_group_name       = "my-resource-group"
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet3.id
  allow_virtual_network_access = true
}

# Create virtual network peering from vnet2 to vnet1
resource "azurerm_virtual_network_peering" "peer3_to_1" {
  name                      = "peer3_to_1"
  resource_group_name       = "my-resource-group"
  virtual_network_name      = azurerm_virtual_network.vnet3.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
}
