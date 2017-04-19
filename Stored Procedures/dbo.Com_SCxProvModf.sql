SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_SCxProvModf]
@RucE nvarchar(11),
@Cd_SCoEnv int,
@Cd_SCo char(10),
@Cd_Prv char(7),
@IB_Env bit,
@FecEnv datetime,
@IB_Impr bit,
@FecImpr datetime,
@Prv_FecEnt smalldatetime,
@Prv_Obs varchar(300),
@msj varchar(100) output

as
--print dbo.Cd_SCoEnv('11111111111')

if not exists (select * from SCxProv where RucE=@RucE and Cd_SCoEnv=@Cd_SCoEnv)
	Set @msj = 'No existe solicitud de compra por proveedor' 

else
begin 
	update SCxProv 
	set Cd_SCo = @Cd_SCo, Cd_Prv = @Cd_Prv, IB_Env = @IB_Env, FecEnv = @FecEnv, IB_Impr = @IB_Impr,
			FecImpr = @FecImpr, Prv_FecEnt = @Prv_FecEnt, Prv_Obs = @Prv_Obs
	where RucE = @RucE and Cd_SCoEnv = @Cd_SCoEnv
	if @@rowcount <= 0
		Set @msj = 'Error al modificar solicitud de compra por proveedor'
end
-- Leyenda --
-- MP : 2010-12-15 : <Creacion del procedimiento almacenado>
GO
