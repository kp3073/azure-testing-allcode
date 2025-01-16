provider "azurerm" {
  features {}
  subscription_id = "4b236e6d-2c9a-4cb2-90a2-30a5377d8eb2"
}

data "azurerm_resource_group" "main" {
  name = "azuredevops"
}

data "azurerm_subnet" "main" {
  name                 = "default"
  virtual_network_name = "azure-network"
  resource_group_name  = data.azurerm_resource_group.main.name
}



resource "azurerm_kubernetes_cluster" "main" {
  name                = "k8s-cluster"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix          = "cluster"

  default_node_pool {
	name       = "default"
	node_count = 1
	vm_size    = "Standard_D2_v2"
  }

  identity {
	type = "SystemAssigned" 
	
  }

  tags = {
	Environment = "Production"
  }
}

