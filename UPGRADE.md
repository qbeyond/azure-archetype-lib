# Upgrades

This document includes guidelines what to do to upgrade to a new major version. If not mentioned otherwise, upgrade guides refer to the previous version.

## [Unreleased]

## [6.1.0]

### Resource types

A new policy assignment `QBY-Deny-Resource-Types` denies resource types specified via `listOfResourceTypesNotAllowed`.
The parameter `notScopes` can be used to specify scopes (subscriptions and resource groups only) where the policy
does not take effect. Make sure to provide scopes with their full resource id and resource types with their provider.

```terraform
    "msp" = {
      // ...
      archetype_id = "qby_msp"
      parameters = {
        QBY-Deny-Resource-Types = {
          listOfResourceTypesNotAllowed = [
            "Microsoft.Network/bastionHost"
          ]
          notScopes = [
            "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-resourcegroup-dev-01"
          ]
        }
      }
    }
``` 

## [6.0.0]

### VM SKUs, Locations

With this update, policies for allowed locations and VM SKUs are being assigned automatically.
Consider removing manual assignments prior to this update.

Specify allowed SKUs for `QBY-Allowed-VM-SKUs` via the parameters `additionalSKUs` (SKUs on top of default ones) and `listOfAllowedSKUs`
(erasing defaults). Specify allowed locations for `QBY-Allowed-Locations` via the parameter `listOfAllowedLocations` or leave
it empty to implicitly disable the policy set.

### Network Security

Network security policies are now set to `Deny`, so make sure that all your network resources comply with the policies,
otherwise future deployments will be denied.

A new DNS policy now enforces DNS servers on all Vnets. You must provide the enforced DNS servers:

```terraform
    "msp" = {
      // ...
      archetype_config = {
        archetype_id   = "qby_msp"
        parameters = {
          QBY-Network-Security = {
            dnsServers = ["10.40.0.68"]     # Firewall
          }
        }
      }
    }
```

## [5.0.0]

To upgrade to this version you need to add the `template_file_variables` `notScopesForQbyNetworkSecurity`. To avoid any impact set it to `notScopesForQbyNetworkSecurity = ["/providers/Microsoft.Management/managementGroups/<root_id>"]`

## [3.0.0]

### MMA to AMA

This version moves away from the Microsoft Monitoring Agent to the Azure Monitoring Agent. Therefore you need to check everything related to Monitoring eg.:

- Names of used tables
- Collected Metrics & Logs using new DCRs

To upgrade the Module itself you need to add `linuxDCRs` & `windowsDCRs` to `template_file_variables` of the CAF module call. It should include the DCRs to assign to VMs. If you don't need that, just set it to `[]`.

Furthermore you can remove the configuration of the assignments for `Deploy-VMSS-Monitoring` and `Deploy-VM-Monitoring` from the CAF module call, because these are not longer used.

### Tagging Governance

To upgrade to the new Tagging governance policy initiative, remote the `tags` property of `template_file_variables` and add a map of bools as `inherited_required_tags`, where the key is the tag name and the value is wether this tag is required (`true`) or only inherited (`false`).


### Update Management

The archetype `qby_msp` includes everything needed to update WIndows VMs thanks to the policy initiative `QBY-Deploy-Update-Mgmt`. Therefore any other Update configuration should be deleted, when using this new version (eg. module `qbeyond/update-management/azurerm`).

The Update Management Initiative requires to set at least the `managementSubscriptionId` of the assignment. For any management group using the archetype `qby_msp` add it like this:

```terraform
    "msp" = {
        // ...
      archetype_config = {
        archetype_id   = "qby_msp"
        parameters     = {
          QBY-Deploy-Update-Mgmt = {
            managementSubscriptionId = "1234-12321432-12312432-123234"
          }
        }
      }
    }
```

The Initiative denys Vms & Arc machines without `Update Allowed=yes` tag on default. To reduce the impact of the policy, the effect of this policy can be set to `Audit`.
