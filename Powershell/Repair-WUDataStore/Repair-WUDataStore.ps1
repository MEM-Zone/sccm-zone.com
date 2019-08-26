<#
.SYNOPSIS
    Repairs a corrupted WU DataStore.
.DESCRIPTION
    Detects and repairs a corrupted WU DataStore.
    Detection is done by testing the eventlog with the specified parameters.
    Repairs are performed by removing and reinitializing the corrupted DataStore.
    The specified eventlog is backed up and cleared in order not to triger the detection again before the repair step.
    The backup of the specified eventlog is stored in 'SystemRoot\Temp' folder.
    Defaults are configured for the ESENT '623' error.
.PARAMETER Action
    Specifies the action to be performed. Available actions are: ('DetectAndRepair', 'Detect', 'Repair','RepairStandalone').
    'DetectAndRepair'  - Performs detection and then performs repairs if necessary.
    'Detect'           - Performs detection and returns the result.
    'Repair'           - Performs repairs and flushes the specified EventLog.
    'RepairStandalone' - Performs repairs only.
.PARAMETER LogName
    Specifies the LogName to search. Default is: 'Application'
.PARAMETER Source
    Specifies the Source to search. Default is: 'ESENT'
.PARAMETER EventID
    Specifies the EventID to search. Default is: '623'
.PARAMETER EntryType
    Specifies the Entry Type to search. Available options are: ('Information','Warning','Error'). Default is: 'Error'.
.PARAMETER LimitDays
    Specifies the number of days from the current date to limit the search to. Default is: 3.
.PARAMETER Threshold
    Specifed the numbers of events after which this functions returns $true. Default is: 3.
.EXAMPLE
    Repair-WUDataStore.ps1 -Action 'Detect' -LogName 'Application' -Source 'ESENT' -EventID '623' -EntryType 'Error' -LimitDays 3 -Threshold 3
.INPUTS
    System.String.
.OUTPUTS
    System.String. This script returns Compliant, Non-Compliant, Remediated or Error Message
.NOTES
    Created by Ioan Popovici
    This script can be called directly.
.LINK
    https://SCCM.Zone/Repair-WUDataStore
.LINK
    https://SCCM.Zone/Repair-WUDataStore-CHANGELOG
.LINK
    https://SCCM.Zone/Repair-WUDataStore-GIT
.LINK
    https://SCCM.Zone/Issues
.COMPONENT
    WindowsUpdate
.FUNCTIONALITY
    Repair
#>

## Set script requirements
#Requires -Version 3.0

##*=============================================
##* VARIABLE DECLARATION
##*=============================================
#region VariableDeclaration

## Get script parameters
Param (
    [Parameter(Mandatory=$true,Position=0)]
    [ValidateNotNullorEmpty()]
    [ValidateSet('DetectAndRepair','Detect','Repair','RepairStandalone')]
    [string]$Action,
    [Parameter(Mandatory=$false,Position=1)]
    [ValidateNotNullorEmpty()]
    [string]$LogName = 'Application',
    [Parameter(Mandatory=$false,Position=2)]
    [ValidateNotNullorEmpty()]
    [string]$Source = 'ESENT',
    [Parameter(Mandatory=$false,Position=3)]
    [ValidateNotNullorEmpty()]
    [string]$EventID = '623' ,
    [Parameter(Mandatory=$false,Position=4)]
    [ValidateNotNullorEmpty()]
    [string]$EntryType = 'Error',
    [Parameter(Mandatory=$false,Position=5)]
    [ValidateNotNullorEmpty()]
    [int]$LimitDays = 3,
    [Parameter(Mandatory=$false,Position=6)]
    [ValidateNotNullorEmpty()]
    [int]$Threshold = 3
)

#endregion
##*=============================================
##* END VARIABLE DECLARATION
##*=============================================

##*=============================================
##* FUNCTION LISTINGS
##*=============================================
#region FunctionListings

