-- Active: 1783781059792@@127.0.0.1@3306
USE University
DECLARE @sqlText VARCHAR(MAX)
SET @sqlText = ''
SELECT @sqlText = @sqlText + ' SELECT * FROM ' + QUOTENAME(name) + CHAR(13) FROM sys.tables
EXEC(@sqlText)