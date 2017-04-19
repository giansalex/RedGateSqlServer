SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioSolComConsUn]
@RucE nvarchar(11),
@Cd_CESCo int,
@msj varchar(100) output
as
if not exists (select * from CfgEnvSC where RucE=@RucE and Cd_CESCo = @Cd_CESCo)
	set @msj='No se encontro la Configuracion Envio de Sol. de Compra'
else
begin
	select 	RucE, Cd_CESCo,Cd_CEC,Asunto,Saludo,IC_JalaNpC,MsjPrev,Despedida,Firma,IB_LinkForm,Estado
	from 	CfgEnvSC 
	where 	RucE=@RucE and Cd_CESCo = @Cd_CESCo
end
-- Leyenda --
-- MP : 2010-12-17 : <Creacion del procedimiento almacenado>
GO
