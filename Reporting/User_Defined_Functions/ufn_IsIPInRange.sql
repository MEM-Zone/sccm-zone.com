/*
.SYNOPSIS
    Checks if the IP is in the specified IP range.
.DESCRIPTION
    Checks if the IP is in the specified IP range.
.PARAMETER IP
    Specifies the IP.
.PARAMETER IPRange
    Specifies the IP range.
.EXAMPLE
    Replace the <CM_Your_Site_Code> with your CM or custom database name.
    Run the code in SQL Server Management Studio
.NOTES
    Created by Ioan Popovici (2019-01-14)
.LINK
    https://SCCM.Zone
.LINK
    https://SCCM.Zone/Issues
*/

/*##=============================================*/
/*## QUERY BODY                                  */
/*##=============================================*/
/* #region QueryBody */

USE [<CM_Your_Site_Code/Custom_Function_Database>]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (
    SELECT  [OBJECT_ID]
    FROM    [SYS].[OBJECTS]
    WHERE   NAME = 'ufn_IsIPInRange'
)
    DROP FUNCTION [dbo].[ufn_IsIPInRange];
GO

CREATE FUNCTION [dbo].[ufn_IsIPInRange] (
    @IP        VARCHAR(15)
    , @IPRange VARCHAR(31)
)
RETURNS VARCHAR(4)
AS
    BEGIN

        /* Variable declaration */
        DECLARE @IPRangeStart           AS VARCHAR (15);
        DECLARE @IPRangeFinish          AS VARCHAR (15);
        DECLARE @IPToInteger            AS BIGINT;
        DECLARE @IPRangeStartToInteger  AS BIGINT;
        DECLARE @IPRangeFinishToInteger AS BIGINT;
        DECLARE @Result                 AS VARCHAR(4);

        /* Set range start and finish */
        SET @IPRangeStart
        SET @IPRangeFinish

        /* Convert IP to integer */
        SET @IPToInteger = (
            CONVERT(BIGINT, PARSENAME(@IP,1)) +
            CONVERT(BIGINT, PARSENAME(@IP,2)) * 256 +
            CONVERT(BIGINT, PARSENAME(@IP,3)) * 65536 +
            CONVERT(BIGINT, PARSENAME(@IP,4)) * 16777216
        );

        /* Set result */
        SET @Result = '/' + CAST(@LogarithmCacl AS VARCHAR(5));

        /* Return result */
        RETURN  @Result;
    END;

/* #endregion */
/*##=============================================*/
/*## END QUERY BODY                              */
/*##=============================================*/
