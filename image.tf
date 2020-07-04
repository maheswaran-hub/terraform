data "azurerm_image" "image" {
  name                = "VMSSImage05"
  resource_group_name = "vmss"
}

resource "azurerm_network_interface" "nic1-ops" {
  name                = "nic1-we-ops"
  location            = azurerm_resource_group.rg-ops.location
  resource_group_name = azurerm_resource_group.rg-ops.name

  ip_configuration {
    name                          = "internal1"
    subnet_id                     = azurerm_subnet.sub-ops.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = azurerm_public_ip.pip1-ops.id
  }
}

  resource "azurerm_public_ip" "pip1-ops" {
  name                = "pip1-we-ops"
  resource_group_name = azurerm_resource_group.rg-ops.name
  location            = azurerm_resource_group.rg-ops.location
  allocation_method   = "Static"
  }

resource "azurerm_windows_virtual_machine" "vm1-ops" {
  name                             = "vm1-ops"
  resource_group_name              = azurerm_resource_group.rg-ops.name
  location                         = azurerm_resource_group.rg-ops.location
  admin_username                   = "XXXXXXXXX"
  admin_password                   = "XXXXXXXXX"
  network_interface_ids            = [azurerm_network_interface.nic1-ops.id,]
  size                             = "Standard_F2"

os_disk {
    name                 = "vm1-ops-image-os1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 source_image_id = data.azurerm_image.image.id

}