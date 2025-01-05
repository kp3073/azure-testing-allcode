provider "azurerm" {
  features {}
  subscription_id = "4b236e6d-2c9a-4cb2-90a2-30a5377d8eb2"
}



module "vm" {
  for_each = var.tool
  source = "./vm"
  component = each.key
  port = each.value["port"]
  
}

variable "tool" {
  default = {
	vault = {
	  port = 8200
	}
  }
}

#variables


terraform {
  backend "azurerm" {
	resource_group_name = "azuredevops"
	# Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
	storage_account_name = "cloudawsaz"
	# Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
	container_name = "terraform-tool"
	# Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
	key = "terraform.tfstate"
	# Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}
