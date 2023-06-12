# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "juiceshop_network" {
  name                = "juiceshop_network"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["192.168.0.0/16"]
}


# Create a subnet for AKS to use in network created above
resource "azurerm_subnet" "juiceshop_subnet_aks" {
  name                 = "juiceshop_aks_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.juiceshop_network.name
  address_prefixes     = ["192.168.2.0/24"]
}

# Create a internal subnet for jumphosts and management in network created above
resource "azurerm_subnet" "juiceshop_subnet_jumphosts" {
  name                 = "juiceshop_jumphosts_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.juiceshop_network.name
  address_prefixes     = ["192.168.4.0/24"]
}

output "subnet" {
  value = azurerm_subnet.juiceshop_subnet_aks.id
}