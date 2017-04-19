SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCorreoCrea]
@RucE nvarchar(11),
@Host varchar(100),
@Puerto int,@Correo varchar(100),
@Pass varchar(20),
@NomEnv varchar(50),@IB_SSL bit,@Estado bit,
@msj varchar(100) output
as


declare @Cd_CEC int
set @Cd_CEC=dbo.Cd_CEC(@RucE)
if exists (select * from CfgEnvCorreo where RucE= @RucE and Cd_CEC=@Cd_CEC)
	set @msj = 'Ya existe la configuracion'
else 
begin
insert 	into 	CfgEnvCorreo(RucE,Cd_CEC,Host,Puerto,Correo,Pass,NomEnv,IB_SSL,Estado)
	values	(@RucE,@Cd_CEC,@Host,@Puerto,@Correo,@Pass,@NomEnv,@IB_SSL,@Estado)
end
-- Leyenda --
-- JJ : 2010-12-16 11:51 AM	: <Creacion del procedimiento almacenado>


GO
