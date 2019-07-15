# SW SQL Server Products release history

## 2.5 - 2019-07-15

### Changes

    * Added edition group filter with multiple selections
    * Added CEIP Reporting (Customer Experience Improvement)
    * Removed unused fields
    * Fixed SKUName
    * Updated formatting

## 2.4~prerelease - 2019-07-1z

### Changes

    * Added static column pivot to have predictable column order output
    * Fixed x64 detection
    * Added new EditionGroup definitions
    * Default ’N/A’ if NULL Edition
    * Default NULL for all CASE statements
    * Added Old SQL extension cleanup
    * Removed unused columns

## 2.1-2.3~prerelease - 2019-06-24

### Changes

    * Removed usp_PivotWithDynamicColumns, it cannot be added dynamically, needs to be created manually
    * Removed GO statements, they are not valid TSQL statements
    * Added variable declaration needed for report builder
    * Replaced Domain with DomainOrWorkgroup
    * Added EditionGroup for reprort groupping
    * Changed ProductKey to be shown now as N/A if null
    * Fixed different column name storing the same value
    * Standardized formatting and descriptions

## 2.0~prerelease - 2019-06-18

### Changes

    * Completely re-written, new extension gathers and stores 40-50% less junk data.
    * Added: Product Key, Clustered, Operating System, VM, CPUs, Physical Cored, Logical Cores information
    * Release is not a hack anymore
    * Code repetition, property name guessing and duplicates have been almst eliminated by pivoting the result table and using a stored procedure.
    * Report and report template have been updated to the new standard template.

## 1.0 - 2016-02-08

### First version

    * Gets SQL product info, id and product key.
