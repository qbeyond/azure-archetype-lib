#Expected by Policy Definition to detect, that a non namingconform nsg is attached to the subnet
#Expect Deployment to not work

resource "azurerm_resource_group" "this" {
    name     = "rg-TestingPoliciesNetworkSecuritySnet-tst-03"
    location = "West Europe"
}

resource "azurerm_network_security_group" "this" {
    name                = "nsg-10-0-subscriptionname-WrongNamingConvention-TestingPolicies"
    location            = azurerm_resource_group.this.location
    resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "this" {
    name                        = "DenyAllTraffic"
    priority                    = 4096
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "10.0.0.0/16"
    destination_address_prefix  = "10.0.0.0/16"
    resource_group_name         = azurerm_network_security_group.this.resource_group_name
    network_security_group_name = azurerm_network_security_group.this.name
}
resource "azurerm_network_security_group" "this" {
    name                = "nsg-vnet-10-0-0-0-16-subscriptionname-TestingPolicies"
    location            = azurerm_resource_group.this.location
    resource_group_name = azurerm_resource_group.this.name
        security_rule {   
        name                        = "DenyAllTraffic"
        priority                    = 4096
        direction                   = "Inbound"
        access                      = "Deny"
        protocol                    = "*"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "10.0.0.0/16"
        destination_address_prefix  = "10.0.0.0/16"
    }
}
resource "azurerm_virtual_network" "this" {
    name                = "vnet-10-0-0-0-16-westeurope"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.this.location
    resource_group_name = azurerm_resource_group.this.name

  subnet {
    name           = "snet-10-0-1-0-24-TestingPolicies"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.this.id
  }
}