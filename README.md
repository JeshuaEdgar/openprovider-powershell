# OpenProviderPowershell

## ! In development !
This module/wrapper is and will be in development (until most OpenProvider API endpoints are covered), I will try and cover as many endpoints as possible starting with basic domain and DNS management. 

This module also has no affilation with OpenProvider, just a community project.

PowerShell 7 is required to be able to run the functions in this module!

# How to use
### Connecting/disconnecting
Connecting to OpenProvider is easy, simply run the following commands to get a connection to OpenProvider.
```powershell
Connect-OpenProvider
# or
$Credential = Get-Credential
Connect-OpenProvider -Credential $Credential
```
For security run the following at the end of your session/script.
```powershell 
Disconnect-OpenProvider
```

### Domain
Currently this feature is not very efficient as there is no way to search for a single domain, it is recommended to run this command with the ```-All``` switch because all the ```-Domain``` parameter does is filter the ```-All``` list. You can always filter on domains at a later moment of time.
```powershell
Get-OpDomain -All
```

### DNS Zones
Adding records is simple, provide a domain name, Zone ID and the value of the record. Example:
```powershell 
Add-OPTXTRecord -Domain "testdomain.com" -ZoneID "12345678" -Value "v=SPF1 -all"
```

## To-do:
- Add-OPZoneRecord
- Add-OPZone