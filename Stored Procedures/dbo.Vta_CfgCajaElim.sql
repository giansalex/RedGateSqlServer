SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CfgCajaElim]
@RucE nvarchar(11),
@Cd_Caja nvarchar(6),
@msj varchar(100) output
as

/* GG: Esto no es necesario. no se debe hacer esto.
if not exists (select * from CfgCaja where RucE=@RucE and Cd_Caja=@Cd_Caja)
	set @msj = 'Configuracion Caja no existe'
else*/
begin
	
	delete CfgCaja Where RucE=@RucE and Cd_Caja=@Cd_Caja
	
	if @@rowcount <= 0
		set @msj = 'Configuracion Caja no pudo ser eliminado'
end
print @msj


GO
