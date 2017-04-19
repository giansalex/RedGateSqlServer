SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCorreoAsuntCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select top 1 *from CfgEnvCorreo where RucE=@RucE)
	set @msj='Aun no ha establecido su configuracion'
else
begin
	select 	cec.Cd_CECot,con.Cd_CEC,cec.Asunto,con.NomEnv,con.Correo,con.Host,con.Puerto,con.IB_SSL,con.Estado,con.EsPrincipal
	from 	CfgEnvCorreo con 
	        inner join CfgEnvCot cec on cec.RucE= con.RucE and cec.Cd_CEC = con.Cd_CEC
	where 	con.RucE=@RucE
end
-- Leyenda --
-- JJ : 2010-12-16 11:51 AM	: <Creacion del procedimiento almacenado>
-- GGONZ : 2017-01-06 04:23:00 PM : <Creacion del procedimiento almacenado con una mejora>
GO
