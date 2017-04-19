SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_TablasxCamposHabilitados_2]
@Cd_MR char(7),
@msj varchar(100) output
as

declare @consulta varchar(1000)

set @consulta = '
			select tm.Cd_MR,t.Cd_Tab,t.Nombre,t.Ventana from tabla t inner join tablaxmod tm on t.Cd_Tab=tm.Cd_Tab
			where t.Cd_Tab in (select distinct Cd_Tab from Campotabla where Estado = 1)
			and tm.Cd_MR in ('''+@Cd_MR+''')'
exec(@consulta)
print @consulta
--CE : 03-04-2012 : <Modificacion del procedimiento almacenado>
--

--exec user321.Cfg_TablasxCamposHabilitados_2 '08'',''09',null
GO
