SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCotMdf]
@RucE nvarchar(11),
@Cd_CECot int,
@Cd_CEC	int,
@Asunto	varchar(100),
@Saludo	varchar(50),
@IC_JalaNcC char(1),
@MsjPrev varchar(1000),
@Despedida varchar(100),
@Firma varchar(100),
@IB_LinkAprob bit,
@Estado	bit,
@msj varchar(100) output
as
if not exists (select top 1 * from CfgEnvCot where RucE=@RucE and Cd_CECot=@Cd_CECot)
	set @msj = 'Configuracion no existe'
update CfgEnvCot set Cd_CEC=@Cd_CEC,Asunto=@Asunto,Saludo=@Saludo,IC_JalaNcC=@IC_JalaNcC,MsjPrev=@MsjPrev,
		Despedida=@Despedida,Firma=@Firma,IB_LinkAprob=@IB_LinkAprob,Estado=@Estado
		where 	RucE=@RucE AND Cd_CECot=@Cd_CECot
-- Leyenda --
-- JJ : 2010-12-20 15:51 AM	: <Creacion del procedimiento almacenado>
GO
