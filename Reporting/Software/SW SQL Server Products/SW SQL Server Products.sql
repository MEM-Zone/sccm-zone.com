/*
.SYNOPSIS
    Gets SQL product info.
.DESCRIPTION
    Gets SQL product info, id and product key.
.NOTES
    Created by Ioan Popovici.
    Requires the usp_PivotWithDynamicColumns stored procedure.
    Requires SQL Property and ProductID extensions.
    Part of a report should not be run separately.
.LINK
    https://SCCM.Zone/SW-SQL-Server-Products
.LINK
    https://SCCM.Zone/SW-SQL-Server-Products-CHANGELOG
.LINK
    https://SCCM.Zone/SW-SQL-Server-Products-GIT
.LINK
    https://SCCM.Zone/Issues
*/

/*##=============================================*/
/*## QUERY BODY                                  */
/*##=============================================*/
/* #region QueryBody */

/* Test variable declaration !! Need to be commented for Production !! */
--DECLARE @UserSIDs        AS NVARCHAR(10) = 'Disabled';
--DECLARE @CollectionID    AS NVARCHAR(10) = 'SMS00001';

/* Variable declaration */
DECLARE @TableName         AS NVARCHAR(MAX);
DECLARE @NonPivotedColumn  AS NVARCHAR(MAX);
DECLARE @DynamicColumn     AS NVARCHAR(MAX);
DECLARE @AggregationColumn AS NVARCHAR(MAX);

/* Perform cleanup */
IF OBJECT_ID('tempdb..#SQLProducts', 'U') IS NOT NULL
    DROP TABLE #SQLProducts;

/* Create SQLProducts table */
CREATE TABLE #SQLProducts (
    ResourceID          NVARCHAR(25)
    , [Clustered]       BIT
    , Datapath          NVARCHAR(250)
    , DumpDir           NVARCHAR(250)
    , ErrorReporting    BIT
    , FileVersion       NVARCHAR(50)
    , InstallPath       NVARCHAR(250)
    , InstanceID        NVARCHAR(100)
    , IsWOW64           BIT
    , [Language]        NVARCHAR(10)
    , RegRoot           NVARCHAR(250)
    , SKU               NVARCHAR(100)
    , SKUName           NVARCHAR(100)
    , SPLevel           NVARCHAR(2)
    , SQLStates         NVARCHAR(10)
    , SQMReporting      BIT
    , StartupParameters NVARCHAR(MAX)
    , [Version]         NVARCHAR(25)
    , VSName            NVARCHAR(50)
)

/* Initialize SQLRelease table */
DECLARE @SQLRelease Table (FileVersion NVARCHAR(4), Release NVARCHAR(10))

/* Populate SQLRelease table */
INSERT INTO @SQLRelease (FileVersion, Release)
VALUES
      ('2017', '2017')
    , ('2016', '2016')
    , ('2014', '2014')
    , ('2011', '2012')
    , ('2009', '2008 R2')
    , ('2007', '2008')
    , ('2005', '2005')
    , ('2000', '2000')
    , ('',     'Unknown')

/* Get SQL 2017 data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName           = N'dbo.v_GS_EXT_SQL_2017_Property0'
    , @NonPivotedColumn  = N'ResourceID'
    , @DynamicColumn     = N'PropertyName0'
    , @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL 2016 data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName           = N'dbo.v_GS_EXT_SQL_2016_Property0'
    , @NonPivotedColumn  = N'ResourceID'
    , @DynamicColumn     = N'PropertyName0'
    , @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL 2014 data data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName           = N'dbo.v_GS_EXT_SQL_2014_Property0'
    , @NonPivotedColumn  = N'ResourceID'
    , @DynamicColumn     = N'PropertyName0'
    , @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL 2012 data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName           = N'dbo.v_GS_EXT_SQL_2012_Property0'
    , @NonPivotedColumn  = N'ResourceID'
    , @DynamicColumn     = N'PropertyName0'
    , @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL 2008 data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName           = N'dbo.v_GS_EXT_SQL_2008_Property0'
    , @NonPivotedColumn  = N'ResourceID'
    , @DynamicColumn     = N'PropertyName0'
    , @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL Legacy data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName           = N'dbo.v_GS_EXT_SQL_Legacy_Property0'
    , @NonPivotedColumn  = N'ResourceID'
    , @DynamicColumn     = N'PropertyName0'
    , @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Aggregate result data */
