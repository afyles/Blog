function Publish-Ispac ()
{
    <#
        .SYNOPSIS
        Publishes an Ispac file to SQL using SqlPackage.exe
        .DESCRIPTION
        The Publish-Ispac function publishes a Ispac to SQL

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [Parameter(Mandatory=$true)][string]$DestinationPath,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $lastDeploy = SQLDEPLOY\Execute-Query "SELECT last_deployed_time FROM catalog.projects WHERE name ='$ProjectName'"

    Set-Location $currentLocation
    
    & "${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DTS\Binn\ISDeploymentWizard.exe" /Silent /SP:"$ProjectName.ispac" /DS:"$Server\$Instance" /DP:"/SSISDB/$DestinationPath/$ProjectName" | Out-Null

    Set-Location $sqlLocation | Out-Null

    $currentDeploy = SQLDEPLOY\Execute-Query "SELECT last_deployed_time FROM catalog.projects WHERE name ='$ProjectName'"

    Set-Location $currentLocation

    if ( $($lastDeploy.last_deployed_time) -gt $($currentDeploy.last_deployed_time) )
    {
        Write-Error "Project deployment failed current deployment time is $currentDeploy.last_deployed_time" -Category InvalidResult
        exit 1
    }
}


function ReadProjectFile( $projectFile, $target )
{
    $fileExists = Test-Path "$projectFile"
            
    if ( $fileExists -eq $true )
    {
        [xml]$project = Get-Content "$projectFile"
        $script:PROJECT_NAME = $project.project.name
        $script:DATABASE = $project.project.database
        $script:INSTANCE = $project.project.instance
        $script:PATH = $project.project.path
	    $script:CURRENT_LOCATION = $pwd

        if ( $target )
        {
            $script:SERVER = $target
        }
        else
        {
            $script:SERVER = $project.project.server
        }

        $project
    }  
    else
    {
        Write-Error "Project file does not exist, exiting..."
        exit
    }
}

function Get-Environments()
{
 <#
        .SYNOPSIS
        Lists the environments in the catalog
        .DESCRIPTION
        The New-Environment function creates the environment

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $sql = 
@"
SELECT environment_id
      ,e.name AS environment_name
	  ,e.[description] AS environment_description
      ,f.name AS folder_name
      ,f.[description] AS folder_description
  FROM catalog.environments e 
  INNER JOIN catalog.folders f ON e.folder_id = f.folder_id
"@

    SQLDEPLOY\Execute-Query $sql

    Set-Location $currentLocation    
}

function New-Environment()
{
    <#
        .SYNOPSIS
        Creates an SSIS Catalog environment
        .DESCRIPTION
        The New-Environment function creates the environment

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$EnvironmentName,
        [Parameter(Mandatory=$false)][string]$Description="",
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $envSql = "SELECT e.name FROM catalog.environments e INNER JOIN catalog.folders f ON e.folder_id = f.folder_id WHERE e.name = '$EnvironmentName' AND f.name = '$FolderName'"

    $envName = SQLDEPLOY\Execute-Query $envSql

    if ( $EnvironmentName -eq $envName.name )
    {
        Write-Warning "Environment with name $name already exists, skipping create.."
        return
    }

    $variables = "foldername = '$FolderName'", "environmentname = '$EnvironmentName'", "Description = '$Description'"

    $createSql = "EXEC catalog.create_environment @environment_name=`$(EnvironmentName), @environment_description=`$(Description), @folder_name=`$(FolderName)"

    $result = SQLDEPLOY\Execute-Procedure $createSql $variables

    SQLDEPLOY\Check-Error $result "Environment create failed with code $result" 2

    Set-Location $currentLocation
}

