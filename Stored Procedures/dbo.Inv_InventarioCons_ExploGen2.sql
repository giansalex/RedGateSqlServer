SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_ExploGen2]
@RucE nvarchar(11),
--@Cd_Prod char(7),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@Cd_Mda char(2),
--------------------------------------
@msj varchar(100) output
as
	declare @Inter varchar(1000)
	
	--Interseccion
	set @Inter = 'Inventario a 
		inner join Almacen e on e.Cd_Alm=a.Cd_Alm and e.RucE = a.RucE
		inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and d.RucE = a.RucE
		left join TipDocES f on f.Cd_TDES=a.Cd_TDES and f.RucE = a.RucE
		left join TIPDOC g on g.Cd_TD=a.Cd_TD 
		inner join Prod_UM b on b.RucE=a.RucE and b.Cd_Prod=a.Cd_Prod and b.ID_UMP=a.ID_UMBse
		inner join UnidadMedida c on c.Cd_UM=b.Cd_UM
		left join Area h on h.Cd_Area=a.Cd_Area and h.RucE=a.RucE
		left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE'
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	set @Cond = 'a.RucE=''' + @RucE + ''' and a.FecMov between '''+ convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+' 23:59:29'''
	if(@Colum = 'Cd_Inv') set @Cond = @Cond+ ' and a.Cd_Inv like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and a.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_Alm') set @Cond =@Cond+ ' and a.Cd_Alm like '''+@Dato+''''
	else if(@Colum = 'NombreAlm') set @Cond = @Cond+' and e.Nombre like '''+@Dato+''''
	else if(@Colum = 'Cd_Prod') set @Cond = @Cond+' and a.Cd_Prod like '''+@Dato+''''
	else if(@Colum = 'NombreProducto') set @Cond = @Cond+' and d.Nombre1 like '''+@Dato+''''
	else if(@Colum = 'Descrip') set @Cond = @Cond+' and d.Descrip like '''+@Dato+''''
	else if(@Colum = 'ID_UMP') set @Cond = @Cond+' and  a.ID_UMBse like '''+@Dato+''''
	else if(@Colum = 'UnidadMedida') set @Cond = @Cond+' and c.Nombre like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond = @Cond+' and convert(varchar, a.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_TDES') set @Cond = @Cond+' and a.Cd_TDES like '''+@Dato+''''
	else if(@Colum = 'NombreDOCES') set @Cond = @Cond+' and f.Nombre like '''+@Dato+''''
	else if(@Colum = 'NCorto') set @Cond =@Cond+ ' and g.NCorto like '''+@Dato+''''
	else if(@Colum = 'NroSre') set @Cond = @Cond+' and a.NroSre like'''+@Dato+''''
	else if(@Colum = 'NroDoc') set @Cond = @Cond+' and a.NroDoc like '''+@Dato+''''
	else if(@Colum = 'Ejer') set @Cond = @Cond+' and a.Ejer like '''+@Dato+''''
	else if(@Colum = 'Factor') set @Cond = @Cond+' and b.Factor like '''+@Dato+''''
	else if(@Colum = 'DescripAlt') set @Cond=@Cond +' and b.DescripAlt like '''+@Dato+''''
	else if(@Colum = 'Area') set @Cond=@Cond +' and h.Descrip like '''+@Dato+''''
	else if(@Colum = 'StockMin') set @Cond=@Cond +' and d.StockMin like '''+@Dato+''''
	else if(@Colum = 'StockMax') set @Cond=@Cond +' and d.StockMax like '''+@Dato+''''
	--else if(@Colum = 'IC_ES') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' like '''+@Dato+''''
	else if(@Colum = 'IC_ES') set @Cond=@Cond +' and a.IC_ES like '''+@Dato+''''
	else if(@Colum = 'Descrip2') set @Cond=@Cond +' and i.Descrip like '''+@Dato+''''
	--else if(@Colum = 'ECant') set @Cond=@Cond +' and Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Cant) else ''-'' like '''+@Dato+''''
	--else if(@Colum = 'ECosUnt') set @Cond=@Cond +' and Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.CosUnt) else ''-'' like '''+@Dato+''''
	--else if(@Colum = 'ETotal') set @Cond=@Cond +' and Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Total) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'ECant') set @Cond=@Cond +' and a.Cant like '''+@Dato+''' and a.IC_ES like ''E'''
	else if(@Colum = 'ECosUnt') set @Cond=@Cond +' and a.CosUnt like '''+@Dato+''' and a.IC_ES like ''E'''
	else if(@Colum = 'ETotal') set @Cond=@Cond +' and a.Total like '''+@Dato+''' and a.IC_ES like ''E'''
	--else if(@Colum = 'SCant') set @Cond=@Cond +' and Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Cant*-1) else ''-'' like '''+@Dato+''''
	--else if(@Colum = 'SCosUnt') set @Cond=@Cond +' and  Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.CosUnt) else ''-'' like '''+@Dato+''''
	--else if(@Colum = 'STotal') set @Cond=@Cond +' and Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Total*-1) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'ECant') set @Cond=@Cond +' and a.Cant like '''+@Dato+''' and a.IC_ES like ''S'''
	else if(@Colum = 'ECosUnt') set @Cond=@Cond +' and a.CosUnt like '''+@Dato+''' and a.IC_ES like ''S'''
	else if(@Colum = 'ETotal') set @Cond=@Cond +' and a.Total like '''+@Dato+''' and a.IC_ES like ''S'''
	else if(@Colum = 'Suma_Cantidad') set @Cond=@Cond +' and a.SCant like '''+@Dato+''''
	else if(@Colum = 'CProm') set @Cond=@Cond +' and a.CProm like '''+@Dato+''''
	else if(@Colum = 'SCT') set @Cond=@Cond +' and a.SCT like '''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond=@Cond +' and a.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond=@Cond +' and a.Cd_SC, like '''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond=@Cond +' and a.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'NroGC') set @Cond=@Cond +' and a.NroGC like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond=@Cond +' and a.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond=@Cond +' and a.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond=@Cond +' and a.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond=@Cond +' and a.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond=@Cond +' and a.CA05 like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond=@Cond +' and convert(varchar,a.FecReg,103) like '''+@Dato+''''
	else if(@Colum = 'FecMdf') set @Cond=@Cond +' and convert(varchar,a.FecMdf,103) like '''+@Dato+''''
	else if(@Colum = 'UsuCrea') set @Cond=@Cond +' and a.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'UsuModf') set @Cond=@Cond +' and a.UsuModf like '''+@Dato+''''

	declare @Consulta nvarchar(4000)
	declare @x varchar(5)
	if(@Cd_Mda = '01')
		set @x =''
	else
		set @x= '_ME'
	set @Consulta = 'select *, ECant-SCant as Suma_Cantidad,  case(ECant-SCant) when 0 then 0 else abs((ETotal-STotal)/(ECant-SCant)) end as CProm, ETotal-STotal as SCT
		from(
			select a.Cd_Prod, d.CodCo1_, d.Nombre1 as NombreProducto , d.Descrip,c.Nombre as DescBase,
			sum(Case(a.IC_ES) when ''E'' then a.Cant else 0 end) as ECant,
			sum(Case(a.IC_ES) when ''E'' then a.Total'+@x+' else 0 end) as ETotal,
			abs(sum(Case(a.IC_ES) when ''S'' then Cant else 0 end)) as SCant,
			abs(sum(Case(a.IC_ES) when ''S'' then Total'+@x+' else 0 end)) as STotal 
			from '+@inter+' 
			where '+ @Cond+ ' 
			group by a.Cd_Prod, d.CodCo1_, d.Nombre1, d.Descrip,c.Nombre
		) as inv 
		order by Cd_Prod'
		print @Consulta
	Exec (@Consulta)
	set @Consulta = 'select  ''Total >>>>'' as ''TextoTotal'', sum(ECant) as ''ESaldoCant'', sum(Etotal) as ''ECostoTotal'', sum(SCant) as ''SSaldoTotal'', sum(STotal) as ''SCostoTotal'', sum(ETotal-STotal) as ''TotalSaldo''
		from(
			select a.Cd_Prod,d.Nombre1 as NombreProducto , d.Descrip,c.Nombre as DescBase,
			sum(Case(a.IC_ES) when ''E'' then a.Cant else 0 end) as ECant,
			sum(Case(a.IC_ES) when ''E'' then a.Total'+@x+' else 0 end) as ETotal,
			abs(sum(Case(a.IC_ES) when ''S'' then Cant else 0 end)) as SCant,
			abs(sum(Case(a.IC_ES) when ''S'' then Total'+@x+' else 0 end)) as STotal 
			from '+@inter+' 
			where '+ @Cond+ ' 
			group by a.Cd_Prod, d.Nombre1, d.Descrip,c.Nombre
		) as inv '
		
		print @Consulta
	Exec (@Consulta)
--Pruebas:
--exec Inv_InventarioCons_ExploGen2 '11111111111', '01/01/2011','02/09/2011', 'ECant', '%5.000%', 200, '01'

-- MM: Creacion del sp

--epsilower _ME
GO
