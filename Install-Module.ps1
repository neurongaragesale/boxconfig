# For PowerShell 5 (and prev) C:\Program Files\WindowsPowerShell\modules
# For PowerShell 6            C:\Program Files\PowerShell\Modules
#
$moduleName = '_ngsdataconfig'
$modulePath = Split-Path -Parent $MyInvocation.MyCommand.Path

Foreach ($psPath in $env:PSModulePath.Split(";"))
{
	$pattern = "$env:ProgramFiles\*PowerShell\Modules"
	if ($psPath -like $pattern)
	{
		$targetPath = Join-Path $psPath "$moduleName"

		if (Test-Path -Path $targetPath) {
			Write-Output "Removing Existing Installation of Module"
			Remove-Item "$targetPath\*" -Recurse -Force
			Remove-Item $targetPath
		}

		Write-Output "Source: $modulePath"
		Write-Output "Path: $targetPath"

		$mPath = Join-Path (Get-Location).Path "_ngsdataconfig"
		
		Copy-Item $mPath -Destination $psPath -Recurse

		Break
	}
}
