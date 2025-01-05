provider "azurerm" {
  features {}
  subscription_id = "4b236e6d-2c9a-4cb2-90a2-30a5377d8eb2"
}


data "azurerm_resource_group" "main" {
  name = "azuredevops"
}


data "azurerm_subnet" "main" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = "azure-network"
}

variable "component" {
  default = "test"
}


resource "azurerm_public_ip" "main" {
  name                = var.component
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
  sku = "Basic"
  tags = {
	environment = var.component
  }
}

resource "azurerm_network_security_group" "main" {
  name                = var.component
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
	name                       = "ssh"
	priority                   = 100
	direction                  = "Inbound"
	access                     = "Allow"
	protocol                   = "Tcp"
	source_port_range          = "*"
	destination_port_range     = "*"
	source_address_prefix      = "*"
	destination_address_prefix = "*"
  }
  
  
  tags = {
	environment = var.component
  }
}

resource "azurerm_network_interface" "main" {
  name                = var.component
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
	name                          = "internal"
	subnet_id                     = data.azurerm_subnet.main.id
	private_ip_address_allocation = "Dynamic"
	public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_dns_a_record" "private" {
  name                = "${ var.component }-internal"
  zone_name           = "cloudaws.shop"
  resource_group_name = data.azurerm_resource_group.main.name
  ttl                 = 10
  records             =  [azurerm_network_interface.main.private_ip_address]
}

resource "azurerm_dns_a_record" "public" {
  depends_on = [azurerm_public_ip.main]
  name                = var.component
  zone_name           = "cloudaws.shop"
  resource_group_name = data.azurerm_resource_group.main.name
  ttl                 = 10
  records = [azurerm_public_ip.main.ip_address]
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                = "Standard_DS1_v2"
  admin_username = "adminuser"

  priority        = "Spot"
  eviction_policy = "Deallocate" # or "Delete"

  os_disk {
	name                 = "example-osdisk"
	caching              = "ReadWrite"
	storage_account_type = "Standard_LRS"
  }

  source_image_reference {
	publisher = "Canonical"
	offer     = "UbuntuServer"
	sku       = "18.04-LTS"
	version   = "latest"
  }


  admin_ssh_key {
	username = "adminuser"
	public_key = file("/Users/keyurpatel/.ssh/id_rsa.pub")
  }
}