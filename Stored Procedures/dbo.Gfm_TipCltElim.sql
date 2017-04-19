SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipCltElim](
	@Cd_TClt char(3),
	@RucE nvarchar(11),
	@msj varchar(100) output
)
AS
if not exists(select * from TipClt where Cd_TClt = @Cd_TClt and RucE = @RucE)
	set @msj = 'Tipo de cliente no existe.'
else
begin
	delete TipClt where Cd_TClt = @Cd_TClt and RucE = @RucE
		if @@rowcount <= 0
		set @msj = 'Tipo de cliente no pudo ser eliminado'
end
print @msj
GO
