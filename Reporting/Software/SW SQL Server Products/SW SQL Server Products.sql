/*
.SYNOPSIS
    Gets SQL Product info.
.DESCRIPTION
    Gets SQL Product info, id and license key.
.NOTES
    Created by Ioan Popovici.
    Requires the usp_PivotWithDynamicColumns stored procedure (Embedded/Database).
    Requires SQL Property and ProductID extensions.
    Part of a report should not be run separately.
.LINK
    https://SCCM.Zone/SW-SQL-Server-Porducts
.LINK
    https://SCCM.Zone/SW-SQL-Server-Porducts-CHANGELOG
.LINK
    https://SCCM.Zone/SW-SQL-Server-Porducts-GIT
.LINK
    https://SCCM.Zone/Issues
*/

/*##=============================================*/
/*## FUNCTION LISTINGS                           */
/*##=============================================*/
/* #region FunctionListings */

/* #region usp_PivotWithDynamicColumns */
/*
.SYNOPSIS
    Pivots with dynamic columns.
.DESCRIPTION
    Pivots with dynamic columns using dynamic SQL to get the pivot columns.
.PARAMETER TableName
    Specifies the source pivot table name.
.PARAMETER NonPivotedColumn
    Specifies the non pivoded column name.
.PARAMETER DynamicColumn
    Specifies the column form which to dinamically get the pivot column list.
.PARAMETER AggregationColumn
    Specifies the aggregation column.
.EXAMPLE
    EXECUTE usp_PivotWithDynamicColumns
        @TableName         = N'SomeTableName'
        @NonPivotedColumn  = N'ResourceID',
        @DynamicColumn     = N'PropertyName0',
        @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'
.NOTES
    Created by Ioan Popovici.
    Credit to CSifiso W. Ndlovu.
    Replace the <CM_Your_Site_Code> with your CM or custom database name.
    Run the code in SQL Server Management Studio.
.LINK
    https://www.sqlshack.com/multiple-options-to-transposing-rows-into-columns/ (Sifiso W. Ndlovu)
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Issues
*/

/*##=============================================*/
/*## FUNCTION QUERY BODY                         */
/*##=============================================*/
/* #region FunctionQueryBody */

SET NOCOUNT ON
GO

