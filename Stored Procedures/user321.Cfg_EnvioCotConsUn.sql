SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCotConsUn]
@RucE nvarchar(11),
@Cd_CECot int,
@msj varchar(100) output
as
if not exists (select top 1 * from CfgEnvCot where RucE=@RucE and Cd_CECot = @Cd_CECot)
	set @msj='No se encontro la Configuracion Envio de Cotizacion'
else
begin
	select 	RucE, Cd_CECot,Cd_CEC,Asunto,Saludo,IC_JalaNcC,MsjPrev,Despedida,Firma,IB_LinkAprob,Estado
	from 	CfgEnvCot 
	where 	RucE=@RucE and Cd_CECot = @Cd_CECot
end
-- Leyenda --
-- JJ : 2010-12-20 : <Creacion del procedimiento almacenado>


GO
