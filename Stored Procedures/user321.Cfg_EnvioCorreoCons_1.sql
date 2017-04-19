SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Cfg_EnvioCorreoCons_1]
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select top 1 *from CfgEnvCorreo where RucE=@RucE)
	set @msj='Aun no ha establecido su configuracion'
else
begin
	select 	con.Cd_CEC,con.NomEnv,con.Correo,con.Host,con.Puerto,con.IB_SSL,con.Estado,con.EsPrincipal
	from 	CfgEnvCorreo con 
	where 	con.RucE=@RucE
end
-- Leyenda --
-- JJ : 2010-12-16 11:51 AM	: <Creacion del procedimiento almacenado>
GO
