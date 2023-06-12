$moduleRoot = (Get-Item $PSScriptRoot).Parent.FullName
### Read the local.settings.json file and convert to a PowerShell object.
$devSettings = Get-Content "$moduleRoot\Tools\local.settings.json" | ConvertFrom-Json
### Loop through the settings and set environment variables for each.
$validKeys = @('username', 'password')
ForEach ($key in $devSettings.PSObject.Properties.Name) {
    if ($validKeys -Contains $key) {
        [Environment]::SetEnvironmentVariable($key, $devSettings.$key)
    }
}

Import-Module "$moduleRoot\OpenProviderPowershell.psm1" -Force -Verbose

$connectSplat = @{
    Credential = New-Object System.Management.Automation.PSCredential($env:username, ($env:password | ConvertTo-SecureString -AsPlainText -Force))
}

Connect-OpenProvider @connectSplat -Verbose -Sandbox