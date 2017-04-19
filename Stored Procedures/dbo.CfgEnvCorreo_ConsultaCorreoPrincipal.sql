SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CfgEnvCorreo_ConsultaCorreoPrincipal]
@RucE nvarchar(11),
@msj varchar(100) output
as
if exists (select * from CfgEnvCorreo where RucE = @RucE/* and EsPrincipal = 1*/)
	select * from CfgEnvCorreo where RucE = @RucE and EsPrincipal = 1
else
	set @msj = 'No existen correos configurados.'

print @msj
--LEYENDA
--CAM 14/05/2012 Creacion
-- exec CfgEnvCorreo_ConsultaCorreoPrincipal '11111111118',''
GO
