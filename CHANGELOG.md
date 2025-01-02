# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this module adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- note: an upcoming release should consider turning 5.2.0 into a major version
by changing the DNS policy mode to `Deny`. This ensures that no VNet can be deployed
without the Firewall as its primary DNS server

## [5.2.0]

### Added
- added network security policy that enforces a particular DNS server
(should be the firewall's ip address) on all vnets
- note: this feature currently runs in `Audit` mode and will result in
a breaking change once turned into a `Deny` policy

## [5.1.0]

### Added
- changed the 6 default Microsoft policies to one big policy for AMA deployment
- added proxy parameter to the new AMA policy
- note: not providing the proxy parameter will result in the default AMA installation

### Fixed
- the virtual network resource id of the private dns assignment needs default param

## [5.0.0]

### Added

- added policy set for network Security. 
- `template_file_variable` `notScopesForQbyNetworkSecurity` is required
- fixed mapping of update classifications

## [4.0.3]

### Fixed

- fixed mapping of update classifications

## [4.0.2]

### Fixed

- Non compliance of VMs even if the Dependency Agent is correctly installed

## [4.0.1]

### Fixed

- fixed virtualNetworkLink name generation by removing wrongly inserted square bracket


## [4.0.0]

### Changed

- changed type of parameter `virtualNetworkResourceId` from array to string, because multiple Ids weren't working and used anyway. Use multiple policy assignments instead.

## [3.1.0]

### Added

- Policy that automatically creates Private DNS Zone Virtual Network Links to a list of given Virtual Networks

## [3.0.0]

### Added

- Initiative deploying new Azure Monitoring Agent and associating data collection rules
- added policy set for Azure Update Manager
- Added require tags policy set defitions and assignment
- Policy definition to allow vm/vmss SKUs

### Removed

- Policies deploying the old Microsoft Monitoring Agent

## [2.3.0] - 2024-01-12

### Added

- Added Audit-AzureHybridBenefit to root policy defitions

## [2.2.0] - 2024-01-10

### Added

- Added deploy log analytics policy

## [2.1.1] - 2023-12-28

- Renamed tagging policy assignment

## [2.1.0] - 2023-12-18

### Added

- Added tag inheritance policy setup

## [2.0.0] - 2023-12-13

Automatic domain join of windows assigned

## [1.2.0] - 2023-11-28

Automatic domain join of windows vms can be enabled

### Added

- Added policy for automatic domain join of windows vms.

## [1.1.2] - 2023-07-18

Add QBY Backup Policy

### Added

- Add QBY Backup Policy
