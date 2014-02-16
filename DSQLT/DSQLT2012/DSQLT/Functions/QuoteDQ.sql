﻿CREATE FUNCTION [DSQLT].[QuoteDQ]
(@Text NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
BEGIN
	RETURN [DSQLT].[QuoteSafe] (@Text,'"')
END
