SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Servicio2Com_Cd_SrvGenera]
@RucE nvarchar(11),
@Cd_Srv char(7) output,
@msj varchar(100) output
as
select @Cd_Srv = user123.Cod_Srv2Com(@RucE)
print @Cd_Srv
-- Leyenda --
-- JU : 2010-08-26 : <Creacion del procedimiento almacenado>
GO
