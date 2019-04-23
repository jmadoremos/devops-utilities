$headers = @{}
$headers.Add("Content-Type", "application/json")
$headers.Add("OData-MaxVersion", 4.0)
$Headers.Add("Prefer", "return=representation")

Function Get-AlbusODataEntity ([String] $odataUri, [String] $entityId = $null) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($odataUri)) -eq $true) { Write-AlbusErrorLog "$odataUri is required." }

        # Process request
        $parsedUri = "$odataUri"
        If (-not($null -eq $entityId)) { $parsedUri = "$odataUri($entityId)" }
        $response = Invoke-WebRequest -Method "GET" -Uri $parsedUri -Headers $headers
        Return $response.Content | ConvertFrom-Json;
    }
    Catch { Write-AlbusErrorLog $_.Exception }
}

Export-ModuleMember Get-AlbusODataEntity
