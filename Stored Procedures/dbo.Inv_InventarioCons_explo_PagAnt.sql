SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_explo_PagAnt]
@RucE nvarchar(11),
@Cd_Prod char(7),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@Cd_Mda char(2),
--------------------------------------
@TamPag int, --Tamano Pagina
@Ult_CdInv char(12),
@Ult_Fec Datetime,
@Max char(12) output,
@Min char(12) output,
@MaxFec datetime output,
@MinFec datetime output,
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
		inner join Prod_UM b on b.RucE=a.RucE and b.Cd_Prod=a.Cd_Prod and b.ID_UMP=a.ID_UMP
		inner join UnidadMedida c on c.Cd_UM=b.Cd_UM
		left join Area h on h.Cd_Area=a.Cd_Area and h.RucE=a.RucE
		left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE'
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	--Condicion	
	set @Cond = 'a.RucE=''' + @RucE + ''' and a.Cd_Prod='''+@Cd_Prod+''' and a.FecMov between '''+ convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+ ' 23:59:29'+''' and a.FecMov <= '''+convert(nvarchar, @Ult_Fec, 103)+' '+convert(nvarchar, @Ult_Fec, 114) +''' and not (a.Cd_Inv >='''+Convert(nvarchar, @Ult_CdInv) +''' and  a.FecMov = '''+convert(nvarchar, @Ult_Fec, 103)+' '+convert(nvarchar, @Ult_Fec, 114) +''')'
	print @Cond --
	if(@Colum = 'Cd_Inv') set @Cond = @Cond+ ' and a.Cd_Inv like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and a.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_Alm') set @Cond =@Cond+ ' and a.Cd_Alm like '''+@Dato+''''
	else if(@Colum = 'NombreAlm') set @Cond = @Cond+' and e.Nombre like '''+@Dato+''''
	else if(@Colum = 'Cd_Prod') set @Cond = @Cond+' and a.Cd_Prod like '''+@Dato+''''
	else if(@Colum = 'NombreProducto') set @Cond = @Cond+' and d.Nombre1 like '''+@Dato+''''
	else if(@Colum = 'Descrip') set @Cond = @Cond+' and d.Descrip like '''+@Dato+''''
	else if(@Colum = 'ID_UMP') set @Cond = @Cond+' and a.ID_UMBse like '''+@Dato+''''
	else if(@Colum = 'Cant_Ing') set @Cond = @Cond+' and  a.Cant_Ing like '''+@Dato+''''
	--else if(@Colum = 'UnidadMedida') set @Cond = @Cond+' and c.Nombre like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond = @Cond+' and a.FecMov like '''+@Dato+''''
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
	else if(@Colum = 'IC_ES') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' like '''+@Dato+''''
	else if(@Colum = 'Descrip2') set @Cond=@Cond +' and i.Descrip like '''+@Dato+''''
	else if(@Colum = 'ECant') set @Cond=@Cond +' and Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Cant) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'ECosUnt') set @Cond=@Cond +' and Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.CosUnt) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'ETotal') set @Cond=@Cond +' and Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Total) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'SCant') set @Cond=@Cond +' and Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Cant*-1) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'SCosUnt') set @Cond=@Cond +' and  Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.CosUnt) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'STotal') set @Cond=@Cond +' and Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Total*-1) else ''-'' like '''+@Dato+''''
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
	set @Consulta = '	select *from(select top '+ convert(nvarchar,@TamPag) +'
		a.Cd_Inv, a.RegCtb,a.Cd_Alm, e.Nombre as NombreAlm,
		a.Cd_Prod, d.CodCo1_, d.Nombre1 as NombreProducto , d.Descrip, a.ID_UMP as ID_UMP,c.Nombre as DescBase,
		a.FecMov,
		a.Cd_TDES, f.Nombre as NombreDOCES, g.NCorto, a.NroSre, a.NroDoc,
		a.Ejer, b.Factor, b.DescripAlt,h.Descrip as Area, d.StockMin,d.StockMax,
		case(a.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' end as IC_ES,
		i.Descrip as Descrip2, Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Cant) else ''-'' end as ECant,
		Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.CosUnt'+@x+') else ''-'' end as ECosUnt,
		Case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Total'+@x+') else ''-'' end as ETotal,
		Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Cant*-1) else ''-'' end as SCant,
		Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.CosUnt'+@x+') else ''-'' end as SCosUnt,
		Case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Total'+@x+'*-1) else ''-'' end as STotal,
		a.SCant as Suma_Cantidad, a.CProm, a.SCT, a.Cd_CC, a.Cd_SC, a.Cd_SS,  a.Cd_OF, a.NroGC,
		a.CA01, a.CA02, a.CA03, a.CA04, a.CA05, convert(varchar,a.FecReg,103) as FecReg,
		convert(varchar,a.FecMdf,103) as FecMdf, a.UsuCrea, a.UsuModf
		from '+@inter+' 
		where '+@Cond+ ' order by a.FecMov desc ,a.Cd_Inv desc)  as Inventario order by FecMov,Cd_Inv' 
	
	Exec (@Consulta)

	set @sql = 'select top 1 @RMin = Cd_Inv from(select top '+ convert(nvarchar,@TamPag) +' a.Cd_Inv, a.FecMov from ' + @Inter + ' where ' +@Cond+' order by a.FecMov desc ,a.Cd_Inv desc)  as Inventario order by FecMov,Cd_Inv'
	exec sp_executesql @sql, N'@RMin char(12) output', @Min output
	set @sql = 'select top 1 @RMinFec = FecMov from(select top '+ convert(nvarchar,@TamPag) +' a.Cd_Inv, a.FecMov from ' + @Inter + ' where ' +@Cond+' order by a.FecMov desc ,a.Cd_Inv desc)  as Inventario order by FecMov,Cd_Inv'
	exec sp_executesql @sql, N'@RMinFec datetime output', @MinFec output
	
	set @sql = 'select top 1 @RMax = a.Cd_Inv  from ' + @Inter + ' where ' + @Cond +' order by a.FecMov desc ,a.Cd_Inv desc'
	exec sp_executesql @sql, N'@RMax char(12) output',@Max output
	set @sql = 'select top 1 @RMaxFec = a.FecMov  from ' + @Inter + ' where ' + @Cond +' order by a.FecMov desc ,a.Cd_Inv desc'
	exec sp_executesql @sql, N'@RMaxFec datetime output',@MaxFec output

-- Leyenda --
-- JJ : 2010-07-09 	: <Creacion del procedimiento almacenado>
-- JJ : 2010-07-13	: <Modificacion del procedimiento almacenado>
-- JJ : 2010-07-16	: <Modificacion del procedimiento almacenado>
-- PV: 15/11/2010	: Mdf: Error en consulta por IC_ES
-- JJ: 21/02/2011	: Mdf: se cambio el criterio de orden de Cd_Inv a FecMov

-- Epsilower 13/04/2011 12:58:22:932 : Modificacion Correcccion del los max y min, reorden y en la condicion

/*
declare
@NroRegs int,
@NroPags int,
@Max char(12),
@Min char(12),
@MaxFec datetime,
@MinFec datetime 

exec dbo.Inv_InventarioCons_explo_PagSig '11111111111','PD00001','01/01/2010','31/12/2011',null, null, 10, null, null, @NroRegs output, @NroPags output, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec
exec dbo.Inv_InventarioCons_explo_PagSig '11111111111','PD00001','01/01/2010','31/12/2011',null, null, 10, @Max, @MaxFec, @NroRegs output, @NroPags output, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec
exec dbo.Inv_InventarioCons_explo_PagAnt '11111111111','PD00001','01/01/2010','31/12/2011',null, null, 10, @Min, @MinFec, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec
exec dbo.Inv_InventarioCons_explo_PagSig '11111111111','PD00001','01/01/2010','31/12/2011',null, null, 10, @Max, @MaxFec, @NroRegs output, @NroPags output, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec
exec dbo.Inv_InventarioCons_explo_PagSig '11111111111','PD00001','01/01/2010','31/12/2011',null, null, 10, @Max, @MaxFec, @NroRegs output, @NroPags output, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec
exec dbo.Inv_InventarioCons_explo_PagAnt '11111111111','PD00001','01/01/2010','31/12/2011',null, null, 10, @Min, @MinFec, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec
exec dbo.Inv_InventarioCons_explo_PagAnt '11111111111','PD00001','01/01/2010','31/12/2011',null, null, 10, @Min, @MinFec, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec

select *from(select top 10 a.Cd_Inv, a.RegCtb,a.FecMov
 		from Inventario a 
		inner join Almacen e on e.Cd_Alm=a.Cd_Alm and e.RucE = a.RucE
		inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and d.RucE = a.RucE
		left join TipDocES f on f.Cd_TDES=a.Cd_TDES and f.RucE = a.RucE
		left join TIPDOC g on g.Cd_TD=a.Cd_TD 
		inner join Prod_UM b on b.RucE=a.RucE and b.Cd_Prod=a.Cd_Prod and b.ID_UMP=a.ID_UMP
		inner join UnidadMedida c on c.Cd_UM=b.Cd_UM
		left join Area h on h.Cd_Area=a.Cd_Area and h.RucE=a.RucE
		left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE
where a.RucE='11111111111' and a.Cd_Prod='PD00001' and a.FecMov between '01/01/2010' and '31/12/2011' and a.FecMov <= '23/02/2011 13:35:00:000' and not (a.Cd_Inv >='INV000000710' and  a.FecMov = '23/02/2011 13:35:00:000')
order by a.FecMov desc ,a.Cd_Inv desc)  as Inventario order by FecMov,Cd_Inv

select top 1 * from(select top 10  a.Cd_Inv, a.FecMov from Inventario a 
		inner join Almacen e on e.Cd_Alm=a.Cd_Alm and e.RucE = a.RucE
		inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and d.RucE = a.RucE
		left join TipDocES f on f.Cd_TDES=a.Cd_TDES and f.RucE = a.RucE
		left join TIPDOC g on g.Cd_TD=a.Cd_TD 
		inner join Prod_UM b on b.RucE=a.RucE and b.Cd_Prod=a.Cd_Prod and b.ID_UMP=a.ID_UMP
		inner join UnidadMedida c on c.Cd_UM=b.Cd_UM
		left join Area h on h.Cd_Area=a.Cd_Area and h.RucE=a.RucE
		left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE 
where a.RucE='11111111111' and a.Cd_Prod='PD00001' and a.FecMov between '01/01/2010' and '31/12/2011' and a.FecMov <= '03/08/2010 14:19:00:000' and not (a.Cd_Inv >='INV000000129' and  a.FecMov = '03/08/2010 14:19:00:000')
order by a.FecMov desc ,a.Cd_Inv desc)  as Inventario order by FecMov,Cd_Inv

select top 1 * from (select top 10 Cd_Inv, FecMov  from Inventario a 
		inner join Almacen e on e.Cd_Alm=a.Cd_Alm and e.RucE = a.RucE
		inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and d.RucE = a.RucE
		left join TipDocES f on f.Cd_TDES=a.Cd_TDES and f.RucE = a.RucE
		left join TIPDOC g on g.Cd_TD=a.Cd_TD 
		inner join Prod_UM b on b.RucE=a.RucE and b.Cd_Prod=a.Cd_Prod and b.ID_UMP=a.ID_UMP
		inner join UnidadMedida c on c.Cd_UM=b.Cd_UM
		left join Area h on h.Cd_Area=a.Cd_Area and h.RucE=a.RucE
		left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE 
where a.RucE='11111111111' and a.Cd_Prod='PD00001' and a.FecMov between '01/01/2010' and '31/12/2011' and a.FecMov <= '23/02/2011 13:35:00:000' and not (a.Cd_Inv >='INV000000710' and  a.FecMov = '23/02/2011 13:35:00:000')
order by a.FecMov, a.Cd_Inv) as Inventario order by  FecMov desc,  Cd_Inv desc
*/

-- exec Inv_InventarioCons_explo_PagAnt '20512141022','PD00434','01/03/2012','31/03/2012','','',1,'INV000001680','19/01/2012','','','','',''
GO