#region Function Test-EventLogCompliance
Function Test-EventLogCompliance {
<#
.SYNOPSIS
    Tests the EventLog compliance for specific events.
.DESCRIPTION
    Tests the EventLog compliance by getting events and returing a Non-Compliant statement after a specified treshold is reached.
.PARAMETER LogName
    Specifies the LogName to search.
.PARAMETER Source
    Specifies the Source to search.
.PARAMETER EventID
    Specifies the EventID to search.
.PARAMETER EntryType
    Specifies the Entry Type to search. Available options are: ('Information','Warning','Error'). Default is: 'Error'.
.PARAMETER LimitDays
    Specifies the number of days from the current date to limit the search to.
    Default is: 1.
.PARAMETER Threshold
    Specifed the numbers of events after which this functions returns $true.
.EXAMPLE
    Test-EventLogCompliance -LogName 'Application' -Source 'ESENT' -EventID '623' -EntryType 'Error' -LimitDays 3 -Threshold 3
.INPUTS
    None.
.OUTPUTS
    System.Boolean.
.NOTES
    This function can typically be called directly.
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Git
.COMPONENT
    WindowsUpdate
.FUNCTIONALITY
    Test
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$LogName,
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullorEmpty()]
        [string]$Source,
        [Parameter(Mandatory=$true,Position=2)]
        [ValidateNotNullorEmpty()]
        [string]$EventID,
        [Parameter(Mandatory=$false,Position=3)]
        [ValidateSet('Information','Warning','Error')]
        [string]$EntryType = 'Error',
        [Parameter(Mandatory=$false,Position=4)]
        [ValidateNotNullorEmpty()]
        [int]$LimitDays = 1,
        [Parameter(Mandatory=$true,Position=5)]
        [ValidateNotNullorEmpty()]
        [int]$Threshold
    )

    Try {

        ## Set day limit by substracting number of days from the current date
        $After = $((Get-Date).AddDays( - $LimitDays ))

        ## Get events and test treshold
        $Events = Get-EventLog -ComputerName $env:COMPUTERNAME -LogName $LogName -Source $Source -EntryType $EntryType -After $After -ErrorAction 'Stop' | Where-Object { $_.EventID -eq $EventID }

        If ($Events.Count -ge $Threshold) {
            $Compliance = 'Non-Compliant'
        }
        Else {
            $Compliance = 'Compliant'
        }
    }
    Catch {

        ## Set result as 'Compliant' if no matches are found
        If ($($_.Exception.Message) -match 'No matches found') {
            $Compliance =  'Compliant'
        }
        Else {
            $Compliance = "Eventlog [$EventLog] compliance test error. $($_.Exception.Message)"
        }
    }
    Finally {

        ## Return Compliance result
        Write-Output -InputObject $Compliance
    }
}
#endregion

