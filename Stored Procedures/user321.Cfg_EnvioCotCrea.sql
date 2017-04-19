SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCotCrea]
@RucE nvarchar(11),
@Cd_CEC int,
@Asunto varchar(100),
@Saludo varchar(50),
@IC_JalaNcC char(1),
@MsjPrev varchar(1000),
@Despedida varchar(100),
@Firma varchar(100),
@IB_LinkAprob bit,
@Estado bit,
@msj varchar(100) output
as
declare @Cd_CECot int
set @Cd_CECot=dbo.Cd_CECot(@RucE)
if exists (select * from CfgEnvCot where RucE= @RucE and Cd_CECot=@Cd_CECot)
	set @msj = 'Ya existe la configuracion'
else 
begin
insert 	into 	CfgEnvCot(RucE,Cd_CECot,Cd_CEC,Asunto,Saludo,IC_JalaNcC,MsjPrev,Despedida,Firma,IB_LinkAprob,Estado)
	values	(@RucE,@Cd_CECot,@Cd_CEC,@Asunto,@Saludo,@IC_JalaNcC,@MsjPrev,@Despedida,@Firma,@IB_LinkAprob,@Estado)
end
-- Leyenda --
-- JJ : 2010-12-20 16:20 AM	: <Creacion del procedimiento almacenado>
GO
