/*
.SYNOPSIS
    Gets the software update compliance for a CSV KB list.
.DESCRIPTION
    Gets the software update compliance for a CSV KB list by Client State and ArticleID.
.NOTES
    Created by
        Ioan Popovici
    This query is part of a report should not be run separately.
.LINK
    https://SCCM.Zone/SU-KB-Compliance-by-ClientState-and-ArticleID
.LINK
    https://SCCM.Zone/SU-KB-Compliance-by-ClientState-and-ArticleID
.LINK
    https://SCCM.Zone/SU-KB-Compliance-by-ClientState-and-ArticleID
.LINK
    https://SCCM.Zone/Issues
*/

/*##=============================================*/
/*## QUERY BODY                                  */
/*##=============================================*/

/* Testing variables !! Need to be commented for Production !! */
-- DECLARE @UserSIDs       AS NVARCHAR(10) = 'Disabled';
-- DECLARE @CollectionID   AS NVARCHAR(10) = 'HUB00741';
-- DECLARE @Locale         AS INT  = 2;
-- DECLARE @HideInstalled  AS BIT  = 0;
-- DECLARE @Updates AS NVARCHAR(500) = '955430,3177467,3173426,3173424,4465659,4477136,4477137,4470788' -- Server Servicing Stacks (SSU)

/* Variable declaration */
DECLARE @LCID AS INT = dbo.fn_LShortNameToLCID (@Locale)

/* Initialize ClientState descriptor table */
DECLARE @ClientState TABLE
(
    BitMask INT
    , StateName NVARCHAR(250)
)

/* Populate ClientState table */
INSERT INTO @ClientState
    (BitMask, StateName)
VALUES
    ('0', 'No Reboot'),
    ('1', 'Configuration Manager'),
    ('2', 'File Rename'),
    ('4', 'Windows Update'),
    ('8', 'Add or Remove Feature')

/* Initialize SystemInfo table */
DECLARE @SystemInfo TABLE
(
    ResourceID          INT
    , Device            NVARCHAR(250)
    , UserName          NVARCHAR(250)
    , OperatingSystem   NVARCHAR(250)
    , Build             NVARCHAR(50)
    , Version           NVARCHAR(50)
    , DomainOrWorkgroup NVARCHAR(250)
    , IPAddresses       NVARCHAR(250)
    , LastBootTime      NVARCHAR(50)
    , PendingRestart    NVARCHAR(250)
    , Managed           NVARCHAR(5)
    , ClientState       NVARCHAR(20)
    , ClientVersion     NVARCHAR(50)
    , LastUpdateScan    NVARCHAR(50)
)

/* Initialize UpdateInfo table */
DECLARE @UpdateInfo TABLE
(
    ResourceID          INT
    , Compliance        NVARCHAR(15)
    , Classification    NVARCHAR(50)
    , Severity          NVARCHAR(50)
    , ArticleID         NVARCHAR(50)
    , BulletinID        NVARCHAR(50)
    , DisplayName       NVARCHAR(250)
    , DateRevised       NVARCHAR(50)
    , IsDeployed        NVARCHAR(5)
    , IsEnabled         NVARCHAR(5)
)

