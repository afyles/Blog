function Publish-DacpacProject()
{
    <#
        .SYNOPSIS
        Publishes a Dacpac file to SQL using SqlPackage.exe
        .DESCRIPTION
        The Publish-Dacpac function publishes a dacpac to SQL

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)][string]$Profile,
        [Parameter(Mandatory=$false,Position=1)][string]$TargetServer
    )

    Write-Progress "Deploying the .dacpac..." -Id 1 -PercentComplete -1

    ReadProfile $Profile $TargetServer

    Publish-Dacpac -Server $SERVER -Database $DATABASE -DacPacPath "$PACKAGE.dacpac" -Variables $SQLCMDVARS -Options $OPTIONS
}

function Publish-Dacpac()
{
    <#
        .SYNOPSIS
        Publishes a Dacpac file to SQL using SqlPackage.exe
        .DESCRIPTION
        The Publish-Dacpac function publishes a dacpac to SQL

    #>
    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true,Position=0)][string]$Server,
        [Parameter(Mandatory=$true,Position=1)][string]$Database,
        [Parameter(Mandatory=$true,Position=2)][string]$DacPacPath,
        [Parameter(Mandatory=$false,Position=3)][array]$Variables,
        [Parameter(Mandatory=$false,Position=3)][array]$Options
    )

    $sqlPkg = "${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin\SqlPackage.exe"
    & "$sqlPkg" /Action:Publish $Options /SourceFile:"$DacPacPath" /TargetServerName:$Server /TargetDatabaseName:$Database $Variables

    if ($lastexitcode -eq 0)
    {
        Write-Progress "Successfully deployed DacPac: $DacPacPath to $Server/$Database"  -Id 1 -PercentComplete -1
    }
    else
    {
        Write-Error "DacPac deploy failed miserably"
    }
}

function ReadProfile( $profileFile, $target )
{
    $fileExists = Test-Path "$profileFile"
            
    if ( $fileExists -eq $true )
    {
        [xml]$profileFile = Get-Content "$profileFile"
        $script:DATABASE = $profileFile.project.database
        $script:PACKAGE = $profileFile.project.name

        if ( $target )
        {
            $script:SERVER = $target
        }
        else
        {
            $script:SERVER = $profileFile.project.server
        }

        $script:SERVER

        $options = @()
        if ($profileFile.project.options.HasChildNodes) {
            $profileFile.project.options.ChildNodes | foreach { $options += [String]::Format("/p:{0}={1} ", $_.name, $_.value) }
        }
        $options
        $script:OPTIONS = $options

        $vars = @()
        if ($profileFile.project.variables.HasChildNodes) {
            $profileFile.project.variables.ChildNodes | foreach { $vars += [String]::Format("/Variables:{0}={1} ", $_.name, $_.value) }
        }
        $vars
        $script:SQLCMDVARS = $vars 
    }  
    else
    {
        Write-Error "Profile file does not exist, exiting..."
        exit
    }
}


function New-DeploymentPreview()
{
     <#
        .SYNOPSIS
        Publishes a Dacpac preview using SqlPackage.exe
        .DESCRIPTION
        The New-DeploymentPreview function generates deployment report and a script for review

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)][string]$Profile,
        [Parameter(Mandatory=$false,Position=1)][string]$TargetServer
    )
    
    ReadProfile $Profile $TargetServer

    New-DeployReport $SERVER $DATABASE "$PACKAGE.dacpac" $SQLCMDVARS $OPTIONS

    New-SqlScript $SERVER $DATABASE "$PACKAGE.dacpac" $SQLCMDVARS $OPTIONS
}

function New-DeployReport()
{
    <#
        .SYNOPSIS
        Generates a deploy report using SqlPackage.exe
        .DESCRIPTION
        The New-DeployReport function generates a new deployment report

    #>
    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true,Position=0)][string]$Server,
        [Parameter(Mandatory=$true,Position=1)][string]$Database,
        [Parameter(Mandatory=$true,Position=2)][string]$DacPacPath,
        [Parameter(Mandatory=$false,Position=3)][array]$Variables,
        [Parameter(Mandatory=$false,Position=4)][array]$Options
    )

    $sqlPkg = "${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin\SqlPackage.exe"

    & "$sqlPkg" /Action:DeployReport $Options /OutputPath:"$pwd/$Database.xml" /SourceFile:"$DacPacPath" /TargetServerName:$Server /TargetDatabaseName:$Database $Variables

}

function New-SqlScript()
{
<#
        .SYNOPSIS
        Generates a deploy report using SqlPackage.exe
        .DESCRIPTION
        The New-DeploymentPreview function generates a new deployment report

    #>
    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true,Position=0)][string]$Server,
        [Parameter(Mandatory=$true,Position=1)][string]$Database,
        [Parameter(Mandatory=$true,Position=2)][string]$DacPacPath,
        [Parameter(Mandatory=$false,Position=3)][array]$Variables,
        [Parameter(Mandatory=$false,Position=4)][array]$Options
    )

    $sqlPkg = "${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin\SqlPackage.exe"

    & "$sqlPkg" /Action:Script $Options /OutputPath:"$pwd/$Database.sql" /SourceFile:"$DacPacPath" /TargetServerName:$Server /TargetDatabaseName:$Database $Variables
}