function Remove-Environment()
{
    <#
        .SYNOPSIS
        Removes an SSIS Catalog environment
        .DESCRIPTION
        The Remove-Environment function removes the environment

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$EnvironmentName,
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $variables = "foldername = '$FolderName'", "environmentname = '$EnvironmentName'"

    $sql = "EXEC catalog.delete_environment @folder_name=`$(FolderName), @environment_name=`$(EnvironmentName)"

    $result = SQLDEPLOY\Execute-Procedure $sql $variables

    SQLDEPLOY\Check-Error $result "Environment remove failed with code $result" 2

    Set-Location $currentLocation
}

function New-EnvironmentVariable()
{
    <#
        .SYNOPSIS
        Creates an SSIS Catalog environment variable
        .DESCRIPTION
        The New-EnvironmentVariable creates the variable if it doesn't exist, and updates it if it does

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$EnvironmentName,
        [Parameter(Mandatory=$false)][string]$Description="",
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$VariableName,
        [Parameter(Mandatory=$true)][string]$DataType,
        [Parameter(Mandatory=$true)][AllowEmptyString()][AllowNull()][string]$Value,
        [Parameter(Mandatory=$true)][boolean]$Sensitive,
		[Parameter(Mandatory=$true)][boolean]$OverWrite,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd
	
    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

	if ($OverWrite -and [string]::IsNullOrEmpty($Value)) {
		Throw "Value for $VariableName cannot be empty"
	}
	else {
		if ( $DataType -eq 'String')
		{
			$valueParam = "N'$Value'"
		}
		else
		{
			$valueParam = "$Value"
		}
	}

    $envSql = "SELECT ev.name FROM catalog.environment_variables ev INNER JOIN catalog.environments e ON ev.environment_id = e.environment_id INNER JOIN catalog.folders f ON e.folder_id = f.folder_id WHERE e.name = '$EnvironmentName' AND ev.name = '$VariableName' AND f.name = '$FolderName'"

    $varName = SQLDEPLOY\Execute-Query $envSql

    $sb = New-Object -TypeName "System.Text.StringBuilder"

    if ( $VariableName -eq $varName.name )
    {

	    if ($OverWrite)
    	{
			$sb.Append('EXEC catalog.set_environment_variable_value ') | Out-Null
			$sb.Append("@folder_name = '$FolderName', ") | Out-Null
			$sb.Append("@environment_name='$EnvironmentName', ") | Out-Null
			$sb.Append("@variable_name='$VariableName', ") | Out-Null
			$sb.Append("@value = $valueParam") | Out-Null

			$result = SQLDEPLOY\Execute-Query $sb.ToString()
		}
    }
    else
    {
        $sb.Append('EXEC catalog.create_environment_variable ') | Out-Null
        $sb.Append("@folder_name='$FolderName', ") | Out-Null
        $sb.Append("@environment_name='$EnvironmentName', ") | Out-Null
        $sb.Append("@variable_name='$VariableName', ") | Out-Null
        $sb.Append("@data_type='$DataType', ") | Out-Null
        $sb.Append("@sensitive=$Sensitive, ") | Out-Null
        $sb.Append("@value = $valueParam, ") | Out-Null
        $sb.Append("@description='$Description'") | Out-Null

		$result = SQLDEPLOY\Execute-Query $sb.ToString()
    }

    
    SQLDEPLOY\Check-Error $result "Environment variable create failed with code $result" 3

    Set-Location $currentLocation
}

function Remove-EnvironmentVariable()
{
    <#
        .SYNOPSIS
        Removes an SSIS Catalog environment variable
        .DESCRIPTION
        The Remove-EnvironmentVariable removes the variable 

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$EnvironmentName,
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$VariableName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $variables = "foldername = '$FolderName'", "environmentname = '$EnvironmentName'", "variablename = '$VariableName'"

    $sql = "EXEC catalog.delete_environment_variable @folder_name=`$(FolderName), @environment_name=`$(EnvironmentName), @variable_name=`$(VariableName)"

    $result = SQLDEPLOY\Execute-Procedure $sql $variables
    
    SQLDEPLOY\Check-Error $result "Environment variable create failed with code $result" 3

    Set-Location $currentLocation
}

