# OpenProviderPowershell

## ! In development !
This module/wrapper is and will be in development (until most OpenProvider API endpoints are covered), I will try and cover as many endpoints as possible starting with basic domain and DNS management. 

This module also has no affilation with OpenProvider, just a community project.

# How to use
### Connecting
Connecting to OpenProvider is easy, simply run the following commands to get a connection to OpenProvider
```powershell
Connect-OpenProvider
# or
$Credential = Get-Credential
Connect-OpenProvider -Credential $Credential
```

### Getting a domain
Currently this feature is not very efficient as there is no way to search for a single domain, it is recommended to run this command with the ```-All``` switch because all the ```-Domain``` parameter does is filter the ```-All``` list. You can always filter on domains at a later moment of time.
```powershell
Get-OpDomain -All
```

## To-do:
- Add-OPZoneRecord
- Add-OPZone