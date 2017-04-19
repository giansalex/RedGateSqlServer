SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCorreoCrea_1]
@RucE nvarchar(11),
@Host varchar(100),
@Puerto int,@Correo varchar(100),
@Pass varchar(20),
@NomEnv varchar(50),@IB_SSL bit,@Estado bit,
@EsPrincipal bit, 
@msj varchar(100) output
as


declare @Cd_CEC int
set @Cd_CEC=dbo.Cd_CEC(@RucE)
if exists (select * from CfgEnvCorreo where RucE= @RucE and Cd_CEC=@Cd_CEC)
	set @msj = 'Ya existe la configuracion'
else 
begin
insert 	into 	CfgEnvCorreo(RucE,Cd_CEC,Host,Puerto,Correo,Pass,NomEnv,IB_SSL,Estado,EsPrincipal)
	values	(@RucE,@Cd_CEC,@Host,@Puerto,@Correo,@Pass,@NomEnv,@IB_SSL,@Estado,@EsPrincipal)
end

if(@EsPrincipal = 1)
begin
	update CfgEnvCorreo set EsPrincipal = 0 where RucE = @RucE
	update CfgEnvCorreo set EsPrincipal = 1 where RucE = @RucE and Cd_CEC = @Cd_CEC
end

-- Leyenda --
-- JJ : 2010-12-16 11:51 AM	: <Creacion del procedimiento almacenado>
-- CAM: 11/05/2012 Agregue EsPincipal y la parte para que cambie los valores cuando se crea una configuracion que va a ser la principal
--select * from CfgEnvCorreo where RucE= '11111111111'

GO
