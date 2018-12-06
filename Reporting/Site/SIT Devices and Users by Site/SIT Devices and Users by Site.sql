/*
.SYNOPSIS
    Gets the computers and users by SCCM and AD site.
.DESCRIPTION
    Gets the computers and users by SCCM and AD site for a collection.
.NOTES
    Created by Ioan Popovici
    Part of a report should not be run separately.
.LINK
    https://SCCM.Zone/SIT-Devices-and-Users-by-Site
.LINK
    https://SCCM.Zone/SIT-Devices-and-Users-by-Site-CHANGELOG
.LINK
    https://SCCM.Zone/SIT-Devices-and-Users-by-Site-GIT
.LINK
    https://SCCM.Zone/Issues

*/

/*##=============================================*/
/*## QUERY BODY                                  */
/*##=============================================*/

/* Testing variables !! Need to be commented for Production !! */
--DECLARE @UserSIDs       AS NVARCHAR(10) = 'Disabled';
--DECLARE @CollectionID   AS NVARCHAR(10) = 'HUB00095';
--DECLARE @Locale         AS INT  = '2';

/* Variable declaration */
DECLARE @LCID AS INT = dbo.fn_LShortNameToLCID (@Locale)

/* Get systems data */
SELECT
    Device	            = Systems.NetBios_Name0
    , UserName          = NULLIF(CONCAT(Systems.User_Domain0 + '\', Systems.User_Name0), '')   --Add user domain to UserName
    , SCCMSite	        = CombinedResources.SiteCode
    , ADSite	        = ADSiteName
    , DomainOrWorkgroup = ISNULL(Full_Domain_Name0, Systems.Resource_Domain_Or_Workgr0)
    , OperatingSystem   = (
        CASE
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 5.%'             THEN 'Windows XP'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 6.0%'            THEN 'Windows Vista'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 6.1%'            THEN 'Windows 7'
            WHEN Systems.Operating_System_Name_And0 LIKE 'Windows_7 Entreprise 6.1'     THEN 'Windows 7'
            WHEN Systems.Operating_System_Name_And0 = 'Windows Embedded Standard 6.1'   THEN 'Windows 7'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 6.2%'            THEN 'Windows 8'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 6.3%'            THEN 'Windows 8.1'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 10%'             THEN 'Windows 10'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 10%'             THEN 'Windows 10'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 5.%'                  THEN 'Windows Server 2003'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 6.0%'                 THEN 'Windows Server 2008'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 6.1%'                 THEN 'Windows Server 2008 R2'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 6.2%'                 THEN 'Windows Server 2012'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 6.3%'                 THEN 'Windows Server 2012 R2'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 10%'                  THEN (
                CASE
                    WHEN CAST(REPLACE(Build01, '.', '') AS INT) > 10017763 THEN 'Windows Server 2019'
                    ELSE 'Windows Server 2016'
                END
            )
            ELSE Systems.Operating_System_Name_And0
        END
    )
    , Version           = (
        CASE
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 10%' THEN (
                CASE REPLACE(Systems.Build01, '.', '')
                    WHEN '10010240' THEN '1507'
                    WHEN '10010586' THEN '1511'
                    WHEN '10014393' THEN '1607'
                    WHEN '10015063' THEN '1703'
                    WHEN '10016299' THEN '1709'
                    WHEN '10017134' THEN '1803'
                    WHEN '10017763' THEN '1809'
                    ELSE NULL
                END
            )
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 10%'      THEN (
                CASE REPLACE(Systems.Build01, '.', '')
                    WHEN '10014393' THEN '1607'
                    WHEN '10016299' THEN '1709'
                    WHEN '10017134' THEN '1803'
                    WHEN '10017763' THEN '1809'
                    ELSE NULL
                END
            )
            ELSE NULL
        END
    )
    , Build             = Systems.Build01
    , IPAddresses       =
        REPLACE(
            (
                SELECT LTRIM(RTRIM(IP.IP_Addresses0)) AS [data()]
                FROM v_RA_System_IPAddresses AS IP
                WHERE IP.ResourceID = Systems.ResourceID
                    AND IP.IP_Addresses0 NOT LIKE 'fe%' -- Exclude IPv6
                FOR XML PATH('')
            ),
            ' ',', ' -- Replace space with ', '
        )
    , IPSubnets          =
        REPLACE(
            (
                SELECT LTRIM(RTRIM(SN.IP_Subnets0)) AS [data()]
                FROM v_RA_System_IPSubnets AS SN
                WHERE SN.ResourceID = Systems.ResourceID
                FOR XML PATH('')
            ),
            ' ',', ' -- Replace space with ', '
        )
    , Managed           =
        CASE Systems.Client0
            WHEN 1 THEN 'Yes'
            ELSE 'No'
        END
FROM fn_rbac_FullCollectionMembership(@UserSIDs) AS CollectionMembers
    LEFT JOIN v_R_System AS Systems ON Systems.ResourceID = CollectionMembers.ResourceID
    LEFT JOIN v_CombinedDeviceResources AS CombinedResources ON CombinedResources.MachineID = CollectionMembers.ResourceID
WHERE CollectionMembers.CollectionID = @CollectionID

/*##=============================================*/
/*## END QUERY BODY                              */
/*##=============================================*/