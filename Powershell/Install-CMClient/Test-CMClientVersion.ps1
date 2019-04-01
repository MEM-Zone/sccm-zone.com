<#
.SYNOPSIS
    Tests the configuration manager client version.
.DESCRIPTION
    Tests if the configuration manager client version is greater than the configuration manager deployed application version.
    Returns 'Compliant' if the condition is satisfied.
.PARAMETER ApplicationName
    Specify the configuration manager application name to be used for detection.
.EXAMPLE
    Powershell.exe -File Test-CMClientVersion.ps1 -ApplicationName 'SomeAplicationName'
.INPUTS
    System.String.
.OUTPUTS
    System.String.
    None.
.NOTES
    Created by Ioan Popovici
    Must define the SCCM aplication name used.
    Works only if the application is deployed.
    Deprecated Get-WMIObject is used for backwards compatibility.
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
    Test Configuration Manager Client version
#>

##*=============================================
##* VARIABLE DECLARATION
##*=============================================
#region VariableDeclaration

## Get script parameters
Param (
    [Parameter(Mandatory=$false, HelpMessage = 'You need to input a Application Name', Position = 0)]
    [ValidateNotNullorEmpty()]
    [Alias('App')]
    [string]$ApplicationName = 'Configuration Manager Client'
)

#endregion
##*=============================================
##* END VARIABLE DECLARATION
##*=============================================

##*=============================================
##* SCRIPT BODY
##*=============================================
#region ScriptBody

## Configuration Manager Client version comparison
Try {
    [System.Version]$InstalledVersion = (Get-WMIObject -Namespace 'ROOT\ccm' -Class 'SMS_Client' -ErrorAction 'Stop').ClientVersion
    [System.Version]$DeployedVersion = Get-WMIObject -Namespace 'ROOT\ccm\ClientSDK' -Class 'CCM_Application' -ErrorAction 'Stop' | Where-Object {
        $_.FullName -like "*$ApplicationName*"
    } | Select-Object -ExpandProperty 'SoftwareVersion'
}
Catch {

    ## Not Installed
}
Finally {
    If ($DeployedVersion -and ($InstalledVersion -ge $DeployedVersion)){
        Write-Output -InputObject 'Detected'
    }
}

#endregion
##*=============================================
##* END SCRIPT BODY
##*=============================================