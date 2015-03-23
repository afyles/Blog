function Start-PackageValidation()
{
    <#
        .SYNOPSIS
        Validate a package in the catalog
        .DESCRIPTION
        The Start-PackageValidation function starts a package in the catalog
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$PackageName,
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$Environment,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )


    $refId = Get-EnvironmentReference $Environment $FolderName $Server $Instance

    $sql = 
@"
DECLARE @validationId bigint;
EXEC catalog.validate_package
@folder_name=`$(FolderName),  
@project_name=`$(ProjectName), 
@package_name=`$(PackageName),
@validation_id=@validationId OUTPUT,
@environment_scope = 'S',
@reference_id=`$(refId);
SELECT @validationId AS validation_id
"@
    $variables = "foldername = '$FolderName'", "packagename = '$PackageName'", "projectname = '$ProjectName'", "refid = '$refId'"

    SQLDEPLOY\Get-SqlLocation $Server $Instance | Push-Location | Out-Null
    $r = SQLDEPLOY\Execute-Procedure $sql $variables
    Pop-Location

    $r.validation_id
}

function Get-PackageValidations()
{
    <#
        .SYNOPSIS
        Gets package validation result
        .DESCRIPTION
        The Get-PackageValidation function returns a validation result
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$PackageName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $sql =
@"
SELECT 
      [object_name]
      ,[start_time]
      ,[end_time]
      ,CASE [status]
		WHEN 4 THEN 'Failed'
		WHEN 3 THEN 'Cancelled'
		WHEN 7 THEN 'Succeeded'
		ELSE 'Running'
		END AS [status]
      ,[caller_name]
      ,[server_name]
      ,[machine_name]
  FROM [catalog].[validations]
  WHERE [object_name] = '$PackageName'
  ORDER BY start_time DESC
"@

    SQLDEPLOY\Get-SqlLocation $Server $Instance | Push-Location | Out-Null
    SQLDEPLOY\Execute-Query $sql
    Pop-Location
}

function Set-ExecutionParameter()
{
    <#
        .SYNOPSIS
        Sets an execution parameter for an execution
        .DESCRIPTION
        Sets an execution parameter for an execution
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][int]$ExecutionId,
        [Parameter(Mandatory=$false)][int]$ObjectId = 20,
        [Parameter(Mandatory=$true)][string]$ParameterName,
        [Parameter(Mandatory=$true)][object]$ParameterValue,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    if ( $ParameterValue.GetType().Name -eq 'String' )
    {
        $ParameterValue = [String]::Format("'{0}'", $ParameterValue)
    }

    $paramSql = "EXEC catalog.set_execution_parameter_value @execution_id=`$(ExecId), @object_type=`$(ObjectId), @parameter_name=`$(ParamName), @parameter_value=`$(ParamValue)"
    $paramVariables = "ExecId = $ExecutionId", "ObjectId = $ObjectId", "ParamName = '$ParameterName'", "ParamValue = $ParameterValue"

    SQLDEPLOY\Get-SqlLocation $Server $Instance | Push-Location | Out-Null
    $result = SQLDEPLOY\Execute-Procedure $paramSql $paramVariables
    Pop-Location
}

function Start-Package()
{
    <#
        .SYNOPSIS
        Starts a package in the catalog
        .DESCRIPTION
        The Start-Package function starts a package in the catalog
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$PackageName,
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$Environment,
        [Parameter(Mandatory=$false)][hashtable]$Parameters,
        [Parameter(Mandatory=$false)][int]$LogLevel=1,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default",
        [Parameter(Mandatory=$false)][switch]$Synchronized
    )

    $percentComplete = 0

    $sqlLocation =  SQLDEPLOY\Get-SqlLocation $Server $Instance

    $refId = Get-EnvironmentReference $Environment $FolderName $Server $Instance

    Write-Progress -Activity "Package Execution" -Status "Creating execution..." -PercentComplete $percentComplete

    $sql = 
