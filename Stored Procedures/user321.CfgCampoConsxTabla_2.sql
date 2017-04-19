SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgCampoConsxTabla_2]
@RucE nvarchar(11),
@Cd_MR char(7),
@Cd_Tab char(4),
@msj varchar(100) output
as
/*if not exists (select top 1 *from CfgCampos where RucE=@RucE)
	set @msj='No se encontro configuraciones del campo'
else
begin*/
	declare @consulta varchar(1000)
	declare @consulta2 varchar(1000)
	
	if(@Cd_Tab is null)
	begin
		set @consulta =
		'select 	tm.Cd_MR,con.RucE,con.Id_CTb,con.Id_TDt,con.Nom,con.ValorDef,con.MaxCarac,con.IB_Oblig,IB_Hab,
			t.Ventana,con.MinDate,con.MaxDate,con.ValList,con.Fmla,
			td.Descrip Tipo, cam.NomDef Campo, cam.NomCol, con.MaxValue, con.MinValue
		from 	CfgCampos con 
		inner join CampoTabla cam on cam.Id_CTb = con.Id_CTb
		inner join TipoDato td on td.Id_TDt = con.Id_TDt
		inner join Tabla t on t.Cd_Tab = cam.Cd_Tab
		inner join Tablaxmod tm on t.Cd_tab = tm.Cd_Tab		
		where 	con.RucE='''+@RucE+''' and tm.Cd_MR in ('''+@Cd_MR+''') and cam.estado=1'
		print @consulta
		exec(@consulta)
		
	end
	else
	begin
		set @consulta2=		
		'select 	tm.Cd_MR,con.RucE,con.Id_CTb,con.Id_TDt,con.Nom,con.ValorDef,con.MaxCarac,con.IB_Oblig,IB_Hab,
			t.Ventana,con.MinDate,con.MaxDate,con.ValList,con.Fmla,
			td.Descrip Tipo, cam.NomDef Campo, cam.NomCol, con.MaxValue, con.MinValue
		from 	CfgCampos con 
		inner join CampoTabla cam on cam.Id_CTb = con.Id_CTb
		inner join TipoDato td on td.Id_TDt = con.Id_TDt
		inner join Tabla t on t.Cd_Tab = cam.Cd_Tab
		inner join Tablaxmod tm on t.Cd_tab = tm.Cd_Tab
		where 	con.RucE='''+@RucE+''' and tm.Cd_MR in ('''+@Cd_MR+''') and t.Cd_Tab = '''+@Cd_Tab+''' and cam.estado=1'
		print @consulta2
		exec(@consulta2)
	end
--end

--where 	con.RucE=@RucE and LEFT(cam.Cd_Tab, 2) = @prefijoTabla
--		where 	con.RucE=@RucE and tm.Cd_MR=@Cd_MR and t.Cd_Tab = @Cd_Tab and cam.estado=1
--and cam.Cd_Tab like '%' + @prefijoTabla + '%' and cam.Estado = 1
		
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>
-- MP : 2011-01-12 : <Modificacion del procedimiento almacenado>
-- MP : 2011-01-14 : <Modificacion del procedimiento almacenado>
-- MP : 2011-01-19 : <Modificacion del procedimiento almacenado>
-- MP : 2011-01-25 : <Modificacion del procedimiento almacenado>
-- MP : 2011-02-03 : <Modificacion del procedimiento almacenado>
-- CE : 2012-04-10 : <Modificacion del procedimiento almacenado>
/*
DEMO:
exec user321.CfgCampoConsxTabla '11111111111', 'CP', null
*/
-- exec user321.CfgCampoConsxTabla_2 '11111111111', '13','FB03',null
GO
