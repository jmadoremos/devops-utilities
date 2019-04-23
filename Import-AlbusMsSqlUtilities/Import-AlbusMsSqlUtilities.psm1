Function Invoke-AlbusMsSqlQuery ([String] $serverInstance, [String] $databaseName, [String] $query) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { $databaseName = "master" }
        If ((Test-IsNullOrWhitespace($query)) -eq $true) { Write-AlbusErrorLog "$query is required." }

        # Process request
        Write-AlbusMessageLog "Using $databaseName database of $serverInstance instance..."
        Write-AlbusMessageLog "Executing query: $query"
        Invoke-Sqlcmd -ServerInstance $serverInstance -Database $databaseName -Query $query -AbortOnError
    }
    Catch { Write-AlbusErrorLog $_.Exception.Message }
}

Function New-AlbusMsSqlDatabase ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }

        # Process request
        Invoke-AlbusMsSqlQuery -serverInstance $serverInstance -databaseName "master" -query "CREATE DATABASE $databaseName"  
        Write-AlbusSuccessLog "Database $databaseName has been created successfully."
    }
    Catch { Write-AlbusErrorLog "Database $databaseName has not been created." }
}

Function Set-AlbusMsSqlOffline ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }

        # Process request
        Invoke-AlbusMsSqlQuery -serverInstance $serverInstance -databaseName "master" -query "ALTER DATABASE $databaseName SET OFFLINE WITH ROLLBACK IMMEDIATE"
        Write-AlbusSuccessLog "Database $databaseName has been set to offline successfully."
    }
    Catch { Write-AlbusErrorLog "Database $databaseName has not been set to offline." }
}

Function Set-AlbusMsSqlOnline ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }

        # Process request
        Invoke-AlbusMsSqlQuery -serverInstance $serverInstance -databaseName "master" -query "ALTER DATABASE $databaseName SET ONLINE"
        Write-AlbusSuccessLog "Database $databaseName has been set to online successfully."
    }
    Catch { Write-AlbusErrorLog "Database $databaseName has not been set to online." }
}

Function Set-AlbusMsSqlMultiUser ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }

        # Process request
        Invoke-AlbusMsSqlQuery -serverInstance $serverInstance -databaseName "master" -query "ALTER DATABASE $databaseName SET MULTI_USER WITH ROLLBACK IMMEDIATE"
        Write-AlbusSuccessLog "Database $databaseName has been set to MULTI_USER successfully."
    }
    Catch { Write-AlbusErrorLog "Database $databaseName has not been set to MULTI_USER." }
}

Function Compress-AlbusMsSqlDatabase ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }

        # Process request
        Invoke-AlbusMsSqlQuery -serverInstance $serverInstance -databaseName "master" -query "DBCC SHRINKDATABASE ( $databaseName )"
        Write-AlbusSuccessLog "Database $databaseName has been shrank successfully."
    }
    Catch { Write-AlbusErrorLog "Database $databaseName has not been shrank." }
}

Function Get-AlbusMsSqlConnectedUsersCount ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }
    
        # Process request
        Write-AlbusMessageLog "Getting connected users/services count..."
        $queryResult = Invoke-AlbusMsSqlQuery -serverInstance $serverInstance -databaseName $databaseName -query "SELECT COUNT(distinct login_name) AS TOTAL FROM sys.dm_exec_sessions"
        $count = $queryResult.TOTAL
        If ($count -eq 0) { Write-AlbusMessageLog "There are no connected users/services." }
        ElseIf ($count -eq 1) { Write-AlbusMessageLog "There is 1 connected user/service." }
        Else { Write-AlbusMessageLog "There are $count connected users/services." }
        Return $count
    }
    Catch { Write-AlbusErrorLog $_.Exception.Message }
}

Function Remove-AlbusMsSqlConnectedUsers ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }

        # Process request
        Write-AlbusMessageLog "Removing connected users/services..."
        $query = "DECLARE @execSql VARCHAR(1000) = '';", `
            "SELECT @execSql = @execSql + 'kill ' + CONVERT(VARCHAR(10), spid) + ';' FROM dbo.sysprocesses WHERE db_name(dbid) = '$databaseName' AND dbid <> 0 AND spid <> @@spid;", `
            "EXEC(@execSql);"
        Invoke-AlbusMsSqlQuery -serverInstance $serverInstance -databaseName "master" -query $query
        Write-AlbusSuccessLog "Connected users/services have been removed successfully."
    }
    Catch { Write-AlbusErrorLog "Connected users/services have not been removed." }
}

Function Test-AlbusMsSqlMultiUser ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }

        # Process request
        Write-AlbusMessageLog "Checking for MULTI_USER mode..."
        $queryResult = Invoke-AlbusMsSqlQuery -serverInstance $serverInstance -databaseName "master" -query "SELECT user_access_desc FROM sys.databases WHERE name = '$databaseName'"
        $isMultiUser = ($queryResult.user_access_desc -eq "MULTI_USER")
        If ($isMultiUser -eq $true) { Write-AlbusSuccessLog "Database is in MULTI_USER mode." }
        Else { Write-AlbusWarningLog "Database is in SINGLE_USER mode." }
        Return $isMultiUser;
    }
    Catch { Write-AlbusErrorLog $_.Exception.Message }
}

Function Resolve-AlbusMsSqlSingleUser ([String] $serverInstance, [String] $databaseName) {
    Try {
        # Validate arguments
        If ((Test-IsNullOrWhitespace($serverInstance)) -eq $true) { Write-AlbusErrorLog "$serverInstance is required." }
        If ((Test-IsNullOrWhitespace($databaseName)) -eq $true) { Write-AlbusErrorLog "$databaseName is required." }

        If ((Test-AlbusMsSqlMultiUser -serverInstance $serverInstance -databaseName $databaseName) -eq $false) {
            # Getting the number of connected users will allow us
            # to disconnect them first before proceeding with any
            # action that might cause an error due to the connected
            # users or services.
            $connectedUserCount = Get-AlbusMsSqlConnectedUsersCount -serverInstance $serverInstance -databaseName $databaseName
            If ($connectedUserCount -gt 0) { Remove-AlbusMsSqlConnectedUsers -serverInstance $serverInstance -databaseName $databaseName }
            
            Set-AlbusMsSqlOffline -serverInstance $serverInstance -databaseName $databaseName
            Set-AlbusMsSqlMultiUser -serverInstance $serverInstance -databaseName $databaseName
            Set-AlbusMsSqlOnline -serverInstance $serverInstance -databaseName $databaseName
        }
    }
    Catch { Write-AlbusErrorLog $_.Exception.Message }
}

Export-ModuleMember Invoke-AlbusMsSqlQuery
Export-ModuleMember New-AlbusMsSqlDatabase
Export-ModuleMember Set-AlbusMsSqlOffline
Export-ModuleMember Set-AlbusMsSqlOnline
Export-ModuleMember Set-AlbusMsSqlMultiUser
Export-ModuleMember Compress-AlbusMsSqlDatabase
Export-ModuleMember Get-AlbusMsSqlConnectedUsersCount
Export-ModuleMember Remove-AlbusMsSqlConnectedUsers
Export-ModuleMember Test-AlbusMsSqlMultiUser
Export-ModuleMember Resolve-AlbusMsSqlSingleUser
