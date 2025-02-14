provider "azurerm" {
  features {}
  subscription_id = "4b236e6d-2c9a-4cb2-90a2-30a5377d8eb2"
}

# main.tf
data "azurerm_resource_group" "main" {
name = "azuredevops"
}


data "azurerm_subnet" "main" {
name = "default"
resource_group_name = data.azurerm_resource_group.main.name
virtual_network_name = "azure-network"
}





# Network Interface for the new Spot VM
resource "azurerm_network_interface" "main" {
name = "my-new-nic"  # Change the NIC name
location = data.azurerm_resource_group.main.location
resource_group_name = data.azurerm_resource_group.main.name

ip_configuration {
name = "internal"
subnet_id = "/subscriptions/4b236e6d-2c9a-4cb2-90a2-30a5377d8eb2/resourceGroups/azuredevops/providers/Microsoft.Network/virtualNetworks/azure-network/subnets/default"  # Replace with your subnet ID
private_ip_address_allocation = "Dynamic"
}
}

# New Spot VM
resource "azurerm_linux_virtual_machine" "main" {
name = "test-vm"  # Change the VM name
location = data.azurerm_resource_group.main.location
resource_group_name = data.azurerm_resource_group.main.name
size = "Standard_DS1_v2"  # Replace with your desired VM size
admin_username = "centos"        # Replace with your admin username
network_interface_ids = [azurerm_network_interface.main.id]

os_profile {
computer_name = test-vm
admin_username = centos
admin_password = "Adminadmin1234$"
}

os_disk {
name = "my-new-spot-vm-osdisk"  # Change the OS disk name
caching = "ReadWrite"
create_option = "FromImage"
storage_account_type = "Standard_LRS"
}

storage_image_reference {
id = "/subscriptions/4b236e6d-2c9a-4cb2-90a2-30a5377d8eb2/resourceGroups/azuredevops/providers/Microsoft.Compute/galleries/azawsdevops/images/azawsdevops/versions/1.0.0"
}

priority = "Spot"  # This makes it a Spot VM
eviction_policy = "Deallocate"  # Set the eviction policy (optional)
}

