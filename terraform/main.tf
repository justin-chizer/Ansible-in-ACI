# Create a resource group
resource "azurerm_resource_group" "worker" {
  name     = var.resource_group
  location = var.region
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "worker" {
  name                = var.worker_vnet_name
  resource_group_name = azurerm_resource_group.worker.name
  location            = azurerm_resource_group.worker.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "worker" {
  name                 = var.worker_subnet_name
  resource_group_name  = azurerm_resource_group.worker.name
  virtual_network_name = azurerm_virtual_network.worker.name
  address_prefixes     = ["10.1.1.0/24"]

  #   delegation {
  #     name = "acctestdelegation"

  #     service_delegation {
  #       name    = "Microsoft.ContainerInstance/containerGroups"
  #       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
  #     }
  #   }
}

# Grab remote VNet
data "azurerm_virtual_network" "remote" {
  name                = var.hub_vnet_name
  resource_group_name = var.hub_resource_group
}

# Peer the VNets
resource "azurerm_virtual_network_peering" "hub" {
  name                      = "hubtoworker-1"
  resource_group_name       = var.hub_resource_group
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.worker.id
}

resource "azurerm_virtual_network_peering" "worker" {
  name                      = "worker-1tohub"
  resource_group_name       = azurerm_resource_group.worker.name
  virtual_network_name      = azurerm_virtual_network.worker.name
  remote_virtual_network_id = data.azurerm_virtual_network.remote.id
}

resource "azurerm_network_interface" "worker" {
  name                = "worker-nic"
  location            = azurerm_resource_group.worker.location
  resource_group_name = azurerm_resource_group.worker.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.worker.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "worker" {
  name                            = var.worker_vm
  resource_group_name             = azurerm_resource_group.worker.name
  location                        = azurerm_resource_group.worker.location
  size                            = "Standard_D2ds_v4"
  admin_username                  = "azureuser"
  admin_password                  = "Password123!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.worker.id,
  ]

  #   admin_ssh_key {
  #     username   = "adminuser"
  #     public_key = file("~/.ssh/id_rsa.pub")
  #   }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }
}
