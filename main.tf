provider "azurerm" {
    subscription_id = "5XXXXXXXXXXXXXXXX"
   features{}
}

resource "azurerm_resource_group" "rg-ops" {
  name     = "rg-we-ops"
  location = "North Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet-ops" {
  name                = "vnet-we-ops"
  resource_group_name = azurerm_resource_group.rg-ops.name
  location            = azurerm_resource_group.rg-ops.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sub-ops" {
  name                 = "sub-ops"
  resource_group_name  = azurerm_resource_group.rg-ops.name
  virtual_network_name = azurerm_virtual_network.vnet-ops.name
  address_prefixes       = ["10.0.2.0/24",]
}

resource "azurerm_network_interface" "nic-ops" {
  name                = "nic-we-ops"
  location            = azurerm_resource_group.rg-ops.location
  resource_group_name = azurerm_resource_group.rg-ops.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-ops.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = azurerm_public_ip.pip-ops.id
  }
}

  resource "azurerm_public_ip" "pip-ops" {
  name                = "pip-we-ops"
  resource_group_name = azurerm_resource_group.rg-ops.name
  location            = azurerm_resource_group.rg-ops.location
  allocation_method   = "Static"
  }


resource "azurerm_windows_virtual_machine" "vm-ops" {
  name                = "vm-we-ops"
  resource_group_name = azurerm_resource_group.rg-ops.name
  location            = azurerm_resource_group.rg-ops.location
  size                = "Standard_F2"
  admin_username      = "mahesh"
  admin_password      = "XXXXXXXXXX"
  network_interface_ids = [
    azurerm_network_interface.nic-ops.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

