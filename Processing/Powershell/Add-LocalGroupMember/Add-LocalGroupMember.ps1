<#
.SYNOPSIS
    Adds user or group to local group.
.DESCRIPTION
    Adds user or group to local group using PowerShell 5+ commandlet or ADSI for lower versions.
    For PowerhShell 4 and below only add user is supported.
.PARAMETER Group
    Specify Local Group to add the Member to.
.PARAMETER Member
    Specify Member to add in Domain\Member format.
.EXAMPLE
    Add-LocalGroupMemberLegacy -Group 'SomeLocalGroup' -Member 'SomeDomain\SomeMember'
.INPUTS
    System.String.
.OUTPUTS
    None. This function has no outputs.
.NOTES
    This is a script and can typically be called directly.
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Issues
.COMPONENT
    Security
.FUNCTIONALITY
    Operational
#>

##*=============================================
##* VARIABLE DECLARATION
##*=============================================
#region VariableDeclaration

## Get script parameters
Param (
    [Parameter(Mandatory=$false,Position=0)]
    [ValidateNotNullorEmpty()]
    [string]$Group = 'Administrators',
    [Parameter(Mandatory=$true,Position=1)]
    [ValidateNotNullorEmpty()]
    [string]$Member
)

## Get PowerShell version
[int16]$PowerShellVersion = $PSVersionTable.PSVersion.Major

#endregion
##*=============================================
##* END VARIABLE DECLARATION
##*=============================================

##*=============================================
##* FUNCTION LISTINGS
##*=============================================
#region FunctionListings

#region Function Add-LocalGroupMemberLegacy
Function Add-LocalGroupMemberLegacy {
<#
.SYNOPSIS
    Adds user to local group.
.DESCRIPTION
    Add user to local group using ADSI.
.PARAMETER Group
    Specify Local Group to add the user to.
.PARAMETER Member
    Specify Member to add in Domain\UserName format.
.EXAMPLE
    Add-LocalGroupMemberLegacy -Group 'SomeLocalGroup' -Member 'SomeDomain\SomeUserName'
.INPUTS
    System.String.
.OUTPUTS
    None. This function has no outputs.
.NOTES
    This function can typically be called directly.
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Issues
.COMPONENT
    Security
.FUNCTIONALITY
    Operational
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$Group = 'Administrators',
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullorEmpty()]
        [string]$User
    )
    Try {

        ## Convert username to use with ADSI
        $ResolvedUser = $User -replace ('\\' , '/')

        ## Adding user to group
        ([ADSI]("WinNT://./$Group, Group")).Add(([ADSI]"WinNT://$ResolvedUser, User").Path)
        $Output = "Added user [$ResolvedUser] to local group [$Group]"
    }
    Catch {
        $Output = "Failed to add user [$ResolvedUser] to local group [$Group] `n$_"
    }
    Finally {
        Write-Output -InputObject $Output
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

## User PowerShell commandlet or ADSI if commandlets are not supported
If ($PowerShellVersion -ge 5) {
    Try {
        Add-LocalGroupMember -Group $Group -Member $Member -ErrorAction 'Stop'
        $Output = "Added user [$Group] to local group [$Member]"
    }
    Catch {
        $Output = "Failed to add user [$Member] to local group [$Group] `n$_"
    }
    Finally {
        Write-Output -InputObject $Output
    }
}
Else {
    Try {
        Add-LocalGroupMemberLegacy -Group $Group -UserName $Member -ErrorAction 'Stop'
        $Output = "Added user [$Group] to local group [$Member]"
    }
    Catch {
        $Output = "Failed to add user [$Member] to local group [$Group] `n$_"
    }
    Finally {
        Write-Output -InputObject $Output
    }
}

#endregion
##*=============================================
##* END SCRIPT BODY
##*=============================================