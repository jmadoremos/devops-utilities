Set-Location $PSScriptRoot
$modules = (Get-ChildItem | Where-Object { $_.Mode.StartsWith("d") } | Select-Object Name)
ForEach($module in $modules) {
    # define module information
    $module = $module.Name
    $psModulePath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\$module"
    Write-Host "[ ] Processing $module..."
    # remove module if existing
    Write-Host "Checking if $psModulePath exists..."
    If ((Test-Path $psModulePath) -eq $true) {
        Write-Host "$psModulePath exists. Deleting..." -ForegroundColor Yellow
        Get-ChildItem $psModulePath -Recurse -Force | Remove-Item -Recurse -Force
        Remove-Item $psModulePath -Recurse -Force
        If ((Test-Path $psModulePath) -eq $false) { Write-Host "$psModulePath has been deleted successfully." -ForegroundColor Green }
        Else { Write-Host "$psModulePath has not been deleted." -ForegroundColor Yellow }
    }
    # copy module to destination
    Write-Host "Copying contents of $module..."
    Copy-Item $module -Destination $psModulePath -Recurse
    If ((Test-Path $psModulePath) -eq $true -and (Test-Path "$psModulePath\$module.psm1") -eq $true) { Write-Host "Contents of $module has been copied successfully." -ForegroundColor Green }
    Else { Write-Host "Module $psModulePath has not been created." -ForegroundColor Yellow }
    # import
    Write-Host "Importing $module module..."
    Import-Module $module -DisableNameChecking -Force
    Write-Host "$module module has been imported successfully." -ForegroundColor Green
}
If (-Not ($host.Name -eq "Windows PowerShell ISE Host")) { cmd /c pause | Out-Null }
