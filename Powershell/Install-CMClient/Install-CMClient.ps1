<#
.SYNOPSIS
    Installs the configuration manager client.
.DESCRIPTION
    Installs the configuration manager client using the script location as source.
.EXAMPLE
    Powershell.exe -File Install-CMClient.ps1 -ExecutionPolicy 'Bypass' -WindowStyle 'Hidden'
.INPUTS
    None.
.OUTPUTS
    None.
.NOTES
    Created by Ioan Popovici
    Does not work if site details are not published in AD.
    Does not work for workgroup computers.
    Should work with PowerShell 2.0.
.LINK
    https://SCCM.Zone/Test-CMClientVersion
.LINK
    https://SCCM.Zone/Test-CMClientVersion-GIT
.LINK
    https://SCCM.Zone/Issues
.COMPONENT
    Configuration Manager
.FUNCTIONALITY
    Configuration Manager Client Installation
#>

##*=============================================
##* VARIABLE DECLARATION
##*=============================================
#region VariableDeclaration

## Get script path
[string]$ScriptPath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

#endregion
##*=============================================
##* END VARIABLE DECLARATION
##*=============================================

##*=============================================
##* SCRIPT BODY
##*=============================================
#region ScriptBody

## Install sccm Client
Start-Process -FilePath 'CCMSETUP.EXE' -ArgumentList "/Source:$ScriptPath /NoService SMSSITECODE=AUTO" -NoNewWindow -Wait

#endregion
##*=============================================
##* END SCRIPT BODY
##*=============================================