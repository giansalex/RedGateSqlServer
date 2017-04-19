SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_SCxProvCrea]
@RucE nvarchar(11),
@Cd_SCoEnv int output,
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
--declare @Cd_SCoEnv int
Set @Cd_SCoEnv = dbo.Cd_SCoEnv(@RucE)

if exists (select * from SCxProv where RucE=@RucE and Cd_SCoEnv=@Cd_SCoEnv)
	Set @msj = 'Ya existe solicitud de compra por proveedor' 

else
begin 
	insert into SCxProv(RucE,Cd_SCoEnv,Cd_SCo,Cd_Prv,IB_Env,FecEnv,IB_Impr,FecImpr,Prv_FecEnt,Prv_Obs)
			values(@RucE,@Cd_SCoEnv,@Cd_SCo,@Cd_Prv,@IB_Env,@FecEnv,@IB_Impr,@FecImpr,@Prv_FecEnt,@Prv_Obs)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar solicitud de compra por proveedor'
end
-- Leyenda --
-- MP : 2010-07-26 : <Creacion del procedimiento almacenado>




GO