@"
DECLARE @executionId bigint;
EXEC catalog.create_execution @package_name=`$(PackageName),
@execution_id=@executionId OUTPUT,
@folder_name=`$(FolderName), 
@project_name=`$(ProjectName), 
@use32bitruntime=0, 
@reference_id=`$(refId);
SELECT @executionId AS execution_id
"@
    $variables = "foldername = '$FolderName'", "packagename = '$PackageName'", "projectname = '$ProjectName'", "refid = '$refId'"

    Push-Location $sqlLocation | Out-Null
    $r = SQLDEPLOY\Execute-Procedure $sql $variables
    Pop-Location

    $execId = $r.execution_id

    $percentComplete += 10

    Write-Progress -Activity "Package Execution" -Status "Setting execution parameters..." -PercentComplete $percentComplete

    $paramName = 'LOGGING_LEVEL'    

    Set-ExecutionParameter -ExecutionId $execId -ObjectId 50 -ParameterName $paramName -ParameterValue $LogLevel -Server $Server -Instance $Instance
    
    $percentComplete += 1

    Write-Progress -Activity "Package Execution" -Status "Setting execution parameters..." -CurrentOperation "$paramName = $LogLevel" -PercentComplete $percentComplete

    if ( $Parameters )
    {
        foreach($p in $Parameters.GetEnumerator()) 
        { 
            $name = $p.Name
            $value = $p.Value

            Set-ExecutionParameter -ExecutionId $execId -ParameterName $name -ParameterValue $value -Server $Server -Instance $Instance

            $percentComplete += 1

            Write-Progress -Activity "Package Execution" -Status "Setting execution parameters..." -CurrentOperation "$name = $value" -PercentComplete $percentComplete
        }
    }

    $sql3 = "EXEC catalog.start_execution @execution_id=`$(execId)"
    $variables3 = "execid = $execId"

    Push-Location $sqlLocation | Out-Null
    $result = SQLDEPLOY\Execute-Procedure $sql3 $variables3
    Pop-Location

    SQLDEPLOY\Check-Error $result "Start package failed with code $result" 7

    $percentComplete = 0

    Write-Progress -Activity "Package Execution" -Status "Starting execution..." -PercentComplete $percentComplete

    if ( $Synchronized)
    {
        $done = $false
        $totalTime = 0

        while ( $done -eq $false )
        {
            $status = Get-PackageStatus -Server $Server -Instance $Instance -Id $execId
            
            if ($status -notin 'Created','Running','Pending','Stopping')
            {
                $done = $true
                Write-Progress -Activity "Package Execution" -Status $status -PercentComplete 100
                Write-Progress -Activity "Package Execution" -Completed
            }
            else
            {
                $done = $false
                Write-Progress -Activity "Package Execution" -Status $status -PercentComplete $percentComplete
                
                Start-Sleep -Seconds 10
                $totalTime += 10

                if ($percentComplete -eq 100)
                {
                    $percentComplete = 0
                }
                else
                {
                    $percentComplete += 10
                }
            }
        }

        Write-Host "Package completed in $totalTime seconds"
    }

    Write-Progress -Activity "Package Execution" -Status "Execution started." -PercentComplete 100
    Write-Progress -Activity "Package Execution" -Completed

    Write-Host "Execution Id: $execId"
}

function Stop-Package()
{
    <#
        .SYNOPSIS
        Stops a package in the catalog
        .DESCRIPTION
        The Stop-Package function starts a package in the catalog
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][int]$ExecutionId,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $sql = "EXEC catalog.stop_operation @operation_id=`$(ExecutionId)"
    $variables = "executionid = $ExecutionId"

    SQLDEPLOY\Get-SqlLocation $Server $Instance | Push-Location | Out-Null
    $result = SQLDEPLOY\Execute-Procedure $sql $variables
    Pop-Location

    SQLDEPLOY\Check-Error $result "Stop package failed with code $result" 8

}

function Get-PackageStatus()
{
    <#
        .SYNOPSIS
        Gets a list of running packages
        .DESCRIPTION
        The Get-RunningPackages function returns a list of running packages
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][int]$Id,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $sql =
@"
SELECT 
      [status]
      ,[start_time]
      ,[end_time]
  FROM [SSISDB].[catalog].[executions]
  WHERE [execution_id] = $Id