#region Function Backup-EventLog
Function Backup-EventLog {
<#
.SYNOPSIS
    Backs-up an Event Log.
.DESCRIPTION
    Backs-up an Event Log using the BackUpEventLog Cim method.
.PARAMETER LogName
    Specifies the event log to backup.
.PARAMETER BackupPath
    Specifies the Backup Path. Default is: '$Env:SystemRoot\Temp'.
.PARAMETER BackupName
    Specifies the Backup name. Default is: 'yyyy-MM-dd_HH-mm-ss_$Env:ComputerName_$LogName'.
.EXAMPLE
    Backup-EventLog -LogName 'Application' -BackupPath 'C:\SCCMZone' -BackupName '1980-09-09_10-10-00_SCCMZoneBlog_Application'
.INPUTS
    System.String.
.OUTPUTS
    None. This function has no outputs.
.NOTES
    This function can typically be called directly.
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Git
.COMPONENT
    EventLog
.FUNCTIONALITY
    Backup
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$LogName,
        [Parameter(Mandatory=$false,Position=1)]
        [ValidateNotNullorEmpty()]
        [string]$BackupPath,
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateNotNullorEmpty()]
        [string]$BackupName
    )

    Begin {

        ## Setting variables
        [int]$PowerShellVersion = $PSVersionTable.PSVersion.Major
        [datetime]$Date = $(Get-Date -f 'yyyy-MM-dd_HH-mm-ss')
        #  Setting optional parameters
        If (-not $BackupPath) {
            $BackupPath = $(Join-Path -Path $Env:SystemRoot -ChildPath '\Temp')
        }
        If (-not $BackupFileName) {
            [string]$BackUpFileName = "{0}_{1}_{2}.evtx" -f $Date, $Env:COMPUTERNAME, $LogName
        }
        #  Setting backup arguments
        [hashtable]$BackupArguments = @{ ArchiveFileName = (Join-Path -Path $BackupPath -ChildPath $BackUpFileName) }
    }
    Process {
        Try {

            If ($PowerShellVersion -eq 2) {
                ## Get event log
                $EventLog = Get-WmiObject -Class 'Win32_NtEventLogFile' -Filter "LogFileName = '$LogName'" -ErrorAction 'SilentlyContinue'

                If (-not $EventLog) {
                    Throw 'EventLog not found.'
                }

                ## Backup event log
                $BackUp = $EventLog | Invoke-WmiMethod -Name 'BackupEventLog' -ArgumentList $BackupArguments -ErrorAction 'SilentlyContinue'

                If ($BackUp.ReturnValue -ne 0) {
                    Throw "Backup retuned $($BackUp.ReturnValue)."
                }
            }
            ElseIf ($PowerShellVersion -ge 3) {
                ## Get event log
                $EventLog = Get-CimInstance -ClassName 'Win32_NtEventLogFile' -Filter "LogFileName = '$LogName'" -ErrorAction 'SilentlyContinue'

                If (-not $EventLog) {
                    Throw 'EventLog not found.'
                }

                ## Backup event log
                $BackUp = $EventLog | Invoke-CimMethod -Name 'BackupEventLog' -Arguments $BackupArguments -ErrorAction 'SilentlyContinue'

                If ($BackUp.ReturnValue -ne 0) {
                    Throw "Backup retuned $($BackUp.ReturnValue)."
                }
            }
            Else {
                Throw "PowerShell version [$PowerShellVersion] not supported."
            }
        }
        Catch {
            Write-Output -InputObject "Backup EventLog [$LogName] error. $_"
        }
    }
    End {
    }
}
#endregion

