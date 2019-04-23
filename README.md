# DevOps Utilities

This repository contains a number of utility scripts as supplement to existing tools and applications for DevOps tasks.

## Contents

* [Install-DevOpsModules.ps1](Install-AlbusDevOpsModules.ps1) is used to install the DevOps utilities found in this repository.

* [ps-exceptions.txt](ps-exceptions.txt) contains a list of standard PowerShell Exceptions for debugging.

* [ps-verbs.txt](ps-verbs.txt) contains a list of accepted PowerShell Verbs used to prefix newly created methods. 

## Installation

### Pre-requisites

* Windows 10 with PowerShell and Administrative Access (e.g., Avecto Defendpoint)

* Git Bash

### Instructions

1. Install/update [SqlServer](https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module?view=sql-server-2017) module in PowerShell

    * to *install*, run this command:

    ```shell
    $ Install-Module -Name SqlServer -Scope CurrentUser
    ```

    * to *update*, run this command:

    ```shell
    $ Update-Module -Name SqlServer
    ```


2. Clone this repository to your local machine, preferrably in "C:/repo/innersource/BUSOPS" folder

    ```shell
    $ git clone https://github.com/jmadoremos/devops-utilities
    ```

3. Run the [Install-AlbusDevOpsModules.ps1](Install-AlbusDevOpsModules.ps1) script as Administrator

    ```shell
    $ ./Install-AlbusDevOpsModules.ps1
    ```

4. Close all running instances of any terminal (i.e., PowerShell, CMD, Bash)

## How to Use

After successful installation, the following commands will be available in PowerShell.

**Reminders:** 

1. Run PowerShell as Administrator always before using any of these commands to avoid access restrictions.

2. All commands uses the current user's Windows credential to connect to a server and database.

3. All commands are restricted by the current user's access to the connected database.

### Microsoft SQL Database

#### Invoke-AlbusMsSqlQuery

The `Invoke-AlbusMsSqlQuery` command will allow the user to execute a SQL statement. Statements *SELECT*, *UPDATE*, *INSERT*, *DELETE*, *DROP*, *EXEC* and the other statements are accepted in this command. The `-query <<query>>` flag sets the query to execute. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to execute a *SELECT* statement to "MyApp" database in the "127.0.0.1\MSSQLSERVER2016,1540" server

    ```shell
    $ Invoke-AlbusMsSqlQuery -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp" -query "SELECT *  FROM INFORMATION_SCHEMA.TABLES"
    ```

#### New-AlbusMsSqlDatabase

The `New-AlbusMsSqlDatabase` command will recreate a database instance. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to create a new database instance with the name "MyApp" in the server "127.0.0.1\MSSQLSERVER2016,1540"

    ```shell
    $ Invoke-4530CreateDatabase -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```

#### Set-AlbusMsSqlOffline

The `Set-AlbusMsSqlOffline` command will take a database to offline state. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to take a database with name "MyApp" in the server "127.0.0.1\MSSQLSERVER2016,1540" to offline state

    ```shell
    $ Invoke-AlbusMsSqlOffline -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```

#### Set-AlbusMsSqlOnline

The `Set-AlbusMsSqlOnline` command will take a database to online state. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to take a database with name "MyApp" in the server "127.0.0.1\MSSQLSERVER2016,1540" to online state

    ```shell
    $ Invoke-AlbusMsSqlOnline -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```

#### Set-AlbusMsSqlMultiUser

The `Set-AlbusMsSqlMultiUser` command will take a database to Multi-User state. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to take a database with name "MyApp" in the server "127.0.0.1\MSSQLSERVER2016,1540" to Multi-User state

    ```shell
    $ Set-AlbusMsSqlMultiUser -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```


#### Compress-AlbusMsSqlDatabase

The `Compress-AlbusMsSqlDatabase` command will shrink the database. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to shrink a database with name "4530_BudgePlannSyste_Dev" in the server "10.69.163.211\MSSQLSERVER2014,1540"

    ```shell
    $ Compress-AlbusMsSqlDatabase -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```

#### Get-AlbusMsSqlConnectedUsersCount

The `Get-AlbusMsSqlConnectedUsersCount` command will retrieve the number of connected users in a database. Connected users may be an actual user, a service or an agent. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to get the number of connected users in a database with name "MyApp" in the server "127.0.0.1\MSSQLSERVER2016,1540"

    ```shell
    $ Get-4530ConnectedUsersCount -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```

#### Remove-AlbusMsSqlConnectedUsers

The `Remove-AlbusMsSqlConnectedUsers` command will remove all connected users in a database. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to remove all connected users in a database with name "MyApp" in the server "127.0.0.1\MSSQLSERVER2016,1540"

    ```shell
    $ Remove-AlbusMsSqlConnectedUsers -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```

#### Test-AlbusMsSqlMultiUser

The `Test-AlbusMsSqlMultiUser` command will issue a number of tests to verify if a database is in MultiUser mode. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to test a database with name "MyApp" in the server "127.0.0.1\MSSQLSERVER2016,1540" for MultiUser mode

    ```shell
    $ Test-AlbusMsSqlMultiUser -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```

#### Resolve-AlbusMsSqlSingleUser

The `Resolve-AlbusMsSqlSingleUser` command will fix Single User issues in the database. Single User issue usually arise when a running service halts during operation without properly terminating. The `-serverInstance <<server instance>>` flag sets server instance where to connect. The `-databaseName <<database name>>` flag sets the name of the database.

* to resolve Single User issue in a database with name "MyApp" in the server "127.0.0.1\MSSQLSERVER2016,1540"

    ```shell
    $ Resolve-AlbusMsSqlSingleUser -serverInstance "127.0.0.1\MSSQLSERVER2016,1540" -databaseName "MyApp"
    ```

### OData Entity

#### Get-AlbusODataEntity

The `Get-AlbusODataEntity` command send an HTTP GET request to the OData endpoint. The `-odataUri <<uri>>` flag sets the OData Unified Resource Identifier (URI) endpoint. The `-entityId <<id>>` flag sets the ID of the entity requested.

* to get all results from the OData endpoint "https://services.odata.org/TripPinRESTierService/People"

    ```shell
    $ Get-AlbusODataEntity -odataUri "https://services.odata.org/TripPinRESTierService/People"
    ```

* to get a specific result from the OData endpoint "https://services.odata.org/TripPinRESTierService/People" with ID "russellwhyte" (Note: For string values, notice there are single quotation marks enclosing the value)

    ```shell
    $ Get-AlbusODataEntity -odataUri "https://services.odata.org/TripPinRESTierService/People" -entityId "'russellwhyte'"
    ```
