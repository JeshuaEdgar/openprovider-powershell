# Changelog

## [1.4.1]

### Added

- Unit tests!

### Fixed/changed

- Refactor of multiple functions (minor updates/fixes)

## [1.4.0]

### Added

- Pipeline input for the following cmdlets:
  - ```Add-OPZoneRecord```
  - ```Set-OPZoneRecord```
  - ```Remove-OPZoneRecord```
  - ```Remove-OPZone```

For examples on how to use these new pipeline features please see the example section [here](./Examples.md)

- New cmdlets
  - ```Remove-OPZoneRecord```

### Changed
- ```Get-OPZoneRecords```
  - Is now ```Get-OPZoneRecord``` ("s" dropped to comply to PowerShell cmdlet naming)
  - When ```-Provider``` is not specified, it defaults to "openprovider"
  - ```Domain``` and ```Name``` is now seperated in the output (beforehand ```Name``` included the name + domain)
  - ```ZoneID``` is included in the output of this cmdlet (for pipelining)

- ```Set-OPZoneRecord```
  - This cmdlet now accepts a new parameter ```-Record```, ```-OriginalRecord``` and ```-NewRecord``` have been depricated.
  - Made changing a record much easier and intuitive, just define which parameters you want to change, all parameters are optional.

### Removed

- ```New-OPZoneRecordObject```

## [1.3.1]

### Fixed

- Get-OPDomain is fixed withing PowerShell 7
- throws have been replaced by a milder Write-Error for non-terminating errors

## [1.3.0]

### Changed

- ```Write-Error``` has been replaced by ```throw```, this will in some cases break your script since, instead of writing an error in the output, it will generate a terminating error. Use try/catch to handle these errors in your scripts.

### Fixed

- ```Add-OpZoneRecord```
  - Issue #8 resolved. Now when given the ```-Type MX```, the script will validate if ```-Priority``` is a valid integer. By default the value will be 0.

## [1.2.1]

### Fixed

- ```Get-OPZoneRecords``` 
  - Issue #7 was resolved, command now return up to 500 records, thanks @tomdhoore

## [1.2.0]

### Added

- ```Get-OPSSLProducts```
  - Get a list of all the SSL products
- ```Get-OPSSLOrders```
  - Get a list of all orders or use the ```-ExpiringSoon``` switch to list the SSL orders that are expiring soon (30 days)
- ```Send-OPSSLApproverEmail```
  - (Re)send approve email to the contact, output will specify which email address this is.
- Verbose ouputs for the request splat in ```Invoke-OPRequest```

## [v1.1.1]

### Added

- Added progress indicator for lists more than 500 domains with ```Get-OPDomain```

### Fixed

- Fixed #5 where ```-Detailed``` would raise an error when a domain is not of status "ACT".

### Changed

- Changed ```Get-OPDomain``` to only search for active domains, failed, deleted and requested domains will NOT show.

## [v1.1.0]

### Added

- Much improved error handling for requests, will return OpenProvider error code that you can reference to instead of generic failures. [(reference)](https://support.openprovider.eu/hc/en-us/articles/216644928-API-Error-Codes)
- Sanbox connectivity!
- Validation of created nameserver in ```Add-OPNameserver```
- Added ```$true``` outputs for all Get, Set and Remove commands when completed succesfully for logic.
- ```[CmdletBinding()]``` to every function for common parameters.
- ```Connect-OpenProvider``` now uses ```Invoke-OPRequest```
- More readable and useful outputs for all commands that return information (```Get-OP-```)
- ```Update-OPDomain``` add comments, lock the domain and change nameserver groups with this command.
- ```Get-OPNameserverGroup``` get a list of nameserver groups in your tenant.
- ```New-OPAuthCode``` get a AuthCode for your domain (specify domain ID)

### Fixed

- Fixed an error when adding a body to a Get request in PowerShell 5.1 (```New-QuerryString```)

### Changed

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
