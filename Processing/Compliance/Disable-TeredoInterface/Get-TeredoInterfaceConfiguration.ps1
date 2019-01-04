<#
.SYNOPSIS
    Gets the teredo tunneling interface configuration state.
.DESCRIPTION
    Gets the teredo tunneling interface configuration state for use in a CI as detection script.
.NOTES
    Created by
        Ioan Popovici   2018-09-11
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Git
#>

Try {
    $TeredoState = (Get-NetTeredoConfiguration -ErrorAction 'Stop').Type
}
Catch {
    $TeredoState = "Error: $($_.Exception.Message)"

}
Finally {
    Write-Output -InputObject $TeredoState
}