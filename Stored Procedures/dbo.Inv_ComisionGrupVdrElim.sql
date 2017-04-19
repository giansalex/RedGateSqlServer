SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupVdrElim]
@RucE nvarchar(11),
@Cd_CGV char(3),
@msj varchar(100) output
as
if not exists (select * from ComisionGrupVdr Where RucE=@RucE and Cd_CGV=@Cd_CGV)
	set @msj = 'Comision no existe'
else
begin
	delete from ComisionGrupVdr Where RucE=@RucE and Cd_CGV=@Cd_CGV

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo de Vendedor no pudo ser eliminado'
end
print @msj
GO
