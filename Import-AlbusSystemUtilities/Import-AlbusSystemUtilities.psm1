# ==================== START ===================
# Logging Helper Functions
# ==============================================
Function Write-AlbusMessageLog ([String] $message, [ConsoleColor] $foreground, [ConsoleColor] $background) {
    If ($null -eq $foreground) { $foreground = "Gray" }
    Write-Host "[ ] " -NoNewline
    If ($null -eq $background) { Write-Host $message -ForegroundColor $foreground }
    Else { Write-Host $message -ForegroundColor $foreground -BackgroundColor $background }    
}
Function Write-AlbusSuccessLog ([String] $message) { Write-AlbusMessageLog -message $message -foreground Green }
Function Write-AlbusWarningLog ([String] $message) { Write-AlbusMessageLog -message $message -foreground Yellow }
Function Write-AlbusErrorLog ([String] $message) { Write-AlbusMessageLog -message $message -foreground Red -background Black }
# ==================== END ===================


# ==================== START ===================
# PowerShell Helper Functions
# ==============================================
Function Invoke-AlbusAdminRights {
    Write-AlbusMessageLog "Enforcing administrative rights..."
    If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-AlbusSuccessLog "Administrative rights is confirmed."
        Try { Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force }
        Catch [System.Security.SecurityException] { Write-AlbusWarningLog "'Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force' has already been called." }
        Catch { Write-AlbusErrorLog $_.Exception.ItemName; Break }
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Write-AlbusSuccessLog "Execution restrictions are removed."
    }
    Else { Write-AlbusErrorLog "Administrator rights is required! Please re-run the script as an Administrator." }
}
Function Get-PSVerbs {
    Get-Verb -Verbose
}
Function Get-PSExceptions {
    $a = [appdomain]::CurrentDomain.GetAssemblies()
    ForEach ($e in $a) {
        Try { 
            $r = $e.GetExportedTypes() | Where-Object { $_.Fullname -match "Exception" } | Select-Object FullName
            Return $r
        }
        Catch { }
    }
}
Function Test-AlbusPSModuleInstalled ([String] $moduleName) {
    Write-AlbusMessageLog "Checking for $moduleName module..."
    If (Get-Module -ListAvailable -Name $moduleName) {
        Write-AlbusSuccessLog "$moduleName module is found successfully."
        Return $true
    }
    Else {
        Write-AlbusWarningLog "$moduleName module not found. Install the module first before re-running this script."
        Write-AlbusWarningLog "Run the following command to install: Import-Module -Name $moduleName -Force -Confirm"
        Return $false
    }
}
Function Test-IsNullOrWhitespace ([String] $stringValue) {
    Return [String]::IsNullOrWhiteSpace($stringValue)
}
# ==================== END ===================


# ==================== START ===================
# Chocolatey Helper Functions
# ==============================================
Function Install-AlbusChocolatey {
    Try {
        Invoke-AlbusAdminRights
        If ((Test-Path "C:\ProgramData\chocolatey\bin\choco.exe") -eq $false) {
            Write-AlbusMessageLog "Installing Chocolatey for PowerShell..."
            Try { (New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1") | Invoke-Expression }
            Catch { Write-AlbusErrorLog "Cannot connect to the Chocolatey server. Please check your internet connection and try again."; Break }
            Write-AlbusSuccessLog "Chocolatey v$(chocolatey --version) has been installed successfully."
        }
        Else {
            Write-AlbusWarningLog "Chocolatey v$(chocolatey --version) is already installed."
            Write-AlbusWarningLog "You can update Chocolatey to the latest version by running 'choco update chocolatey'"
        }
    }
    Catch { Write-AlbusErrorLog $_.Exception.Message }
}
Function Test-AlbusChocoPkgInstalled ([String] $packageName) {
    Try {
        $packageName = $packageName.ToLower()
        $chocoPkg = (choco list -localonly | Where-Object { $_.ToLower().StartsWith($packageName) })
        $isInstalled = -Not ($null -eq $chocoPkg)
        Write-AlbusSuccessLog "Chocolatey package installed: $isInstalled"
        Return $isInstalled
    }
    Catch { Write-AlbusErrorLog "Chocolatey is not installed." }
}
Function Get-AlbusChocoPkgVersion ([String] $packageName) {
    Try {
        $packageName = $packageName.ToLower()
        $chocoPkg = (choco list -localonly | Where-Object { $_.ToLower().StartsWith($packageName) })
        If ($null -eq $chocoPkg) { throw [System.Management.Automation.ItemNotFoundException   ] "Chocolatey package $packageName is not yet installed." }
        $version = $chocoPkg.Split(" ")[1]
        Write-AlbusSuccessLog "Chocolatey package version: $packageName v$version"
        Return $version
    }
    Catch [System.Management.Automation.ItemNotFoundException] {  Write-AlbusErrorLog $_.Exception.Message }
    Catch { Write-AlbusErrorLog "Chocolatey is not installed." }
}
# ==================== END ===================

Export-ModuleMember Write-AlbusMessageLog
Export-ModuleMember Write-AlbusSuccessLog
Export-ModuleMember Write-AlbusWarningLog
Export-ModuleMember Write-AlbusErrorLog

Export-ModuleMember Invoke-AlbusAdminRights
Export-ModuleMember Get-PSVerbs
Export-ModuleMember Get-PSExceptions
Export-ModuleMember Test-AlbusPSModuleInstalled
Export-ModuleMember Test-IsNullOrWhitespace

Export-ModuleMember Install-AlbusChocolatey
Export-ModuleMember Test-AlbusChocoPkgInstalled
Export-ModuleMember Get-AlbusChocoPkgVersion