SELECT
    Device              = Devices.[Name]
    , DomainOrWorkgroup = ISNULL(Systems.Full_Domain_Name0, Systems.Resource_Domain_Or_Workgr0)
    , OperatingSystem   = (

        /* Get OS caption by version */
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
                    WHEN CAST(REPLACE(Build01, '.', '') AS INTEGER) > 10017763 THEN 'Windows Server 2019'
                    ELSE 'Windows Server 2016'
                END
            )
            ELSE Systems.Operating_System_Name_And0
        END
    )
    , Release           = (
        'SQL ' + (SELECT Release FROM @SQLRelease WHERE FileVersion = LEFT(SQLProducts.FileVersion, 4))
    )
    , EditionGroup      = (
        CASE
            WHEN SQLProducts.SKUName LIKE '%devel%' THEN 'Developer'
            WHEN SQLProducts.SKUName LIKE '%workg%' THEN 'Workgroup'
            WHEN SQLProducts.SKUName LIKE '%stand%' THEN 'Standard'
            WHEN SQLProducts.SKUName LIKE '%enter%' THEN 'Enterprise'
            ELSE SQLProducts.SKUName
        END
    )
    , [Edition]         = SQLProducts.SKUName
    , ServicePack       = SQLProducts.SPLevel
    , [Version]         = SQLProducts.[Version]
    , CUVersion         = SQLProducts.FileVersion
    , [Language]        = SQLProducts.[Language]
    , Bitness           = (
        CASE SQLProducts.IsWOW64
            WHEN 0 THEN 'x64'
            ELSE 'x86'
        END
    )
    , ProductID         = SQLProductID.ProductID0
    , ProductKey        = ISNULL(SQLProductID.DigitalProductID0, 'N/A')
    , InstanceID        = SQLProducts.InstanceID
    , IsVirtualMachine  = (
        CASE Devices.IsVirtualMachine
          WHEN 0 THEN 'No'
            ELSE 'Yes'
        END
    )
    , CPUs              = COUNT(Processor.ResourceID)
    , PhysicalCores     = SUM(Processor.NumberOfCores0)
    , LogicalCores      = SUM(Processor.NumberOfLogicalProcessors0)
    , [Clustered]       = (
        CASE SQLProducts.[Clustered]
            WHEN 0 THEN 'No'
            ELSE 'Yes'
        END
    )
    , NetworkName       = SQLProducts.VSName
    , StartupParameters = SQLProducts.StartupParameters
    , RegistryRoot      = SQLProducts.RegRoot
    , DataPath          = SQLProducts.Datapath
    , LogPath           = SQLProducts.DumpDir
    , ErrorReporting    = (
        CASE SQLProducts.ErrorReporting
            WHEN 0 THEN 'No'
            ELSE 'Yes'
        END
    )
    , SQMReporting      = (
        CASE SQLProducts.SQMReporting
            WHEN 0 THEN 'No'
            ELSE 'Yes'
        END
    )
    , SQLStates         = SQLProducts.SQLStates
FROM fn_rbac_FullCollectionMembership(@UserSIDs) AS CollectionMembers
    JOIN v_R_System AS Systems ON Systems.ResourceID = CollectionMembers.ResourceID
    JOIN v_CombinedDeviceResources AS Devices ON Devices.MachineID = CollectionMembers.ResourceID
    JOIN v_GS_PROCESSOR AS Processor ON Processor.ResourceID = CollectionMembers.ResourceID
    JOIN #SQLProducts AS SQLProducts ON SQLProducts.ResourceID = CollectionMembers.ResourceID
    LEFT JOIN dbo.v_GS_EXT_SQL_PRODUCTID0 AS SQLProductID ON SQLProductID.ResourceID = SQLProducts.ResourceID
        AND SQLProductID.Release0 = (
            SELECT Release FROM @SQLRelease WHERE FileVersion = LEFT(SQLProducts.FileVersion, 4)
        )
        AND SQLProductID.ProductID0 IS NOT NULL
WHERE CollectionMembers.CollectionID = @CollectionID
GROUP BY
    Devices.[Name]
	, Systems.Full_Domain_Name0
    , Systems.Resource_Domain_Or_Workgr0
	, Systems.Operating_System_Name_and0
	, Systems.Build01
    , SQLProducts.FileVersion
    , SQLProducts.SKUName
    , SQLProducts.SPLevel
    , SQLProducts.[Version]
    , SQLProducts.[Language]
    , SQLProducts.IsWOW64
    , SQLProductID.ProductID0
    , SQLProductID.DigitalProductID0
    , SQLProducts.InstanceID
    , Devices.IsVirtualMachine
    , Processor.NumberOfCores0
    , Processor.NumberOfLogicalProcessors0
    , SQLProducts.[Clustered]
    , SQLProducts.VSName
    , SQLProducts.StartupParameters
    , SQLProducts.RegRoot
    , SQLProducts.Datapath
    , SQLProducts.DumpDir
    , SQLProducts.ErrorReporting
    , SQLProducts.SQMReporting
    , SQLProducts.SQLStates

/* Perform cleanup */
IF OBJECT_ID('tempdb..#SQLProducts', 'U') IS NOT NULL
    DROP TABLE #SQLProducts;

/* #endregion */
/*##=============================================*/
/*## END QUERY BODY                              */
/*##=============================================*/