function Map-EnvironmentVariable()
{
    <#
        .SYNOPSIS
        Maps an SSIS Catalog environment variable to a package parameter with project scope
        .DESCRIPTION
        The Map-EnvironmentVariable maps environment variables to package parameters

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$ParameterName,
        [Parameter(Mandatory=$true)][string]$VariableName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $objectType = [Int16]::Parse("20")
    $valueType = [Char]::Parse("R")

    $variables = "objecttype = $objectType", "foldername = '$FolderName'", "projectname = '$ProjectName'", "parametername = '$ParameterName'", "parametervalue = '$VariableName'", "valuetype = '$valueType'"

    $setSql = "EXEC catalog.set_object_parameter_value @object_type=`$(objectType), @folder_name=`$(FolderName), @project_name=`$(ProjectName), @parameter_name=`$(ParameterName), @parameter_value=`$(parameterValue), @value_type=`$(valueType)"

    $result = SQLDEPLOY\Execute-Procedure $setSql $variables

    SQLDEPLOY\Check-Error $result "Environment variable create failed with code $result" 4

    Set-Location $currentLocation
}

function Publish-Project()
{
     <#
        .SYNOPSIS
        Publishes a SSIS project
        .DESCRIPTION
        The Publish-Project deploys an SSIS project

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)][string]$ProjectFile,
        [Parameter(Mandatory=$false,Position=1)][string]$TargetServer
    )

    $project = ReadProjectFile $ProjectFile $TargetServer

    Write-Progress "Deploying the .ispac..." -Id 1 -PercentComplete 0

    New-Folder $PATH $SERVER $INSTANCE

    Publish-Ispac $PROJECT_NAME $PATH $SERVER $INSTANCE

    if ( $project.project.integrationServices.HasChildNodes -eq $true )
    {
        $percentComplete = 50

        Write-Progress "Loading environments..." -Id 1 -PercentComplete $percentComplete

        # first we need to create the environment, then create a reference to the project, then map the parameters
        foreach( $environment in  $project.project.integrationServices.environments.environment )
        {
            $name = $environment.name

            Write-Progress "Creating environment $name"  -Id 1 -PercentComplete $percentComplete

            New-Environment $name $environment.description $PATH $SERVER $INSTANCE

            $percentComplete += 10

            Write-Progress "Creating environment reference $name"  -Id 1 -PercentComplete $percentComplete

            New-EnvironmentReference $PATH $PROJECT_NAME $name $PATH $SERVER $INSTANCE

            foreach( $var in $environment.variables.variable )
            {
                $varName = $var.name            

                $isSenstive = [Boolean]::Parse($var.sensitive)

				$OverWrite = $true
                
                $varValue = $var.value

        		if ($var.overwrite)
                {
        			$OverWrite = [Boolean]::Parse($var.overwrite)
                }

                New-EnvironmentVariable $name $var.description $PATH $varName $var.type $varValue $isSenstive $OverWrite $SERVER $INSTANCE

                if ( $percentComplete -lt 100 )     
                {
                    $percentComplete++
                }

                Write-Progress "Set environment variable $varName" -Id 1 -PercentComplete $percentComplete
            }
        }

        foreach( $parameter in $project.project.integrationServices.parameters.parameter )
        {
            $parmName = $parameter.name
            $VariableName = $parameter.variable

            Map-EnvironmentVariable $project.project.name $PATH $parmName $VariableName $SERVER $INSTANCE

            if ( $percentComplete -lt 100 )     
            {
                $percentComplete++
            }

            Write-Progress "Mapping parameter $parmName to variable $VariableName" -Id 1 -PercentComplete $percentComplete
        }

        Set-Location $CURRENT_LOCATION
    }

    Write-Progress "Completed deployed the .ispac..." -Id 1 -PercentComplete 100
}

