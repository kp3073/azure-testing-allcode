resource "azurerm_network_interface" "main" {
  name                = hc-nic
  location            = "West Uk"
  resource_group_name = "azuredevops"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}
resource "azurerm_virtual_machine" "spot_vm" {
  name                = "hcl2"
  location            = "West Uk"
  resource_group_name = "azuredevops"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size             = "Standard_D2s_v3"

  priority        = "Spot"
  eviction_policy = "Deallocate"

  os_profile {
	computer_name  = "MySpotVM"
	admin_username = "adminuser"
	admin_password = "P@ssword123!"
  }

  os_profile_linux_config {
	disable_password_authentication = false
  }

  storage_os_disk {
	name              = "MySpotVM_OSDisk"
	caching           = "ReadWrite"
	create_option     = "FromImage"
	managed_disk_type = "Premium_LRS"
  }

  source_image_reference {
	id = "/subscriptions/4b236e6d-2c9a-4cb2-90a2-30a5377d8eb2/resourceGroups/azuredevops/providers/Microsoft.Network/networkInterfaces/hcl231"
  }
}
