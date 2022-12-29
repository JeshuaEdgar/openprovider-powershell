# Changelog

## [Unreleased]

### Added

- Much improved error handling for requests, will return OpenProvider error code that you can reference to instead of generic failures. [(reference)](https://support.openprovider.eu/hc/en-us/articles/216644928-API-Error-Codes)
- Sanbox connectivity!
- Validation of created nameserver in ```Add-OPNameserver```
- Added ```$true``` outputs for all Get, Set and Remove commands when completed succesfully for logic.
- ```[CmdletBinding()]``` to every function for common parameters.

### Fixed

- Fixed an error when adding a body to a Get request in PowerShell 5.1 (```New-QuerryString```)

### Changed

- ```Connect-OpenProvider``` now uses ```Invoke-OPRequest```
- Prettier outputs for all commands that return information (```Get-OP*```)
- ```Get-OPZone``` now takes an optional ```-Provider``` parameter instead of a clunky Zone ID.
- ```Update-OPZone``` parameter ```-IsSpamexpertsEnabled``` is now ```-EnableSpamExperts```
- ```Get-OPDomainDetails``` is now ```Get-OPDomain -Detailed```

## Removed

- ```Update-OPZone``` - removed because function is obsolete. ```New-OPZoneRecord``` uses same endpoint and has similar functionality.

## [v1.0.2]

### Fixed

- JSON bugfix for Invoke-OPRequest.
- Fixed disconnection.
- Prevented unnecessary authentication with API when credentials are invalid.

### Changed

- Refactored Get-OPDomain to return a custom object for more readability.

## [v1.0.1]

### Fixed

- Various bugfixes for error handling

## [v1.0.0]

### Added

- Create, update and delete DNS records
- Create, update and delete Nameservers
- Get domain details from existing domains and get availability for new domains!
