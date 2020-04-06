;;; Compiled snippets and support files for `sql-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'sql-mode
		     '(("sqlUpdateRows" "-- Update rows in table '${1:TableName}'\nUPDATE $1\nSET\n	$2[Colum1] = Colum1_Value,\n	$3[Colum2] = Colum2_Value\n	-- add more columns and values here\nWHERE $4	/* add search conditions here */\nGO\n" "Update rows in a Table" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlUpdateRows" nil nil)
		       ("sqlSelect" "-- Select rows from a Table or View '${1:TableOrViewName}' in schema '${2:SchemaName}'\nSELECT * FROM $2.$1\nWHERE $3	/* add search conditions here */\nGO\n" "Select rows from a Table or a View" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlSelect" nil nil)
		       ("sqlListTablesAndViews" "-- Get a list of tables and views in the current database\nSELECT table_catalog [database], table_schema [schema], table_name name, table_type type\nFROM INFORMATION_SCHEMA.TABLES\nGO\n" "List tables" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlListTablesAndViews" nil nil)
		       ("sqlListDatabases" "-- Get a list of databases\nSELECT name FROM sys.databases\nGO\n" "List databases" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlListDatabases" nil nil)
		       ("sqlListColumns" "-- List columns in all tables whose name is like '${1:TableName}'\nSELECT \n	TableName = tbl.TABLE_SCHEMA + '.' + tbl.TABLE_NAME, \n	ColumnName = col.COLUMN_NAME, \n	ColumnDataType = col.DATA_TYPE\nFROM INFORMATION_SCHEMA.TABLES tbl\nINNER JOIN INFORMATION_SCHEMA.COLUMNS col \n	ON col.TABLE_NAME = tbl.TABLE_NAME\n	AND col.TABLE_SCHEMA = tbl.TABLE_SCHEMA\n\nWHERE tbl.TABLE_TYPE = 'BASE TABLE' and tbl.TABLE_NAME like '%$1%'\nGO\n" "List columns" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlListColumns" nil nil)
		       ("sqlInsertRows" "-- Insert rows into table '${1:TableName}'\nINSERT INTO $1\n( -- columns to insert data into\n $2[Column1], [Column2], [Column3]\n)\nVALUES\n( -- first row: values for the columns in the list above\n $3Column1_Value, Column2_Value, Column3_Value\n),\n( -- second row: values for the columns in the list above\n $4Column1_Value, Column2_Value, Column3_Value\n)\n-- add more rows here\nGO\n" "Insert rows into a Table" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlInsertRows" nil nil)
		       ("sqlGetSpaceUsed" "-- Get the space used by table ${1:TableName}\nSELECT TABL.name AS table_name,\nINDX.name AS index_name,\nSUM(PART.rows) AS rows_count,\nSUM(ALOC.total_pages) AS total_pages,\nSUM(ALOC.used_pages) AS used_pages,\nSUM(ALOC.data_pages) AS data_pages,\n(SUM(ALOC.total_pages)*8/1024) AS total_space_MB,\n(SUM(ALOC.used_pages)*8/1024) AS used_space_MB,\n(SUM(ALOC.data_pages)*8/1024) AS data_space_MB\nFROM sys.tables AS TABL\nINNER JOIN sys.indexes AS INDX\nON TABL.object_id = INDX.object_id\nINNER JOIN sys.partitions AS PART\nON INDX.object_id = PART.object_id\nAND INDX.index_id = PART.index_id\nINNER JOIN sys.allocation_units AS ALOC\nON PART.partition_id = ALOC.container_id\nWHERE TABL.name LIKE '%$1%'\nAND INDX.object_id > 255\nAND INDX.index_id <= 1\nGROUP BY TABL.name, \nINDX.object_id,\nINDX.index_id,\nINDX.name\nORDER BY Object_Name(INDX.object_id),\n(SUM(ALOC.total_pages)*8/1024) DESC\nGO\n" "Show space used by tables" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlGetSpaceUsed" nil nil)
		       ("sqlExtensionHelp" "/*\nmssql getting started:\n-----------------------------\n1. Change language mode to SQL: Open a .sql file or press Ctrl+K M (Cmd+K M on Mac) and choose 'SQL'.\n2. Connect to a database: Press F1 to show the command palette, type 'sqlcon' or 'sql' then click 'Connect'.\n3. Use the T-SQL editor: Type T-SQL statements in the editor using T-SQL IntelliSense or type 'sql' to see a list of code snippets you can tweak & reuse.\n4. Run T-SQL statements: Press F1 and type 'sqlex' or press Ctrl+Shift+e (Cmd+Shift+e on Mac) to execute all the T-SQL code in the editor.\n\nTip #1: Put GO on a line by itself to separate T-SQL batches.\nTip #2: Select some T-SQL text in the editor and press `Ctrl+Shift+e` (`Cmd+Shift+e` on Mac) to execute the selection\n*/\n" "Get extension help" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlExtensionHelp" nil nil)
		       ("sqlDropTable" "-- Drop the table '${1:TableName}' in schema '${2:SchemaName}'\nIF EXISTS (\n	SELECT *\n		FROM sys.tables\n		JOIN sys.schemas\n			ON sys.tables.schema_id = sys.schemas.schema_id\n	WHERE sys.schemas.name = N'$2'\n		AND sys.tables.name = N'$1'\n)\n	DROP TABLE $2.$1\nGO\n" "Drop a Table" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlDropTable" nil nil)
		       ("sqlDropStoredProc" "-- Drop the stored procedure called '${1:StoredProcedureName}' in schema '${2:SchemaName}'\nIF EXISTS (\nSELECT *\n	FROM INFORMATION_SCHEMA.ROUTINES\nWHERE SPECIFIC_SCHEMA = N'$2'\n	AND SPECIFIC_NAME = N'$1'\n)\nDROP PROCEDURE $2.$1\nGO\n" "Drop a stored procedure" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlDropStoredProc" nil nil)
		       ("sqlDropDatabase" "-- Drop the database '${1:DatabaseName}'\n-- Connect to the 'master' database to run this snippet\nUSE master\nGO\n-- Uncomment the ALTER DATABASE statement below to set the database to SINGLE_USER mode if the drop database command fails because the database is in use.\n-- ALTER DATABASE $1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;\n-- Drop the database if it exists\nIF EXISTS (\n  SELECT name\n   FROM sys.databases\n   WHERE name = N'$1'\n)\nDROP DATABASE $1\nGO\n" "Drop a Database" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlDropDatabase" nil nil)
		       ("sqlDropColumn" "-- Drop '${1:ColumnName}' from table '${2:TableName}' in schema '${3:SchemaName}'\nALTER TABLE $3.$2\n	DROP COLUMN $1\nGO\n" "Drop a column from a Table" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlDropColumn" nil nil)
		       ("sqlDeleteRows" "-- Delete rows from table '${1:TableName}'\nDELETE FROM $1\nWHERE $2	/* add search conditions here */\nGO\n" "Delete rows from a Table" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlDeleteRows" nil nil)
		       ("sqlCreateTable" "-- Create a new table called '${1:TableName}' in schema '${2:SchemaName}'\n-- Drop the table if it already exists\nIF OBJECT_ID('$2.$1', 'U') IS NOT NULL\nDROP TABLE $2.$1\nGO\n-- Create the table in the specified schema\nCREATE TABLE $2.$1\n(\n	$1Id INT NOT NULL PRIMARY KEY, -- primary key column\n	$3Column1 [NVARCHAR](50) NOT NULL,\n	$4Column2 [NVARCHAR](50) NOT NULL\n	-- specify more columns here\n);\nGO\n" "Create a new Table" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlCreateTable" nil nil)
		       ("sqlCreateStoredProc" "-- Create a new stored procedure called '${1:StoredProcedureName}' in schema '${2:SchemaName}'\n-- Drop the stored procedure if it already exists\nIF EXISTS (\nSELECT *\n	FROM INFORMATION_SCHEMA.ROUTINES\nWHERE SPECIFIC_SCHEMA = N'$2'\n	AND SPECIFIC_NAME = N'$1'\n)\nDROP PROCEDURE $2.$1\nGO\n-- Create the stored procedure in the specified schema\nCREATE PROCEDURE $2.$1\n	$3@param1 /*parameter name*/ int /*datatype_for_param1*/ = 0, /*default_value_for_param1*/\n	$4@param2 /*parameter name*/ int /*datatype_for_param1*/ = 0 /*default_value_for_param2*/\n-- add more stored procedure parameters here\nAS\n	-- body of the stored procedure\n	SELECT @param1, @param2\nGO\n-- example to execute the stored procedure we just created\nEXECUTE $2.$1 1 /*value_for_param1*/, 2 /*value_for_param2*/\nGO\n" "Create a stored procedure" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlCreateStoredProc" nil nil)
		       ("sqlCreateDatabase" "-- Create a new database called '${1:DatabaseName}'\n-- Connect to the 'master' database to run this snippet\nUSE master\nGO\n-- Create the new database if it does not exist already\nIF NOT EXISTS (\n	SELECT name\n		FROM sys.databases\n		WHERE name = N'$1'\n)\nCREATE DATABASE $1\nGO\n" "Create a new Database" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlCreateDatabase" nil nil)
		       ("sqlAddColumn" "-- Add a new column '${1:NewColumnName}' to table '${2:TableName}' in schema '${3:SchemaName}'\nALTER TABLE $3.$2\n	ADD $1 /*new_column_name*/ int /*new_column_datatype*/ NULL /*new_column_nullability*/\nGO\n" "Add a new column to a Table" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/sql-mode/sqlAddColumn" nil nil)))


;;; Do not edit! File generated at Sun Apr  5 14:00:01 2020
