SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipProvElim](
	@Cd_TPrv char(3),
	@RucE nvarchar(11),
	@msj varchar(100) output
)
AS
if not exists(select * from TipProv where Cd_TPrv = @Cd_TPrv and RucE = @RucE)
	set @msj = 'Tipo de proveedor no existe.'
else
begin
	delete TipProv where Cd_TPrv = @Cd_TPrv and RucE = @RucE
		if @@rowcount <= 0
		set @msj = 'Area no pudo ser eliminado'
end
print @msj
GO
