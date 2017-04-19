SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [user321].[DameIGVImp](@Fecha varchar(10))
Returns decimal(5,2) AS
Begin
	declare @igv decimal(5,2) 
	Set @igv=0.19

	if(Convert(datetime,@Fecha,103) > Convert(datetime,'28/02/2011',103)) -- ULTIMA FECHA DE USO DEL IGV a 19%
		Set @igv=0.18

	return @igv
end




GO
