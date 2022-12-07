# OpenProviderPowershell

## How to use

OpenProviderPowershell is available on PowerShellGallery! To install:

```powershell
Install-Module OpenProviderPowershell
```

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

### DNS Zones

### DNS Zone Records

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

Updating existing records can be done too. Use ```New-OPZoneRecordObject``` to create easy objects that can be parsed into ```Set-OPZoneRecord```. Here is an example how you could get a DNS record and adjust it to your needs:

```powershell
$domain = "testdomain.com"
$zone = Get-OPZone -Domain $domain
$zone_records = Get-OPZoneRecords -Domain $domain -ZoneID $zone.id
$original_record = $zone_records | Where-Object {($_.type -eq "TXT") -and ($_.value -eq "v=SPF1 +all")}
$new_record = New-OPZoneRecordObject -Type TXT -Value "v=SPF1 -all"
Set-OPZoneRecord -Domain $domain -ZoneID $zone.id -OriginalRecord $original_record -NewRecord $new_record
```

### Domain

You can search for all domains in your OpenProvider directory:

```powershell
Get-OpDomain -All
```

Or you can search for a specific domain:

```powershell
Get-OpDomain -Domain "testdomain.com"
```

Further details of a domain can be obtained with:

```powershell
Get-OPDomainDetails -ID 12345678
```

Availability and pricing for a domain can be checked like this, multiple domains are accepted (they must be in a list like the example below):

```powershell
$domainlist = @(
    "iwanttocheck.com"
    "thesedomains.au"
    "ohandthisone.nl"
)
Get-OPDomainAvailability -Domain $domainlist
```

Output will look like this, this can be handy if you want to check the availibility and price before you go ahead and register a domain:

```powershell
domain           status currency  price
------           ------ --------  -----
iwanttocheck.com free   EUR       8.900
thesedomains.au  free   EUR      31.130
ohandthisone.nl  free   EUR       3.190
```

#### TODO

- Register-OPDomain (quite extensive function, might take a while)

## Disclaimer

This module has no affilation with OpenProvider, just a personal/community project.

This module is still in development, feedback is welcome and endpoint/feature requests are welcome.

Please refer to [OpenProvider API Docs](https://docs.openprovider.com/doc/all) for feature/endpoint requests.
