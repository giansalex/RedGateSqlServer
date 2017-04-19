SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgCampoConsxTabla]
@RucE nvarchar(11),
@prefijoTabla nvarchar(4),
@msj varchar(100) output
as
/*if not exists (select top 1 *from CfgCampos where RucE=@RucE)
	set @msj='No se encontro configuraciones del campo'
else
begin*/
	select 	con.RucE,con.Id_CTb,con.Id_TDt,con.Nom,con.ValorDef,con.MaxCarac,con.IB_Oblig,IB_Hab,
		t.Ventana,con.MinDate,con.MaxDate,con.ValList,con.Fmla,
		td.Descrip Tipo, cam.NomDef Campo, cam.NomCol
	from 	CfgCampos con 
	inner join CampoTabla cam on cam.Id_CTb = con.Id_CTb
	inner join TipoDato td on td.Id_TDt = con.Id_TDt
	inner join Tabla t on t.Cd_Tab = cam.Cd_Tab
	--where 	con.RucE=@RucE and LEFT(cam.Cd_Tab, 2) = @prefijoTabla
	where 	con.RucE=@RucE and cam.Cd_Tab like '%' + @prefijoTabla + '%' and cam.Estado = 1
--end

-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>
-- MP : 2011-01-12 : <Modificacion del procedimiento almacenado>
-- MP : 2011-01-14 : <Modificacion del procedimiento almacenado>
-- MP : 2011-01-19 : <Modificacion del procedimiento almacenado>
-- MP : 2011-01-25 : <Modificacion del procedimiento almacenado>
-- MP : 2011-02-03 : <Modificacion del procedimiento almacenado>

/*
DEMO:
exec user321.CfgCampoConsxTabla '11111111111', 'CP', null
*/












GO
