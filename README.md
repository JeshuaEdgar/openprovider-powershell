# OpenProviderPowershell

## In development
This module is still in development, feedback is welcome and endpoint/feature requests are welcome.

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
Getting a zone record ID is necesary for adding and setting records, there are 2 parameters: 
```-Sectigo``` and ```-OpenProvider```. To get a Zone ID for a domain run the following:
```powershell 
Get-OPZoneID -Domain "testdomain.com" -Sectigo
```
With a Zone ID you can then querry the records on a domain.
```powershell 
Get-OPZoneRecords -Domain "testdomain.com" -ZoneID "12345678"
```
Adding records is simple, provide a domain name, Zone ID, type of record and the value. Example:
```powershell 
Add-OPZoneRecord -Domain "testdomain.com" -ZoneID "12345678" Type TXT -Value "v=SPF1 -all"
```
The following DNS records can be added through this module:
- A
- AAAA
- CAA
- CNAME
- MX
- TXT
- NS
