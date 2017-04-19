SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CampoTablaConfiguradoCons]
@msj varchar(100) output
as
if not exists (select top 1 *from CampoTabla where Id_CTb in (select Id_CTb from CfgCampos))
	set @msj='No se encontro campos configurados'
else
begin
	select 	con.Id_CTb,con.Cd_Tab,con.NomCol,con.NomDef,con.Estado, 'Mov. Ventas' [NomVentana]
	from 	CampoTabla con
	where	Id_CTb in (select Id_CTb from CfgCampos)
end
-- Leyenda --
-- MP : 2011-01-03 : <Creacion del procedimiento almacenado>
GO
