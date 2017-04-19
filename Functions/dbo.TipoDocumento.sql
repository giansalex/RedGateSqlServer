SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[TipoDocumento]
(
	@Cd_TD nvarchar(6)
)
RETURNS varchar(5)
AS
BEGIN
	-- Declare the return variable here
	Declare @descripcion varchar(5)
	--set @descripcion=@Cd_TD
	---- Add the T-SQL statements to compute the return value here
	--if @Cd_TD=0
	--set @descripcion='OTR'
	--if @Cd_TD=01
	--set @descripcion='FAC'
	--if @Cd_TD=03
	--set @descripcion='BOL'
	--if @Cd_TD=01
	--set @descripcion=''
	--if @Cd_TD=01
	--set @descripcion=''
	--if @Cd_TD=01
	--set @descripcion=''
	--if @Cd_TD=01
	--set @descripcion=''
	--if @Cd_TD=01
	--set @descripcion=''
	
select @descripcion=(select NCorto from TipDoc where Cd_TD=@Cd_TD)
	-- Return the result of the function
	RETURN isnull(@descripcion, '--')

END
GO
