# Network Security Policy Set

This Network Security Policy Set forces NSG's to have a rule that denys all inbound traffic in Vnet. It also ensures all subnets to have an matching NSG with their Vnet in name associated. Furthermore, it verifies that the DNS server assigned to a Vnet matches the ip of the firewall deployed.
Exemptions are made for subnets that are named "AzureFirewallSubnet", "RouteServerSubnet", "GatewaySubnet" and "AzureBastionSubnet"

The Rule that denys all inbound Traffic is checked based on following Properties:
- direction                   = "Inbound"
- access                      = "Deny"
- protocol                    = "*"
- source_port_range           = "*"
- destination_port_range      = "*"
- source_address_prefix       = "<Address space of vNet>"
- destination_address_prefix  = "<Address space of vNet>"

## Restrictions that come with this Set
### Inline creation subnet and vnet

The NSG association is a dedicated resource that is applied by Terraform after creating the subnet. See also this [Terraform Issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/9022)

Therefore the subnet has to be created inline with the vnet, eg. like this:

```terraform
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
```

### Deny Rule

A fitting Rule for a subnet of a vNet with the address space `10.0.0.0/16` could look like this:

```terraform
security_rule {   
  name                        = "DenyAllInboundTraffic"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/16"
  destination_address_prefix  = "10.0.0.0/16"
}
```

## Naminconventions that get enforced

### Virtual Subnets

#### Limitations
| Description              | Value            |
|--------------------------|-----------------|
| Maximum number of characters  | 2-80            |
| Allowed characters      | - (hyphen)      |
| Special considerations           | The following names are predefined by Microsoft and differ from the q.beyond standard: "GatewaySubnet" "AzureBastionSubnet" "AzureFirewallSubnet" "RouteServerSubnet" |


#### Structure
|Resource type|Delimiter (hyphen)|Network range (Network + Mask)|Delimiter (hyphen)|Purpose|
|-------------|---------------------|------------------------|---------------------|---------------|
|snet         |-                    |10-178-0-64-28          |-                    |Storage        |
|snet         |-                    |192-168-10-96-28        |-                    |Hana           |
|snet         |-                    |10-10-10-128-28         |-                    |AzureNetAppFiles|

#### Description of the options
|   | Description | Regulation | Options | Length | Data type |
|---|--------------|----------|----------|-------|----------|
| Resource type | The specified string "snet" indicates that it is a virtual subnet. | lower case | snet | 4 |  &lt;string&gt; |
| Delimiter | | | | - | 1 | hyphen |
| Network range (Network + Mask) | This value logically represents "the contained subnet". The characters "." (dot) and "/" (Slash) are replaced by "-" (hyphen) | No spaces<br>Only numbers and hyphen |  &lt;IP address range&gt;-<br> &lt;Mask&gt; | 9-19 |  &lt;string&gt; |
| Delimiter | | | | - | 1 | hyphen |
| Purpose | This value describes the type of resources contained in this subnet. | Capitalize first letter<br>No spaces |  &lt;Purpose&gt; | 48 |  &lt;string&gt; |


##### Network range (Network + Mask)
| Original network range identifier | Azure vNet identifier |
|-------------------------------|----------------------|
| 10.178.0.64/28                | 10-178-0-64-28       |


### virtual Networks

#### Limits
| allowed characters | alphanumeric hyphen |
|--------------------|---------------------|
| Length             | 2-64                |
| Restrictions       |                     |
| Unique in scope    | Resource group      |

#### Structure
| Identifier | Delimiter |       CIDR      | Delimiter (Optional) | VLAN ID (Optional) | Delimiter |   region   |
|----------|---------|---------------|--------------------|------------------|---------|----------|
| vnet       | -         | 10-178-0-0-15   | -                    | VL1887             | -         | westeurope |
| vnet       | -         | 192-168-10-0-16 | -                    | VL4711             | -         | uksouth    |
| vnet       | -         | 10-10-10-0-16   | -                    | VL1125             | -         | eastus     |

#### Description of the options
|  | Description | Restrictions | Choice | Length | Data type |
|---|---|---|---|---|---|
| Identifier | Its a vnet | lower case | vnet | 4 | &lt;string&gt; |
| Delimiter |  |  | - | 1 | &lt;hyphen&gt; |
| CIDR | This value represent the entire containing network.<br>Please replace "." (dot) and "/" (Slash) by "-" (hyphen) <br><br>CIDR Address<br>Azure vNet Value<br>10.178.0.0/15<br>10-178-0-0-15 | no spaces<br>only numbers and hyphen | &lt;IP-Subnet&gt;-&lt;Mask&gt; | 9-19 | &lt;int32&gt; |
| CIDR Address | Azure vNet Value |  | - | 1 | &lt;hyphen&gt; |
| 10.178.0.0/15 | 10-178-0-0-15 | lower case<br>"vl" Identifier first | vl&lt;ID&gt; | 6 | &lt;string&gt; |
| Delimiter<br>(Optional) | Only if a VLAN ID is named |  | - | 1 | &lt;hyphen&gt; |
| VLAN ID<br>(Optional) | When a VLAN ID must be named.<br>The Value "vl" represents "V"irtual "L"an ID. | lower case<br>"vl" Identifier first | vl&lt;ID&gt; | 6 | &lt;string&gt; |
| Delimiter |  |  |  | 1 | &lt;hyphen&gt; |
| region | The region in of the virtual network. | lower case<br>see Azure Region codes | eastasia<br>southeastasia<br>centralus<br>eastus<br>eastus2<br>westus<br>northcentralus<br>southcentralus<br>westeurope<br>japaneast<br>australiaeast<br>southindia<br>westindia<br>canadaeast<br>uksouth<br>ukwest<br>westcentralus<br>westus2<br>koreacentral<br>koreasouth<br>francecentral<br>francesouth<br>australiacentral<br>australiacentral2<br>uaecentral<br>uaenorth<br>southafricanorth<br>southafricawest<br>switzerlandnorth<br>switzerlandwest<br>germanynorth<br>germanywestcentral<br>norwaywest<br>norwayeast | 6-18 | &lt;hyphen&gt; |

### Network Security Groups

#### Limits
| Length | 1-80 |
|---|---|
| allowed characters | alphanumeric<br>underscores<br>periods<br>hyphen |
| Restrictions | Start with alphanumeric<br>End with alphanumeric or underscore |
| Unique in scope | Resource Group |

#### Structure
| Identifier | Delimiter | name of applied resource |
|---|---|---|
| nsg | - | vnet-10-178-0-0-15-westeurope |
| nsg | - | vnet-192-168-10-0-16-uksouth |
| nsg | - | vnet-10-10-10-0-16-eastus |

#### Description of the Options
|  | Description | Restrictions | Choice | Length | Data type |
|---|---|---|---|---|---|
| Identifier | This identifies the Resource | lower case | nsg | 3 | &lt;string&gt; |
| Delimiter |  |  | - | 1 | hyphen |
| name of applied resource | Name of applied resource<br>See restrictions for naming conventions | name of vNET |  | 2-64 | &lt;string&gt; |