function New-EnvironmentReference()
{
 <#
        .SYNOPSIS
        Creates an environment reference for a project
        .DESCRIPTION
        The New-EnvironmentReference function adds an environment reference to a project

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [Parameter(Mandatory=$true)][string]$EnvironmentName,
        [Parameter(Mandatory=$true)][string]$EnvironmentFolderName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd
   
    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $refsSql = 
@"
SELECT COUNT(reference_id) AS cnt
FROM catalog.environment_references er
INNER JOIN catalog.projects p ON er.project_id = p.project_id
WHERE name = `$(ProjectName)
AND environment_name = `$(EnvironmentName)
"@
  
    $refsVariables = "projectname = '$ProjectName'", "environmentname = '$EnvironmentName'"

    $result = Invoke-Sqlcmd -Query $refsSql -Variable $refsVariables

    if ( $result.cnt -eq 0 )
    {
        $sql = "EXEC catalog.create_environment_reference @folder_name=`$(FolderName), @project_name=`$(ProjectName), @environment_name=`$(EnvironmentName), @reference_type='A', @environment_folder_name=`$(EnvironmentFolderName), @reference_id=0"

        $variables = "foldername = '$FolderName'", "projectname = '$ProjectName'", "environmentname = '$EnvironmentName'", "environmentfoldername = '$EnvironmentFolderName'"

        $result = SQLDEPLOY\Execute-Procedure $sql $variables

        SQLDEPLOY\Check-Error $result "Environment reference create failed with code $result" 5
    }

    Set-Location $currentLocation
}

function Remove-EnvironmentReference()
{
 <#
        .SYNOPSIS
        Removes an environment reference for a project
        .DESCRIPTION
        The Remove-EnvironmentReference function removes an environment reference to a project

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [Parameter(Mandatory=$true)][string]$EnvironmentName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd
   
    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $refsSql = 
@"
SELECT reference_id 
FROM catalog.environment_references er
INNER JOIN catalog.projects p ON er.project_id = p.project_id
WHERE name = `$(ProjectName)
AND environment_name = `$(EnvironmentName)
"@
  
    $refsVariables = "projectname = '$ProjectName'", "environmentname = '$EnvironmentName'"

    $referenceId = Invoke-Sqlcmd -Query $refsSql -Variable $refsVariables

    $sql = "EXEC catalog.delete_environment_reference @reference_id=$referenceId"

    $result = SQLDEPLOY\Execute-Procedure $sql $variables

    SQLDEPLOY\Check-Error $result "Environment reference create failed with code $result" 5

    Set-Location $currentLocation
}

function Unpublish-Ispac ()
{
    <#
        .SYNOPSIS
        Rollsback an Ispac file 
        .DESCRIPTION
        The Unpublish-Ispac function rolls back a package using restore_project sproc

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $currentSql = "SELECT object_version_lsn FROM catalog.projects WHERE name = '$ProjectName'"

    $currentVersion = SQLDEPLOY\Execute-Query $currentSql

    $previousSql = "SELECT TOP 1 object_version_lsn FROM catalog.object_versions ov WHERE object_name = '$ProjectName' AND object_version_lsn < ( $($currentVersion.object_version_lsn) ) ORDER BY created_time DESC"

    $previousVersion = SQLDEPLOY\Execute-Query $previousSql

    $variables = "foldername = '$FolderName'", "projectname = '$ProjectName'", "version = $($previousVersion.object_version_lsn)"

    $rollback = "EXEC catalog.restore_project @folder_name=`$(FolderName), @project_name=`$(ProjectName), @object_version_lsn=`$(version)"

    $result = SQLDEPLOY\Execute-Procedure $rollback $variables

    $currentVersion = SQLDEPLOY\Execute-Query $currentSql

    if ( $($currentVersion.object_version_lsn) -ne $($previousVersion.object_version_lsn) )
    {
        Write-Error "Project rollback failed current version is $currentVersion.object_version_lsn" -Category InvalidResult
        exit 99
    }

    Set-Location $currentLocation
}

