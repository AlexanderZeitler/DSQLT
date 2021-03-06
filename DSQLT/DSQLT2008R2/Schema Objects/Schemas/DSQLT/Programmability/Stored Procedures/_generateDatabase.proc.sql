﻿

CREATE PROCEDURE [DSQLT].[_generateDatabase]
@Database [sysname], @Print INT=0
AS
BEGIN
-- nur bei den "eigenen" Parameter-Datenbanken ggf. löschen
if DSQLT.QuoteNameSB(@Database) in (select ParameterQ from [DSQLT].[Digits](0,9))  
	IF DSQLT.isDatabase(@Database)=1  -- wenn schon existiert, dann löschen
		exec DSQLT.[@DropDatabase] @Database,@Print=@Print
		
-- wenn noch nicht existiert, dann erzeugen		
IF DSQLT.isDatabase(@Database)=0  
	exec DSQLT.[@GenerateDatabase] @Database,@Print=@Print

-- die nach Parameter benannten Tabellen im Schema dbo erzeugen	
exec DSQLT.[@GenerateSchema] @Database,'dbo',@Print=@Print

-- die nach Parameter benannten Schemas und Tabellen erzeugen	
declare @Cursor CURSOR ; SET @Cursor= CURSOR LOCAL STATIC FOR 
	select ParameterQ from [DSQLT].[Digits] (1,9)
exec DSQLT.[@@GenerateSchema] @Cursor,@Database=@Database,@Print=@Print

-- die speziell geänderten Tabellen übertragen
exec [DSQLT].[@CopyTable] @TargetDB=@Database , @Schema='@1' ,@Table ='@1' , @Print=@Print
exec [DSQLT].[@CopyTable] @TargetDB=@Database , @Schema='@3' ,@Table ='@3' , @Print=@Print

---- das Schema DSQLT mit Functions und Procedures erzeugen
exec DSQLT._generateDSQLT @Database,@Print=@Print

END

