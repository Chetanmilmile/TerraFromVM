# Resource Group 1 - Hub
# Resource Group 2 Spoke

terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name = "HUB_RG"
  location = "eastus2"
}

resource "azurerm_virtual_network" "rg1-vnet-1" {
  name = "HUB-vnet-1"
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "rg1-subnet-1" {
  name = "HUB-wan-subnet"
  resource_group_name = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.rg1-vnet-1.name
  address_prefixes = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "rg1-subnet-2" {
  name = "HUB-lan-subnet"
  resource_group_name = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.rg1-vnet-1.name
  address_prefixes = ["10.0.2.0/24"]
}



resource "azurerm_resource_group" "rg2" {
  name = "SPOKE_RG"
  location = "eastus2"
}


resource "azurerm_virtual_network" "rg2-vnet-1" {
  name = "SPOKE-app-vnet"
  location = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  address_space = ["192.168.0.0/24"]
}

resource "azurerm_subnet" "rg2-subnet-1" {
  name = "SPOKE-app-subnet"
  resource_group_name = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.rg2-vnet-1.name
  address_prefixes = ["192.168.0.0/25"]
}

resource "azurerm_virtual_network" "rg2-vnet-2" {
  name = "SPOKE-DB-vnet"
  location = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "rg2-subnet-2" {
  name = "SPOKE-DB-subnet-1"
  resource_group_name = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.rg2-vnet-2.name
  address_prefixes = ["10.0.3.0/24"]
}
/* 
resource "azurerm_virtual_network_peering" "vnet_peering" {
  name = "vnet_peering"
  resource_group_name = "rg1"
  remote_virtual_network_id = azurerm_virtual_network.rg2-vnet-1.id
  allow_virtual_network_access = true
} */