/* Get system data */
INSERT INTO @SystemInfo (ResourceID, Device, UserName, OperatingSystem, Build, Version, DomainOrWorkgroup, IPAddresses, LastBootTime, PendingRestart, Managed, ClientState, ClientVersion, LastUpdateScan)
SELECT
    ResourceID         = Devices.ResourceID
    , Device           = Devices.Netbios_Name0
    , UserName         = CONCAT(Devices.User_Domain0 + '\', Devices.User_Name0)  -- Add user domain to UserName
    , OperatingSystem  = (

        /* Workaround for systems not in GS_OPERATING_SYSTEM table */
        CASE
            WHEN OperatingSystem.Caption0 <> '' THEN
                CONCAT(
                    REPLACE(OperatingSystem.Caption0, 'Microsoft ', ''),         -- Remove 'Microsoft ' from OperatingSystem
                    REPLACE(OperatingSystem.CSDVersion0, 'Service Pack ', ' SP') -- Replace 'Service Pack ' with ' SP' in OperatingSystem
                )
            ELSE (
                CASE
                    WHEN CombinedResources.DeviceOS LIKE '%Workstation 6.1%'  THEN 'Windows 7'
                    WHEN CombinedResources.DeviceOS LIKE '%Workstation 6.2%'  THEN 'Windows 8'
                    WHEN CombinedResources.DeviceOS LIKE '%Workstation 6.3%'  THEN 'Windows 8.1'
                    WHEN CombinedResources.DeviceOS LIKE '%Workstation 10.0%' THEN 'Windows 10'
                    WHEN CombinedResources.DeviceOS LIKE '%Server 6.0'        THEN 'Windows Server 2008'
                    WHEN CombinedResources.DeviceOS LIKE '%Server 6.1'        THEN 'Windows Server 2008R2'
                    WHEN CombinedResources.DeviceOS LIKE '%Server 6.2'        THEN 'Windows Server 2012'
                    WHEN CombinedResources.DeviceOS LIKE '%Server 6.3'        THEN 'Windows Server 2012 R2'
                    WHEN CombinedResources.DeviceOS LIKE '%Server 10.0'       THEN 'Windows Server 2016'
                    ELSE 'Unknown'
                END
            )
        END
    )
    , Build            = Devices.Build01
    , Version          = (
        SELECT OSLocalizedNames.Value
        FROM fn_GetWindowsServicingLocalizedNames() AS OSLocalizedNames
            JOIN fn_GetWindowsServicingStates() AS OSServicingStates ON OSServicingStates.Build = Devices.Build01
        WHERE OSLocalizedNames.Name = OSServicingStates.Name
            AND Devices.OSBranch01 = OSServicingStates.Branch -- Select only the branch of the installed OS
    )
    , DomainOrWorkgroup = ISNULL(Devices.Full_Domain_Name0, Devices.Resource_Domain_Or_Workgr0)
    , IPAddresses       = (
        REPLACE(
            (
                SELECT LTRIM(RTRIM(IP.IP_Addresses0)) AS [data()]
                FROM fn_rbac_RA_System_IPAddresses(@UserSIDs) AS IP
                WHERE IP.ResourceID = Devices.ResourceID
                    AND IP.IP_Addresses0 NOT LIKE 'fe%' -- Exclude IPv6
                FOR XML PATH('')
            ),
            ' ',', '                                    -- Replace space with ', '
        )
    )
    , LastBootTime     = OperatingSystem.LastBootUpTime0
    , PendingRestart   = (
        CASE
            WHEN CombinedResources.ClientState = 0 THEN 'No'
            ELSE (
                STUFF(
                    REPLACE(
                        (
                            SELECT '#!' + LTRIM(RTRIM(StateName)) AS [data()]
                            FROM @ClientState
                            WHERE BitMask & CombinedResources.ClientState <> 0
                            FOR XML PATH('')
                        ),
                        ' #!',', '
                    ),
                    1, 2, ''
                )
            )
        END
    )
    , Managed          = (
        CASE Devices.Client0
            WHEN 1 THEN 'Yes'
            ELSE 'No'
        END
    )
    , ClientState      = ClientSummary.ClientStateDescription
    , ClientVersion    = Devices.Client_Version0
    , LastUpdateScan   = UpdateScan.LastScanTime
FROM fn_rbac_FullCollectionMembership(@UserSIDs) AS CollectionMembers
    LEFT JOIN fn_rbac_R_System(@UserSIDs) AS Devices ON Devices.ResourceID = CollectionMembers.ResourceID
    LEFT JOIN fn_rbac_GS_OPERATING_SYSTEM(@UserSIDs) OperatingSystem ON OperatingSystem.ResourceID = CollectionMembers.ResourceID
    LEFT JOIN fn_rbac_CombinedDeviceResources(@UserSIDs) AS CombinedResources ON CombinedResources.MachineID = CollectionMembers.ResourceID
    LEFT JOIN fn_rbac_CH_ClientSummary(@UserSIDs) AS ClientSummary ON ClientSummary.ResourceID = CollectionMembers.ResourceID
    LEFT JOIN fn_rbac_UpdateScanStatus(@UserSIDs) AS UpdateScan ON UpdateScan.ResourceID = CollectionMembers.ResourceID
WHERE CollectionMembers.CollectionID = @CollectionID

/* Get update data */
INSERT INTO @UpdateInfo (ResourceID, Compliance, Classification, Severity, ArticleID, BulletinID, DisplayName, DateRevised, IsDeployed, IsEnabled)
SELECT
    CollectionMembers.ResourceID
    , Compliance       = (
        CASE ComplianceStatus.Status
            WHEN 0 THEN 'Unknown'	   -- Not used here
            WHEN 1 THEN 'Not Required' -- Not used here
            WHEN 2 THEN 'Required'
            WHEN 3 THEN 'Installed'
        END
    )
    , Classification   = Category.CategoryInstanceName
    , Severity         = UpdateCIs.SeverityName
    , ArticleID        = UpdateCIs.ArticleID
    , BulletinID       = NULLIF(UpdateCIs.BulletinID, '')
    , DisplayName      = UpdateCIs.DisplayName
    , DateRevised      = UpdateCIs.DateRevised
    , IsDeployed       = (
        CASE UpdateCIs.IsDeployed
            WHEN 0 THEN 'No'
            WHEN 1 THEN 'Yes'
        END
    )
    , IsEnabled        = (
        CASE UpdateCIs.IsEnabled
            WHEN 0 THEN 'No'
            WHEN 1 THEN 'Yes'
        END
    )
FROM fn_rbac_ClientCollectionMembers(@UserSIDs) AS CollectionMembers
    INNER JOIN v_Update_ComplianceStatus AS ComplianceStatus ON ComplianceStatus.ResourceID = CollectionMembers.ResourceID
    /*
    Notes
        v_Update_ComplianceStatus view contains only 'Installed' and 'Required' updates (0 Unknown, 1 Not Required, 2 Required, 3 Installed)
        use v_Update_ComplianceStatusAll for all updates
    */
    INNER JOIN fn_ListUpdateCIs(@LCID) AS UpdateCIs ON UpdateCIs.CI_ID = ComplianceStatus.CI_ID
        AND UpdateCIs.CIType_ID IN (1, 8) -- 1 Software Updates, 8 Software Update Bundle (v_CITypes)
        AND UpdateCIs.IsExpired = 0       -- Update is not Expired
        AND UpdateCIs.IsSuperseded = 0    -- Update is not Superseeded
        AND UpdateCIs.ArticleID IN (
            SELECT * FROM CM_Tools.dbo.ufn_csv_String_Parser(@Updates, ',')
        )
    LEFT JOIN fn_rbac_CICategories_All(@UserSIDs) AS CICategories ON CICategories.CI_ID = UpdateCIs.CI_ID
    RIGHT JOIN fn_rbac_ListUpdateCategoryInstances(@LCID, @UserSIDs) AS Category ON Category.CategoryInstanceID = CICategories.CategoryInstanceID
        AND Category.CategoryTypeName = 'UpdateClassification' -- Get only the 'UpdateClasification' category
WHERE CollectionMembers.CollectionID = @CollectionID

/* Join SystemInfo and UpdateInfo tables */
SELECT
    Compliance = ISNULL(NULLIF(Compliance, ''), 'Unknown')
	, Managed
    , Device
    , UserName
    , OperatingSystem
    , Build
    , Version
    , DomainOrWorkgroup
    , IPAddresses
    , LastBootTime
    , PendingRestart
    , ClientState
    , ClientVersion
    , LastUpdateScan
    , Classification
    , Severity
    , ArticleID
    , BulletinID
    , DisplayName
    , DateRevised
    , IsDeployed
    , IsEnabled
FROM @SystemInfo AS SystemInfo
    LEFT JOIN @UpdateInfo AS UpdateInfo ON UpdateInfo.ResourceID = SystemInfo.ResourceID
WHERE Device IS NOT NULL
    AND (
        @HideInstalled = 0
        OR (
            @HideInstalled = 1 AND (Compliance != 'Installed' OR Compliance IS NULL) -- Hide 'Installed' updates
        )
    )

/*##=============================================*/
/*## END QUERY BODY                              */
/*##=============================================*/