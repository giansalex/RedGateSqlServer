SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioSolComCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select top 1 *from CfgEnvSC where RucE=@RucE)
	set @msj='No se encontro la Configuracion Envio de Sol. de Compra'
else
begin
	select 	a.RucE, a.Cd_CESCo,a.Cd_CEC,b.Correo,a.Asunto,a.Saludo,a.IC_JalaNpC,a.MsjPrev,
		a.Despedida,a.Firma,a.IB_LinkForm,a.Estado
	from 	CfgEnvSC a inner join CfgEnvCorreo b on a.RucE=b.RucE and a.Cd_CEC=b.Cd_CEC
	where 	a.RucE=@RucE
end
-- Leyenda --
-- MP : 2010-12-17 : <Creacion del procedimiento almacenado>




GO
