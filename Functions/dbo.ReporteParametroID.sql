SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ReporteParametroID]
(
	@RucE nvarchar(11),
	@ReporteID char(10)
)
RETURNS int
AS
BEGIN
	declare @n int
	Select @n = COUNT(ReporteID) From ReporteParametros Where RucE = @RucE And ReporteID = @ReporteID
	return @n
END
GO
