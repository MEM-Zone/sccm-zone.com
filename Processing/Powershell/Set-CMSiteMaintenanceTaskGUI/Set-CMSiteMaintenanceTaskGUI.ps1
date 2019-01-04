[psobject]$Sites = Get-CMSite | Select-Object -Property 'SiteCode', 'SiteName'

ForEach ($Site in $Sites) {
    $MaintenanceTask = Get-CMSiteMaintenanceTask -Site $Site | Select-Object -Property 'SiteCode', 'ItemName', 'DaysOfWeek', 'DeleteOlderThan', 'Enabled'
}