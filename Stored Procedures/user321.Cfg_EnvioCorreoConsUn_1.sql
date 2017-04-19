SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCorreoConsUn_1]
@RucE nvarchar(11),
@Cd_CEC int,
@msj varchar(100) output
as
if not exists (select top 1 *from CfgEnvCorreo where RucE=@RucE)
	set @msj='No se encontro correo'
else 
Begin
	if(@Cd_CEC is null or @Cd_CEC=0)
	begin
		select  a.RucE,a.Cd_CEC,a.Host,a.Puerto,a.Correo,a.Pass,a.NomEnv,a.IB_SSL,a.Estado,a.EsPrincipal
		from 	CfgEnvCorreo a
		where 	a.RucE=@RucE
	end
	else 
	begin 
		select  a.RucE,a.Cd_CEC,a.Host,a.Puerto,a.Correo,a.Pass,a.NomEnv,a.IB_SSL,a.Estado,a.EsPrincipal
		from 	CfgEnvCorreo a
		where 	a.RucE=@RucE and a.Cd_CEC=@Cd_CEC
	end
end
-- Leyenda --
-- JJ : 2010-12-16 11:51 AM	: <Creacion del procedimiento almacenado>


GO