"@

    SQLDEPLOY\Get-SqlLocation $Server $Instance | Push-Location | Out-Null
    $result = SQLDEPLOY\Execute-Query $sql
    Pop-Location
    
    switch ( $result.status )
    {
        1{$status = "Created "}
        2{$status = "Running"}
        3{$status = "Canceled "}
        4{$status = "Failed"}
        5{$status = "Pending"}
        6{$status = "Ended Unexpectedly"}
        7{$status = "Succeeded"}
        8{$status = "Stopping"}
        9{$status = "Completed"}
        default{ $status = "Unknown" }
    }

    return $status
}

function Get-RunningPackages()
{
    <#
        .SYNOPSIS
        Gets a list of running packages
        .DESCRIPTION
        The Get-RunningPackages function returns a list of running packages
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $sql =
@"
SELECT [execution_id]
      ,[folder_name]
      ,[project_name]
      ,[package_name]
      ,[environment_name]
      ,[executed_as_name]
      ,[created_time]
      ,[status]
      ,[start_time]
      ,[end_time]
      ,[stopped_by_name]
      ,[server_name]
      ,[total_physical_memory_kb]
      ,[available_physical_memory_kb]
  FROM [SSISDB].[catalog].[executions]
  WHERE start_time IS NOT NULL
  AND end_time IS NULL
"@

    SQLDEPLOY\Get-SqlLocation $Server $Instance | Push-Location | Out-Null

    SQLDEPLOY\Execute-Query $sql

    Pop-Location
}

function Get-Errors
{
	<#
        .SYNOPSIS
        Reads the error log table for the SSIS error log destination
        .DESCRIPTION
        Reads the error log table for the SSIS error log destination

    #>
	[CmdletBinding()]
    param (
	[Parameter(Mandatory=$true)][string]$LogName,
    [Parameter(Mandatory=$true)][string]$Database,
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $sqlLocation = [String]::Format("SQLSERVER:\SQL\{0}\{1}\Databases\{2}", $Server, $Instance, $Database)

    Push-Location $sqlLocation | Out-Null

	$sql = "SELECT * FROM $LogName"

	SQLDEPLOY\Execute-Query $sql

    Pop-Location
}

function Remove-PackageErrors
{
	<#
        .SYNOPSIS
        Removes errors from the error log table for the SSIS error log destination
        .DESCRIPTION
        Removes errors from the error log table for the SSIS error log destination

    #>
	[CmdletBinding()]
    param (
	[Parameter(Mandatory=$true)][string]$LogName,
    [Parameter(Mandatory=$true)][string]$PackageName,
    [Parameter(Mandatory=$true)][string]$Database,
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $sqlLocation = [String]::Format("SQLSERVER:\SQL\{0}\{1}\Databases\{2}", $Server, $Instance, $Database)

    Push-Location $sqlLocation | Out-Null

	$sql = "DELETE FROM $LogName WHERE PackageName = '$PackageName'"

	SQLDEPLOY\Execute-Query $sql

    Pop-Location
}

function Sweep-ErrorLog
{
	<#
        .SYNOPSIS
        Reads the error log table for the SSIS error log destination and sends email to notify someone
        .DESCRIPTION
        Reads the error log table for the SSIS error log destination

    #>
	[CmdletBinding()]
    param (
	[Parameter(Mandatory=$true)][string]$LogName,
    [Parameter(Mandatory=$true)][string]$Database,
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$false)][string]$Instance = "default",
    [Parameter(Mandatory=$true)][string]$To,
    [Parameter(Mandatory=$false)][string]$SmtpServer = "smtp.server.com",
    [Parameter(Mandatory=$false)][int]$Port = 587
    )

    $errors = Get-Errors -LogName $LogName -Database $Database -Server $Server -Instance $Instance

    if ( $errors -and $errors.Length > 0 ) {
        $subject = [String]::Format("{0} SSIS Errors in Log {1} on {2}\{3}\{4}",$errors.Length, $LogName, $Server, $Instance, $Database)
        Send-MailMessage -To $To -From $To -Subject $subject -Body "Errors found in SSIS Log" -SmtpServer $SmtpServer -Port $Port
    }
    else {
        Write-Host "No errors found"
    }
}