#region Function Repair-WUDataStore
Function Repair-WUDataStore {
<#
.SYNOPSIS
    Repairs a corrupted WU DataStore.
.DESCRIPTION
    Repairs a corrupted WU DataStore by removing and reinitializing the corrupted DataStore.
.EXAMPLE
    Repair-WUDataStore
.INPUTS
    None. This function has no inputs.
.OUTPUTS
    None. This function has no outputs.
.NOTES
    This function can typically be called directly.
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Git
.COMPONENT
    WindowsUpdate
.FUNCTIONALITY
    Repair
#>

    Try {

        #  Setting Paths
        [string]$PathRegsvr = (Join-Path -Path $Env:SystemRoot -ChildPath '\System32\Regsvr32.exe')
        [string]$PathDataStore = (Join-Path -Path $Env:SystemRoot -ChildPath '\SoftwareDistribution\DataStore')

        ## Re-register wuauend.dll
        $null = Start-Process -FilePath $PathRegsvr -ArgumentList '/s Wuaueng.dll' -Wait -ErrorAction 'SilentlyContinue'

        ## Stop the windows update service
        $null = Stop-Service -Name 'wuauserv' -Force -ErrorAction 'SilentlyContinue'

        ## Wait for the windows update service to stop
        #  Setting Loop index to 12 (one minute)
        [int]$Loop = 1
        While ($StatusWuaService -ne 'Stopped') {

            #  Waiting 10 seconds
            $null = Start-Sleep -Seconds 10

            #  Get windows update service status
            [string]$StatusWuaService =  (Get-Service -Name 'wuauserv').Status

            #  Try to kill process if service has not stopped within 4 minutes
            If ($Loop -eq 24) {

                #  Use powershell legacy
                If ($PowerShellVersion -eq 2) {
                    #  Get update service PID
                    [string]$PID = Get-WmiObject -Class 'Win32_Service' -Filter "Name = 'wuauserv'" | Select-Object -ExpandProperty 'ProcessId' -ErrorAction 'SilentlyContinue'
                    #  Kill process if PID is found
                    If ($PID -and $PID -ne '0') {
                        Start-Process -FilePath 'taskkill.exe' -ArgumentList "/f /pid $PID" -Wait -ErrorAction 'SilentlyContinue'
                    }
                }

                #  Use current powershell
                ElseIf ($PowerShellVersion -ge 3) {
                    #  Get update service PID
                    [string]$PID = Get-CimInstance -ClassName 'Win32_Service' -Filter "Name = 'wuauserv'" | Select-Object -ExpandProperty 'ProcessId' -ErrorAction 'SilentlyContinue'
                    #  Kill process if PID is found
                    If ($PID -and $PID -ne '0') {
                        Stop-Process -ID $PID -Force -ErrorAction 'SilentlyContinue'
                    }
                }
            }

            #  Throw error if service has not stopped within 5 minutes
            If ($Loop -ge 30) {
                Throw 'Failed to stop WuaService within 5 minutes.'
            }

            #  Incrementing loop index
            $Loop++
        }

        ## Remove the Windows update DataStore
        Remove-Item -Path $PathDataStore -Recurse -Force -ErrorAction 'Stop' | Out-Null

        ## Start the windows update service
        Start-Service -Name 'wuauserv' -ErrorAction 'SilentlyContinue'

        ## Set result to 'Remediated'
        [string]$RepairWuDatastore = 'Remediated'
    }
    Catch {
        [string]$RepairWuDatastore = "WUDataStore repair error. $($_.Exception.Message)"
    }
    Finally {

        ## Return result
        Write-Output -InputObject $RepairWuDatastore
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

Switch ($Action) {
    'DetectAndRepair' {

        ## Get machine compliance
        [string]$ESENTError623 = Test-EventLogCompliance -LogName $LogName -Source $Source -EventID $EventID -EntryType $EntryType -LimitDays $LimitDays -Threshold $Threshold

        ## Start processing if compliance test returns 'Non-Compliant'
        If ($ESENTError623 -eq 'Non-Compliant') {

            #  Backup EventLog
            $null = Backup-EventLog -LogName $LogName -ErrorAction 'SilentlyContinue'

            Try {

                #  Clear EventLog
                $null = Clear-EventLog -LogName $LogName -ErrorAction 'Stop'

                #  Repair DataStore if clear eventlog is succesful
                Repair-WUDataStore
            }
            Catch {
                Write-Output -InputObject "No repair possible. Clear EventLog [$LogName] error. $($_.Exception.Message)"
            }
        }
        Else {
            Write-Output -InputObject $ESENTError623
        }
    }
    'Detect' {

        ## Get machine compliance and return it
        [string]$ESENTError623 = Test-EventLogCompliance -LogName $LogName -Source $Source -EventID $EventID -EntryType $EntryType -LimitDays $LimitDays -Threshold $Threshold
        Write-Output -InputObject $ESENTError623
    }
    'Repair' {

        ## Backup EventLog
        $null = Backup-EventLog -LogName $LogName -ErrorAction 'SilentlyContinue'

        Try {

            ## Clear EventLog
            $null = Clear-EventLog -LogName $LogName -ErrorAction 'Stop'

            ##  Repair DataStore if clear eventlog is succesful
            Repair-WUDataStore
        }
        Catch {
            Write-Output -InputObject "No repair possible. Clear EventLog [$LogName] error. $($_.Exception.Message)"
        }
    }
    'RepairStandalone' {

        ##  Repair DataStore
        Repair-WUDataStore -ErrorAction 'SilentlyContinue'
    }
}

#endregion
##*=============================================
##* END SCRIPT BODY
##*=============================================