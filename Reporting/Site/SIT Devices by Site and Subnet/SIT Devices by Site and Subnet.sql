/*
.SYNOPSIS
    List devices by site and subnet.
.DESCRIPTION
    List devices by AD, SCCM site and network information.
.NOTES
    Created by Ioan Popovici
    Part of a report should not be run separately.
.LINK
    https://SCCM.Zone/SIT-Devices-Site-and-Subnet
.LINK
    https://SCCM.Zone/SIT-Devices-Site-and-Subnet-CHANGELOG
.LINK
    https://SCCM.Zone/SIT-Devices-Site-and-Subnet-GIT
.LINK
    https://SCCM.Zone/Issues
*/

/*##=============================================*/
/*## QUERY BODY                                  */
/*##=============================================*/

/* Testing variables !! Need to be commented for Production !! */
--DECLARE @UserSIDs       AS NVARCHAR(10) = 'Disabled';
--DECLARE @CollectionID   AS NVARCHAR(10) = 'SMS00001';
--DECLARE @Locale         AS INT  = '2';

/* Variable declaration */
DECLARE @LCID AS INT = dbo.fn_LShortNameToLCID (@Locale)

/* Get systems data */
SELECT DISTINCT
    Device	            = ISNULL(NULLIF(Systems.NetBios_Name0, '-'), 'N/A')             -- Replace null with 'NA'
    , UserName          = NULLIF(Systems.User_Name0, '')                                -- Replace empty string with NULL
    , SCCMSite          = Sites.SiteName
    , SCCMSiteCode	    = CombinedResources.SiteCode
    , ADSite	        = CombinedResources.ADSiteName
    , ADSiteLocation    = ADSiteLocation
    , DomainOrWorkgroup = ISNULL(Full_Domain_Name0, Systems.Resource_Domain_Or_Workgr0) -- Replace domain with workgroup if NULL
    , OperatingSystem   = (                                                             -- Get OS caption by version
        CASE
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 5.%'              THEN 'Windows XP'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 6.0%'             THEN 'Windows Vista'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 6.1%'             THEN 'Windows 7'
            WHEN Systems.Operating_System_Name_And0 LIKE 'Windows_7 Entreprise 6.1'      THEN 'Windows 7'
            WHEN Systems.Operating_System_Name_And0 =    'Windows Embedded Standard 6.1' THEN 'Windows 7'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 6.2%'             THEN 'Windows 8'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 6.3%'             THEN 'Windows 8.1'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 10%'              THEN 'Windows 10'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Workstation 10%'              THEN 'Windows 10'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 5.%'                   THEN 'Windows Server 2003'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 6.0%'                  THEN 'Windows Server 2008'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 6.1%'                  THEN 'Windows Server 2008 R2'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 6.2%'                  THEN 'Windows Server 2012'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 6.3%'                  THEN 'Windows Server 2012 R2'
            WHEN Systems.Operating_System_Name_And0 LIKE '%Server 10%'                   THEN (
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
    , IPAddresses       = Network.IPAddress0
    , IPSubnets         = (
        REPLACE(
            (
                SELECT (
                    LTRIM(RTRIM(Subnets.IP_Subnets0))
                ) AS [data()]
                FROM v_RA_System_IPSubnets AS Subnets
                WHERE Subnets.ResourceID = CollectionMembers.ResourceID
                    AND (
                        SELECT CM_Tools.dbo.ufn_IsIPInSubnet(Network.IPAddress0, Subnets.IP_Subnets0, Network.IPSubnet0)
                    ) = 1        -- Check if IP is in subnet
                FOR XML PATH('') -- Merge multiple values
            ),
            ' ',', '             -- Replace space with ', '
        )
    )
    , IPSubnetMasks     = (Network.IPSubnet0 + CM_Tools.dbo.ufn_CIDRFromIPMask(Network.IPSubnet0)) -- Add CIDR to the IP subnet
    , Managed           =
        CASE Systems.Client0
            WHEN 1 THEN 'Yes'
            ELSE 'No'
        END
FROM fn_rbac_FullCollectionMembership(@UserSIDs) AS CollectionMembers
    LEFT JOIN v_R_System AS Systems ON Systems.ResourceID = CollectionMembers.ResourceID
    LEFT JOIN v_CombinedDeviceResources AS CombinedResources ON CombinedResources.MachineID = CollectionMembers.ResourceID
    LEFT JOIN v_Site AS Sites ON Sites.SiteCode = CombinedResources.SiteCode
    LEFT JOIN v_Network_DATA_Serialized AS Network ON Network.ResourceID = CollectionMembers.ResourceID
        AND Network.IPAddress0 NOT LIKE '[A-Z]%' AND IPEnabled0 = 1 -- Exclude IPv6 and non-enabled adapters
    LEFT JOIN dbo.ActiveDirectorySites AS ADSites ON ADSites.ADSiteName = CombinedResources.ADSiteName
WHERE CollectionMembers.CollectionID = @CollectionID

/*##=============================================*/
/*## END QUERY BODY                              */
/*##=============================================*/