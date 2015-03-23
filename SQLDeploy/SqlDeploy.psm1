function Check-Error( $result, [string]$message, [int]$exitCode )
{
    if ( $result -ne $null -and $result -ne 0)
    {
        Write-Error $message -Category InvalidResult
        exit $exitCode
    }
}

function Get-SqlLocation( $server, $instance )
{
    [String]::Format("SQLSERVER:\SQL\{0}\{1}\Databases\SSISDB", $server, $instance)
}

function Execute-Query( [string]$query )
{
    return Invoke-Sqlcmd -Query "$query" -SuppressProviderContextWarning
}

function Execute-Procedure( [string]$command, $variables )
{
    if ( $variables )
    {
        return Invoke-Sqlcmd -Query "$command" -Variable $variables -SuppressProviderContextWarning
    }   
    else
    {
        return Invoke-Sqlcmd -Query "$command" -SuppressProviderContextWarning
    }
}

function Import-SqlModule()
{
    $SQL_MODULE = "sqlps"

    Write-Progress "Loading SQL Server module..." -Id 1 -PercentComplete -1

    if ( -not( Get-Module -Name $SQL_MODULE ))
    {
        if ( Get-Module -ListAvailable | Where-Object { $_.Name -eq $SQL_MODULE } )
        {
            Import-Module $SQL_MODULE -DisableNameChecking
        }
        else
        {
            Write-Warning "The SQL Server PowerShell module (SQLPS) is required, please install"
        }
    }
}





