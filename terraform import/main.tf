provider "azurerm" {
  features {}
  subscription_id = "4b236e6d-2c9a-4cb2-90a2-30a5377d8eb2"
}
# 
# resource "azurerm_linux_virtual_machine" "example" {
#   name                = "workstation"
#   location            = "UK West"
#   resource_group_name = "AZUREDEVOPS"
#   size                = "Standard_D2s_v3"
#   admin_username      = "centos"
#   admin_password      = "Adminadmin1234$"
# 
#   priority        = "Spot"
#   eviction_policy = "Deallocate"
#   max_bid_price   = -1  # Pay up to the standard VM price
# 
#   os_profile_linux_config {
#     disable_password_authentication = false
#   }
# 
#   network_interface_ids = ["<NetworkInterfaceID>"]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
# }


resource "azurerm_virtual_machine" "existing_vm" {
  # Placeholder for the VM configuration
}