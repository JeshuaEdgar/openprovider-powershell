# Add-OPZoneRecord

To add a record to a single domain:

```powershell
Get-OPZone "testdomain.com" -Provider sectigo | Add-OPZoneRecord -Type TXT -Value "v=SPF1"
```

Pipelining is great for processing batches, here is an example of adding the ```"v=SPF1"``` TXT record to all domains in OpenProvider:

```powershell
Get-OPZone | Add-OPZoneRecord -Type TXT -Value "v=SPF1"
```

# Get-OPZoneRecord

```powershell
Get-OPDomain "testdomain.com" | Get-OPZoneRecord -Provider sectigo
```

# Set-OpZoneRecord

```powershell
Get-OPZoneRecord -Domain "testdomain.com" -Provider sectigo | Where-Object {$_.Value -eq "v=SPF1"} | Set-OPZoneRecord -Value "v=SPF1 -all"
```

