SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioSolComMdf]
@RucE nvarchar(11),
@Cd_CESCo int,
@Cd_CEC	int,
@Asunto	varchar(100),
@Saludo	varchar(50),
@IC_JalaNpC char(1),
@MsjPrev varchar(1000),
@Despedida varchar(100),
@Firma varchar(100),
@IB_LinkForm bit,
@Estado bit,
@msj varchar(100) output
as
if not exists (select top 1 * from CfgEnvSC where RucE=@RucE and Cd_CESCo=@Cd_CESCo)
	set @msj = 'Configuracion no existe'
update CfgEnvSC set Cd_CEC=@Cd_CEC,Asunto=@Asunto,Saludo=@Saludo,IC_JalaNpC=@IC_JalaNpC,MsjPrev=@MsjPrev,
		Despedida=@Despedida,Firma=@Firma,IB_LinkForm=@IB_LinkForm,Estado=@Estado
		where 	RucE=@RucE and Cd_CESCo=@Cd_CESCo
-- Leyenda --
-- JJ : 2010-12-20 11:14 AM	: <Creacion del procedimiento almacenado>
GO
