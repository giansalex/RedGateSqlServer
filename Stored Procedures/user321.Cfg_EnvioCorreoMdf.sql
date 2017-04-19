SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCorreoMdf]
@RucE nvarchar(11),
@Cd_CEC int,
@Host varchar(100),
@Puerto int,
@Correo varchar(100),
@Pass varchar(20),
@NomEnv varchar(100),
@IB_SSL bit,
@Estado bit,
@msj varchar(100) output
as
if not exists (select top 1 * from CfgEnvCorreo where RucE=@RucE and Cd_CEC=@cd_CEC)
	set @msj = 'Configuracion no existe'
update CfgEnvCorreo set Host=@Host, Puerto=@Puerto, Correo=@Correo, Pass=@Pass, 
			NomEnv=@NomEnv, IB_SSL=@IB_SSL, Estado=@Estado 
		where 	RucE=@RucE and Cd_CEC=@cd_CEC
-- Leyenda --
-- JJ : 2010-12-17 11:45 AM	: <Creacion del procedimiento almacenado>


GO
