provider "azurerm" {
    subscription_id = "5bb36135-9d20-4a00-98d5-978abc51796e"
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
