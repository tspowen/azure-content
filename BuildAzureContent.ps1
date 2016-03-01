# Main
$errorActionPreference = 'Stop'

# add specific step for azure
Add-type -AssemblyName "System.IO.Compression.FileSystem"
$azureTransformContainerUrl = "https://opbuildstoragesandbox2.blob.core.windows.net/azure-transform"

$AzureMarkdownRewriterToolSource = "$azureTransformContainerUrl/.optemp/AzureMarkdownRewriterTool.zip"
$AzureMarkdownRewriterToolDestination = "$repositoryRoot\.optemp\AzureMarkdownRewriterTool.zip"
DownloadFile($AzureMarkdownRewriterToolSource) ($AzureMarkdownRewriterToolDestination) ($true)
$AzureMarkdownRewriterToolUnzipFolder = "$repositoryRoot\.optemp\AzureMarkdownRewriterTool"
if((Test-Path "$AzureMarkdownRewriterToolUnzipFolder"))
{
    Remove-Item $AzureMarkdownRewriterToolUnzipFolder -Force -Recurse
}
[System.IO.Compression.ZipFile]::ExtractToDirectory($AzureMarkdownRewriterToolDestination, $AzureMarkdownRewriterToolUnzipFolder)
$AzureMarkdownRewriterTool = "$AzureMarkdownRewriterToolUnzipFolder\Microsoft.DocAsCode.Tools.AzureMarkdownRewriterTool.exe"

$transformDirectoriesToRepositoryRoot = @("articles\active-directory", "articles\multi-factor-authentication", "articles\remoteapp")
foreach($transformDirectoryToRepositoryRoot in $transformDirectoriesToRepositoryRoot)
{
    $transformDirectory = "$repositoryRoot\$transformDirectoryToRepositoryRoot"
    echo "Azure Transform: Source Folder: $transformDirectory Output Folder: $transformDirectory"
    &$AzureMarkdownRewriterTool "$transformDirectory" "$transformDirectory"
    echo "Finish transform $transformDirectory files"
}

# add build for docs
$buildEntryPointDestination = Join-Path $packageToolsDirectory -ChildPath "opbuild" | Join-Path -ChildPath "mdproj.builder.ps1"
& "$buildEntryPointDestination" "$repositoryRoot" "$packagesDirectory" "$packageToolsDirectory" $dependencies

exit $LASTEXITCODE
