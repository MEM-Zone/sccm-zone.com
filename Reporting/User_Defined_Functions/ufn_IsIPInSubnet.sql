/*
.SYNOPSIS
    Checks if the IP is in the specified subnet.
.DESCRIPTION
    Checks if the IP is in the specified subnet using the subnet mask.
.EXAMPLE
    Replace the <CM_Your_Site_Code> with your CM or custom database name.
    Run the code in SQL Server Management Studio
.NOTES
    Created by Ioan Popovici (2018-12-12)
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
    WHERE   NAME = 'ufn_IsIPInSubnet'
)
    DROP FUNCTION [dbo].[ufn_IsIPInSubnet];
GO

CREATE FUNCTION [dbo].[ufn_IsIPInSubnet] (
    @IP AS VARCHAR(15)
    , @SubnetIP AS VARCHAR(15)
    , @SubnetMaskIP AS VARCHAR(15)
)
RETURNS BIT
AS
    BEGIN
        DECLARE @Result AS BIT;

        SET @Result = (
            CASE
                WHEN    CAST(PARSENAME(@IP, 4) AS TINYINT) & CAST(PARSENAME(@SubnetMaskIP, 4) AS TINYINT) = CAST(PARSENAME(@SubnetIP, 4) AS TINYINT) & CAST(PARSENAME(@SubnetMaskIP, 4) AS TINYINT)
                    AND CAST(PARSENAME(@IP, 3) AS TINYINT) & CAST(PARSENAME(@SubnetMaskIP, 3) AS TINYINT) = CAST(PARSENAME(@SubnetIP, 3) AS TINYINT) & CAST(PARSENAME(@SubnetMaskIP, 3) AS TINYINT)
                    AND CAST(PARSENAME(@IP, 2) AS TINYINT) & CAST(PARSENAME(@SubnetMaskIP, 2) AS TINYINT) = CAST(PARSENAME(@SubnetIP, 2) AS TINYINT) & CAST(PARSENAME(@SubnetMaskIP, 2) AS TINYINT)
                    AND CAST(PARSENAME(@IP, 1) AS TINYINT) & CAST(PARSENAME(@SubnetMaskIP, 1) AS TINYINT) = CAST(PARSENAME(@SubnetIP, 1) AS TINYINT) & CAST(PARSENAME(@SubnetMaskIP, 1) AS TINYINT)
                THEN 1
                ELSE 0
            END
        )

        /* Return result */
        RETURN  @Result;
    END;

/* #endregion */
/*##=============================================*/
/*## END QUERY BODY                              */
/*##=============================================*/