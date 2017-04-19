SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipMantCons](
	@TipCons int,
	@RucE nvarchar(11),
	@msj varchar(100) OUTPUT
)
AS
begin
	If(@TipCons = 0)
		Select * from TipMant Where RucE = @RucE
	else if(@TipCons = 1)
		Select Cd_TM + '  |  ' + Descrip as CodNom from TipMant where Estado = 1 and RucE = @RucE
	else if(@TipCons = 3)
		Select Cd_TM,RucE,Descrip from TipMant where Estado = 1 and RucE = @RucE
end
print @msj
--Leyenda
--JV : 20/07/2011 : <Creación de procedimiento almacenado.>

GO