IF OBJECT_ID('dbo.usp_PivotWithDynamicColumns', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PivotWithDynamicColumns;
GO

CREATE PROCEDURE dbo.usp_PivotWithDynamicColumns (
    @TableName           AS NVARCHAR(MAX)
    , @NonPivotedColumn  AS NVARCHAR(MAX)
    , @DynamicColumn     AS NVARCHAR(MAX)
    , @AggregationColumn AS NVARCHAR(MAX)
)
AS
    BEGIN

        /* Variable declaration */
        DECLARE @DynamicColumnQuery AS NVARCHAR(MAX);
        DECLARE @DynamicPivotQuery  AS NVARCHAR(MAX);
        DECLARE @ColumnList         AS NVARCHAR(MAX);

        /* Assemble pivot columns query */
        SET @DynamicColumnQuery = ('
            SET @ColumnList = (
                STUFF(
                    (
                        SELECT DISTINCT
                            '','' + QUOTENAME(DB.'+@DynamicColumn+')
                        FROM '+@TableName+' AS DB
                        FOR XML PATH(''''), TYPE
                    ).value(''.'', ''NVARCHAR(MAX)'')
                    , 1, 1, ''''
                )
            )
        ')

        /* Get pivot columns dynamically and output to @ColumnList variable */
        EXECUTE dbo.sp_executesql @DynamicColumnQuery
            , N'@TableName NVARCHAR(MAX), @DynamicColumn NVARCHAR(MAX), @ColumnList NVARCHAR(MAX) OUTPUT'
            , @TableName
            , @DynamicColumn
            , @ColumnList OUTPUT

        /* Assemble pivot query */
        SET @DynamicPivotQuery = ('
            SELECT
                '+@NonPivotedColumn+', '+@ColumnList+'
            FROM (
                SELECT
                    '+@NonPivotedColumn+'
                    , DynamicColumnAlias    = '+@DynamicColumn+'
                    , AggregationAlias      = '+@AggregationColumn+'
            FROM '+@TableName+'
            )
            SEARCH PIVOT (MAX(AggregationAlias) FOR DynamicColumnAlias IN ('+@ColumnList+'))p
        ') --'p' is intentional, do not remove!

        /* Perform pivot */
        EXECUTE dbo.sp_executesql @DynamicPivotQuery
    END;

/* Send the current batch of Transact-SQL statements to instance for processing */
GO

/* #endregion */
/*##=============================================*/
/*## END FUNCTION QUERY BODY                     */
/*##=============================================*/
/* #endregion */

/* #endregion */
/*##=============================================*/
/*## END FUNCTION LISTINGS                       */
/*##=============================================*/

/*##=============================================*/
/*## QUERY BODY                                  */
/*##=============================================*/
/* #region QueryBody */

/* Perform cleanup */
IF OBJECT_ID('tempdb..#SQLProducts', 'U') IS NOT NULL
    DROP TABLE #SQLProducts;
GO

/* Testing variables !! Need to be commented for Production !! */
DECLARE @UserSIDs       AS NVARCHAR(10) = 'Disabled';
DECLARE @CollectionID   AS NVARCHAR(10) = 'SMS00001';

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
    , SQMReproting      BIT
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
    @TableName         = N'dbo.v_GS_EXT_SQL_2017_Property0',
    @NonPivotedColumn  = N'ResourceID',
    @DynamicColumn     = N'PropertyName0',
    @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL 2016 data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName         = N'dbo.v_GS_EXT_SQL_2016_Property0',
    @NonPivotedColumn  = N'ResourceID',
    @DynamicColumn     = N'PropertyName0',
    @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL 2014 data data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName         = N'dbo.v_GS_EXT_SQL_2014_Property0',
    @NonPivotedColumn  = N'ResourceID',
    @DynamicColumn     = N'PropertyName0',
    @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL 2012 data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName         = N'dbo.v_GS_EXT_SQL_2012_Property0',
    @NonPivotedColumn  = N'ResourceID',
    @DynamicColumn     = N'PropertyName0',
    @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL 2008 data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName         = N'dbo.v_GS_EXT_SQL_2008_Property0',
    @NonPivotedColumn  = N'ResourceID',
    @DynamicColumn     = N'PropertyName0',
    @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Get SQL Legacy data */
INSERT INTO #SQLProducts
EXECUTE dbo.usp_PivotWithDynamicColumns
    @TableName         = N'dbo.v_GS_EXT_SQL_Legacy_Property0',
    @NonPivotedColumn  = N'ResourceID',
    @DynamicColumn     = N'PropertyName0',
    @AggregationColumn = N'ISNULL(PropertyStrValue0, PropertyNumValue0)'

/* Aggregate result data */
SELECT
    Device              = ISNULL(NULLIF(Systems.NetBios_Name0, '-'), 'N/A')
    , Release           = (
        'SQL ' + (SELECT Release FROM @SQLRelease WHERE FileVersion = LEFT(SQLProducts.FileVersion, 4))
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
    , ProductKey        = SQLProductID.DigitalProductID0
    , InstanceID        = SQLProducts.InstanceID
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
    , SQMReproting      = (
        CASE SQLProducts.SQMReproting
            WHEN 0 THEN 'No'
            ELSE 'Yes'
        END
    )
    , SQLStates         = SQLProducts.SQLStates
FROM fn_rbac_FullCollectionMembership(@UserSIDs) AS CollectionMembers
    JOIN #SQLProducts AS SQLProducts ON SQLProducts.ResourceID = CollectionMembers.ResourceID
    JOIN dbo.v_GS_EXT_SQL_PRODUCTID0 AS SQLProductID ON SQLProductID.ResourceID = SQLProducts.ResourceID
        AND SQLProductID.Release0 = (
            SELECT Release FROM @SQLRelease WHERE FileVersion = LEFT(SQLProducts.FileVersion, 4)
        )
        AND SQLProductID.ProductID0 IS NOT NULL
    JOIN v_R_System AS Systems ON Systems.ResourceID = SQLProducts.ResourceID
WHERE CollectionMembers.CollectionID = @CollectionID

/* Drop previously created objects */
IF OBJECT_ID('dbo.usp_PivotWithDynamicColumns', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PivotWithDynamicColumns;
IF OBJECT_ID('tempdb..#SQLProducts', 'U') IS NOT NULL
    DROP TABLE #SQLProducts;
GO

/* #endregion */
/*##=============================================*/
/*## END QUERY BODY                              */
/*##=============================================*/