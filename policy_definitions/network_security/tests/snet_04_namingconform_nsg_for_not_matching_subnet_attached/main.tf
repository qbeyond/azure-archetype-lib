#Expected by Policy Definition to detect, that the nsg might be the correct naming format, but does not match the Vnet name
#Expect Deployment to not work

resource "azurerm_resource_group" "this" {
    name     = "rg-TestingPoliciesNetworkSecuritySnet-tst-04"
    location = "West Europe"
}

resource "azurerm_network_security_group" "this" {
    name                = "nsg-vnet-10-23-0-0-16-TestingPolicies"
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
    name           = "snet-10-0-1-0-24-TestingPolicies1"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.this.id
  }
    subnet {
    name           = "snet-10-0-2-0-24-TestingPolicies2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.this.id
  }
}