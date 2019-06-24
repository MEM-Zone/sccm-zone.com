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
    Replace the <CM_Your_CM_DB> with your CM database name.
    Run the code in SQL Server Management Studio.
.LINK
    https://www.sqlshack.com/multiple-options-to-transposing-rows-into-columns/ (Sifiso W. Ndlovu)
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Issues
*/

/*##=============================================*/
/*## QUERY BODY                                  */
/*##=============================================*/
/* #region FunctionQueryBody */

USE [<CM_Your_CM_DB>]
GO

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

/* #endregion */
/*##=============================================*/
/*## END QUERY BODY                              */
/*##=============================================*/