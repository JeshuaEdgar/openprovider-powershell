param (
    [cmdletbinding()]
    [parameter(Mandatory)][pscredential]$Credential
)
BeforeAll {
    Import-Module (Resolve-Path("OpenProviderPowershell.psd1")) -Force
    $env:randomValue = -join ((97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ }) 
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

        It "Should get OpenProvider DNS zones" {
            $domain = (Get-OPDomain)[0]
            (Get-OPZone -Domain $domain.Domain -Provider sectigo).Active | Should -BeTrue
        }
 
        It "Should get DNS zone records" {
            ((Get-OPDomain)[0] | Get-OPZoneRecord -Provider sectigo).count | Should -BeGreaterThan 3
        }

        It "Should create a DNS zone record" {
            $domain = (Get-OPDomain)[0]
            Get-OPZone -Domain $domain.Domain -Provider sectigo | Add-OPZoneRecord -Name "unittest" -Type MX -Value ($env:randomValue, $domain.domain -join ".") -Priority 1 | Should -BeTrue
        }

        It "Should set a DNS record" {
            $record = (Get-OPDomain)[0] | Get-OPZoneRecord -Provider sectigo | Where-Object { $_.Type -eq "MX" -and $_.Value -eq ($env:randomValue, $domain.domain -join ".") }
            Set-OPZoneRecord -Record $record -Value ("test", $record.Domain -join ".") | Should -BeTrue
        }

        It "Should delete a DNS record" {
            $domain = (Get-OPDomain)[0]
            $record = $domain | Get-OPZoneRecord -Provider sectigo | Where-Object { $_.Type -eq "MX" -and $_.Value -eq ("test", $domain.Domain -join ".") }
            Remove-OPZoneRecord -Record $record | Should -BeTrue
        }
    }
}