param(
    [string]$buildCorePowershellUrl = "https://opbuildstoragesandbox2.blob.core.windows.net/azure-transform/.openpublishing.buildcore.ps1",
    [string]$parameters
)
# Main
$errorActionPreference = 'Stop'

# Step-1 Download buildcore script to local

# add specific step for azure
$buildCorePowershellUrl = "https://opbuildstoragesandbox2.blob.core.windows.net/azure-transform/.openpublishing.buildcore.ps1"

echo "download build core script to local with source url: $buildCorePowershellUrl"
$repositoryRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$buildCorePowershellDestination = "$repositoryRoot\.openpublishing.buildcore.ps1"
Invoke-WebRequest $buildCorePowershellUrl -OutFile $buildCorePowershellDestination

# Step-2: Run build core
echo "run build core script with parameters: $parameters"
$arguments = "-parameters:'$parameters'"
& "$buildCorePowershellDestination" $arguments
exit $LASTEXITCODE
