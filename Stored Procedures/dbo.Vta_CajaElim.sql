SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CajaElim]
@RucE nvarchar(11),
@Cd_Caja nvarchar(6),
@msj varchar(100) output
as
if not exists (select * from Caja where RucE=@RucE and Cd_Caja=@Cd_Caja)
	set @msj = 'Caja no existe'
else
begin

	/*GG: segun requerimiento N°24 , se debe poder eliminar caja con su configuraciones*/
	--if exists (select * from CfgCaja where RucE=@RucE and Cd_Caja=@Cd_Caja)
	--begin
	--	set @msj = 'Caja no puede ser eliminada por estar enlazada a una configuracion'
	--	return
	--end

	if exists (select * from Vendedor2 where RucE=@RucE and Cd_Caja=@Cd_Caja)
	begin
		set @msj = 'Caja no puede ser eliminada por estar enlazada a un vendedor'
		return
	end

	
	delete CfgCaja Where RucE=@RucE and Cd_Caja=@Cd_Caja	
	
	delete Caja Where RucE=@RucE and Cd_Caja=@Cd_Caja
	
	if @@rowcount <= 0
		set @msj = 'Caja no pudo ser eliminado'
end
print @msj


-- GG: 14/11/2016 : Se agrego Eliminicacion de configuracion caja.
GO
