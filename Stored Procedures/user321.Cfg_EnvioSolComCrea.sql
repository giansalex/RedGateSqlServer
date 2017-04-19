SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioSolComCrea]
@RucE nvarchar(11),
@Cd_CEC int,
@Asunto varchar(100),
@Saludo varchar(50),
@IC_JalaNpC char(1),
@MsjPrev varchar(1000),
@Despedida varchar(100),
@Firma varchar(100),
@IB_LinkForm bit,
@Estado bit,
@msj varchar(100) output
as

declare @Cd_CESCo int
set @Cd_CESCo=dbo.Cd_CESCo(@RucE)
if exists (select * from CfgEnvSC where RucE= @RucE and Cd_CESCo=@Cd_CESCo)
	set @msj = 'Ya existe la configuracion'
else 
begin
insert 	into 	CfgEnvSC(RucE,Cd_CESCo,Cd_CEC,Asunto,Saludo,IC_JalaNpC,MsjPrev,Despedida,Firma,IB_LinkForm,Estado)
	values	(@RucE,@Cd_CESCo,@Cd_CEC,@Asunto,@Saludo,@IC_JalaNpC,@MsjPrev,@Despedida,@Firma,@IB_LinkForm,@Estado)
end
-- Leyenda --
-- JJ : 2010-12-17 19:16 AM	: <Creacion del procedimiento almacenado>
GO
