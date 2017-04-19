SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_ComisionGrupCteElim]
@RucE nvarchar(11),
@Cd_CGC char(3),
@msj varchar(100) output
as
if not exists (select * from ComisionGrupCte Where RucE=@RucE and Cd_CGC=@Cd_CGC)
	set @msj = 'Comision no existe'
else
begin
	delete from ComisionGrupCte  where RucE = @RucE and Cd_CGC=@Cd_CGC

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo de Cliente no pudo ser eliminado'
end
print @msj
GO
