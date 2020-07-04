provider "azurerm" {
    subscription_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
   features{}
}
resource "azurerm_resource_group" "rg" {
  name     = "RG-${var.regcode}-${var.env}-${var.rgname[count.index]}"
  location = var.location
  count = var.dccount[0]
  tags = {
   environment = var.env
 }
}