function Unpublish-Project()
{
     <#
        .SYNOPSIS
        Rollsback a SSIS project
        .DESCRIPTION
        The Unpublish-Project function rolls back a project

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)][string]$ProjectFile,
        [Parameter(Mandatory=$false,Position=1)][string]$TargetServer
    )

    ReadProjectFile $ProjectFile $TargetServer

    $CURRENT_LOCATION = $PWD

    Unpublish-Ispac $PROJECT_NAME $PATH $SERVER $INSTANCE
}

function New-Folder()
{
    <#
        .SYNOPSIS
        Creates a folder in the SSIS Catalog
        .DESCRIPTION
        The New-Folder function creates a folder in the SSIS Catalog

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $currentLocation = $pwd

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance
    Set-Location $sqlLocation | Out-Null

    $fldSql = "SELECT COUNT(name) AS cnt FROM catalog.folders WHERE name = '$FolderName'"
  
    $result = SQLDEPLOY\Execute-Query $fldSql

    if ( $result.cnt -eq 0 )
    {
        $sql = "EXEC catalog.create_folder @folder_name=`$(FolderName)"

        $variables = "foldername = '$FolderName'"

        $result = SQLDEPLOY\Execute-Procedure $sql $variables

        SQLDEPLOY\Check-Error $result "Folder create failed with code $result" 4
    }

    Set-Location $currentLocation
}

function Get-EnvironmentReference
{
	<#
        .SYNOPSIS
        Gets an environment reference based on the environment name
        .DESCRIPTION
        Gets an environment reference based on the environment name

    #>
    [CmdletBinding()]
    param (
    [Parameter(Mandatory=$true)][string]$Environment,
    [Parameter(Mandatory=$true)][string]$FolderName,
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$false)][string]$Instance = "default"
    )

    $sqlLocation = SQLDEPLOY\Get-SqlLocation $Server $Instance

    Set-Location $sqlLocation | Out-Null

    $refSql = "SELECT reference_id FROM catalog.environment_references WHERE environment_name = '$Environment' AND environment_folder_name = '$FolderName'" 

    $result = SQLDEPLOY\Execute-Query $refSql

    $refId = $result.reference_id

    $refId
}

function New-ErrorLogTable
{
	<#
        .SYNOPSIS
        Creates and error log table for the SSIS error log destination
        .DESCRIPTION
        Creates and error log table for the SSIS error log destination

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

	$sql = 
@"
CREATE TABLE [dbo].[$LogName](
	[ErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[PackageName] [varchar](200) NULL,
	[TaskName] [varchar](200) NULL,
	[ErrorCode] [int] NULL,
	[ErrorDescription] [varchar](500) NULL,
	[ErrorColumn] [int] NULL,
	[ErrorDTTM] [datetime] NULL,
	[ErrorRowValues] [xml] NULL
)
"@

	$result = SQLDEPLOY\Execute-Query $sql

	SQLDEPLOY\Check-Error $result "Log table create failed with code $result" 1

	Pop-Location
}

function Install-ErrorLogDestination()
{
    <#
        .SYNOPSIS
        Installs the DateTransform
        .DESCRIPTION
        Installs the DateTransform
    #>

    [CmdletBinding()]
    PARAM(
        [Parameter(Mandatory=$false,Position=0)][string]$DllPath = $pwd
	)

    $dll = "ErrorLogDestination.dll"

    Write-Verbose "Registering Error Log Destination..."

    $componentPath = Join-Path $DllPath $dll

    $dtsPath = "${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DTS\PipelineComponents\$dll"

    $exists = Test-Path $dtsPath

    [System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") | Out-Null
    $pub = New-Object System.EnterpriseServices.Internal.Publish

    if ( $exists ) 
    {
        $pub.GacRemove($dtsPath)
    }
    
    Copy-Item $componentPath $dtsPath
    $pub.GacInstall($dtsPath)
}