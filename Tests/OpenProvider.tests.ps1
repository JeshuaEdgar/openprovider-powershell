param (
    [cmdletbinding()]
    [parameter(Mandatory)][pscredential]$Credential
)
BeforeAll {
    Import-Module (Resolve-Path("OpenProviderPowershell.psd1")) -Force
    $env:randomValue1 = -join ((97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ }) 
    $env:randomValue2 = -join ((97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ }) 
}

Describe "Open Provider PowerShell tests" {

    Context "Connectivity" {

        It "Should connect to sandbox environment" {
            Connect-OpenProvider -Credential $Credential -Sandbox | Should -BeTrue
        }
    }

    Context "Domains" {

        It "Should get a domain list" {
            (Get-OPDomain).count | Should -BeGreaterOrEqual 1
        }
        It "Should update a domain" {
            $domain = (Get-OPDomain)[0]
            Update-OPDomain -DomainID $domain.id -Comments "Pester Testing" | Should -BeTrue
        }
        It "Should get availability of a domain" {
            Get-OPDomainAvailability -Domain "github.com" | Select-Object -ExpandProperty status | Should -Be "active"
        }
    }

    Context "DNS" {

        BeforeAll {
          $env:Domain = (Get-OPDomain)[0] | Select-Object -ExpandProperty Domain
          Write-Host $env:Domain
        }

        BeforeEach {
            Start-Sleep 5
        }

        It "Should get OpenProvider DNS zones" {
            (Get-OPZone -Domain $env:Domain -Provider sectigo).Active | Should -BeTrue
        }
 
        It "Should get DNS zone records" {
            (Get-OPZoneRecord -Domain $env:Domain -Provider sectigo).count | Should -BeGreaterThan 3
        }

        It "Should create a DNS zone record" {
            Get-OPZone -Domain $env:Domain -Provider sectigo | Add-OPZoneRecord -Name "unittest" -Type MX -Value ($env:randomValue1, $env:Domain -join ".") -Priority 1 | Should -BeTrue
        }

        It "Should set a DNS record" {
            $record =  Get-OPZoneRecord -Domain $env:Domain -Provider sectigo | Where-Object { $_.Type -eq "MX" -and $_.Name -eq "unittest" }
            Set-OPZoneRecord -Record $record -Value ($env:randomValue2, $record.Domain -join ".") | Should -BeTrue
        }

        It "Should delete a DNS record" {
            $record = Get-OPZoneRecord -Domain $env:Domain -Provider sectigo | Where-Object { $_.Type -eq "MX" -and $_.Name -eq "unittest" }
            Remove-OPZoneRecord -Record $record | Should -BeTrue
        }
    }
}
