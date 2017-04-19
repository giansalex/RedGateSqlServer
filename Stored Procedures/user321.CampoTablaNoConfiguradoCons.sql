SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CampoTablaNoConfiguradoCons]
--@prefijoTabla char(2),
@RucE char(11),
@Cd_Tab char(4),
@msj varchar(100) output

as
if not exists (select top 1 *from CampoTabla where Id_CTb not in (select Id_CTb from CfgCampos))
	set @msj='No se encontro campos para configurar'
else
begin
	select 	con.Id_CTb,con.Cd_Tab,con.NomCol,con.NomDef,con.Estado, t.Ventana
	from 	CampoTabla con
	inner join Tabla t on con.Cd_Tab = t.Cd_Tab 
	where	Id_CTb not in (select Id_CTb from CfgCampos where RucE = @RucE) 
		/*and LEFT(con.Cd_Tab, 2) = @prefijoTabla*/ and con.Estado = 1 and con.Cd_Tab = @Cd_Tab
		
end

-- MP : 2011-01-14 : <Modificacion del procedimiento almacenado>
-- MP : 2011-01-17 : <Modificacion del procedimiento almacenado>
-- MP : 2011-02-09 : <Modificaicon del procedimiento almacenado>
-- MP : 2011-02-23 : <Modificacion del procedimiento almacenado>
-- MP : 2011-02-24 : <Modificacion del procedimiento almacenado>
/*
exec CampoTablaNoConfiguradoCons 'VT', '11111111111', NULL
*/


GO
