<#
.SYNOPSIS
    Copies the configuration manager client logs.
.DESCRIPTION
    Copies the configuration manager client logs to a specified path.
.PARAMETER Path
    Specifies the path to copy the log files to.
.EXAMPLE
    Copy-CMClientLogs.ps1 -Share '\\SomePath'
.INPUTS
    System.String.
.OUTPUTS
    System.String.
.NOTES
    Created by Ioan Popovici
.LINK
    https://SCCM.Zone/Copy-CMClientLogs
.LINK
    https://SCCM.Zone/Copy-CMClientLogs-CHANGELOG
.LINK
    https://SCCM.Zone/Copy-CMClientLogs-GIT
.LINK
    https://SCCM.Zone/Issues
.COMPONENT
    Configuration Manager Client
.FUNCTIONALITY
    Copy Client Logs
#>

## Set script requirements
#Requires -Version 3.0

##*=============================================
##* VARIABLE DECLARATION
##*=============================================
#region VariableDeclaration

## Get script parameters
Param (
    [Parameter(Mandatory=$true,HelpMessage="You need to input a share",Position=0)]
    [ValidateNotNullorEmpty()]
    [Alias('pt')]
    [string]$Path
)

#endregion
##*=============================================
##* END VARIABLE DECLARATION
##*=============================================

##*=============================================
##* FUNCTION LISTINGS
##*=============================================
#region FunctionListings

#region Function Copy-CMClientLogs
Function Copy-CMClientLogs {
<#
.SYNOPSIS
    Copies the configuration manager client logs.
.DESCRIPTION
    Copies the configuration manager client logs to a specified path.
.PARAMETER Path
    Specifies the path to copy the log files to.
.EXAMPLE
    Copy-CMClientLogs -Path '\\SomePath'
.INPUTS
    System.String.
.OUTPUTS
    System.String.
.NOTES
    This is an internal script function and should typically not be called directly.
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Git
.COMPONENT
    Configuration Manager Client
.FUNCTIONALITY
    Copy Client Logs
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,HelpMessage='You need to input path',Position=0)]
        [ValidateNotNullorEmpty()]
        [Alias('pt')]
        [string]$Path
    )

    Begin {

        ## Set script to fail on any error
        $ErrorActionPreference = 'Stop'

        ## Import BITS transfer module
        Import-Module -Name 'BitsTransfer' -Force
    }
    Process {
        Try {

            ## Check if share exists
            [boolean]$PathExists = Test-Path -Path $Path
            If (-not $PathExists ) { Throw "Path [$Path] does not exist." }

            ## Get path for CM client log files
            [string]$LogPath = (Get-ItemProperty -Path 'HKLM:\Software\Microsoft\CCM\Logging\@Global').LogDirectory

            ## Copy logs to temporary folder to remove  any locks
            #  Assemble temp log path
            [string]$LogPathTemp = Join-Path -Path $env:Temp -ChildPath 'CMLogs'
            #  Delete temp folder if it already exists
            [boolean]$TempFolderExist = Test-Path $LogPathTemp
            If ($TempFolderExist) { Remove-Item $LogPathTemp -Recurse -Force }
            #  Create temp folder
            $null = New-Item -Path $LogPathTemp -ItemType 'Directory' -Force
            #  Copy logs to temporary folder
            $null = Copy-Item -Path "$LogPath\*" -Destination $LogPathTemp -Force

            ## Compress the logs
            #  Set archive name
            [string]$LogArchivePath = $env:Temp + '\' + $env:ComputerName + '_CMCLogs.zip'
            Add-Type -assembly "system.io.compression.filesystem"
            $null = [IO.Compression.ZipFile]::CreateFromDirectory($LogPathTemp, $LogArchivePath)

            ## Copy zipped logs to share
            $LogPathDestination = Join-Path $Path -ChildPath $env:ComputerName
            #  Create destination folder
            $null = New-Item -Path $LogPathDestination -ItemType 'Directory' -Force
            #  Copy files to destination
            Start-BitsTransfer -Source $LogArchivePath -Destination $LogPathDestination -Description 'Copy client logs...' -DisplayName 'Copy'

            Write-Output -InputObject "Successfuly copied [$env:ComputerName + '\' + $LogPath] to path [$Path]."
        }
        Catch {
            Write-Output -InputObject "Could not copy logs [$env:ComputerName +'\' + $LogPath] to path [$Path]. `n $_"
        }
        Finally {

            ## Cleanup temporary files and folders from CM client
            Remove-Item $LogPathTemp -Recurse -Force -ErrorAction 'SilentlyContinue'
            Remove-Item -Path $LogArchivePath -Force -ErrorAction 'SilentlyContinue'
        }
    }
    End {
    }
}
#endregion

#endregion
##*=============================================
##* END FUNCTION LISTINGS
##*=============================================

##*=============================================
##* SCRIPT BODY
##*=============================================
#region ScriptBody

Copy-CMClientLogs -Path $Path

#endregion
##*=============================================
##* END SCRIPT BODY
##*=============================================