SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_paAlm_Explo_PagAnt]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Alm varchar(20),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@Cd_Mda char(2),
------------------------------------------
@TamPag int, --Tamano Pagina
@Ult_CdInv char(12),
@Ult_Fec Datetime,
@Max char(12) output,
@Min char(12) output,
@MaxFec datetime output,
@MinFec datetime output,
------------------------------------------
@msj varchar(100) output
as
	declare @Inter varchar(1000)
	
	--Interseccion
	set @Inter = 'Inventario
		a inner join Prod_UM b on  b.ID_UMP=a.ID_UMP and a.RucE=b.RucE and a.Cd_Prod=b.Cd_Prod
		inner join Prod_UM c on c.ID_UMP=a.ID_UMBse and a.RucE=c.RucE and a.Cd_Prod=c.Cd_Prod
		inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and a.RucE=d.RucE
		left join mtvoIngSAl e on e.Cd_MIS=a.Cd_MIS and a.RucE=e.RucE
		inner join Almacen f on f.Cd_Alm=a.Cd_Alm and a.RucE=f.RucE'
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	--Condicion	
	set @Cond = 'a.RucE=''' + @RucE + ''' and a.Cd_Prod='''+@Cd_Prod+''' and a.Cd_Alm like '''+ @Cd_Alm+''' and a.FecMov between '''+ convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and a.FecMov <= '''+convert(nvarchar, @Ult_Fec, 103)+' '+convert(nvarchar, @Ult_Fec, 114) +''' and not (a.Cd_Inv >='''+Convert(nvarchar, @Ult_CdInv) +''' and  a.FecMov = '''+convert(nvarchar, @Ult_Fec, 103)+' '+convert(nvarchar, @Ult_Fec, 114) +''')'
	if(@Colum = 'Cd_Inv') set @Cond = @Cond+ ' and a.Cd_Inv like ''' + @Dato + ''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and a.RegCtb like ''' + @Dato+ ''''
	else if(@Colum = 'ID_UMP') set @Cond =@Cond+ ' and a.ID_UMP like ''' + @Dato + ''''
	else if(@Colum = 'Descrip1') set @Cond = @Cond+' and b.DescripAlt like ''' + @Dato + ''''
	else if(@Colum = 'ID_UMBse') set @Cond =@Cond+ ' and a.ID_UMBse like ''' + @Dato + ''''
	else if(@Colum = 'Descrip2') set @Cond =@Cond+ ' and c.DescripAlt like ''' + @Dato + ''''
	else if(@Colum = 'Cd_Prod') set @Cond =@Cond+ ' and a.Cd_Prod like ''' + @Dato + ''''
	else if(@Colum = 'NombreProducto') set @Cond =@Cond+ ' and d.Nombre1 like ''' + @Dato + ''''
	else if(@Colum = 'Cd_Alm') set @Cond =@Cond+ ' and a.Cd_Alm like ''' + @Dato + ''''
	else if(@Colum = 'NombreAlmacen') set @Cond =@Cond+ ' and f.Nombre like ''' + @Dato + ''''
	else if(@Colum = 'FecMov') set @Cond =@Cond+ ' and convert(varchar,a.FecMov,103) like ''' + @Dato + ''''
	else if(@Colum = 'IC_ES') set @Cond =@Cond+ ' and case(a.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' like ''' + @Dato + ''''
	else if(@Colum = 'Motivo') set @Cond =@Cond+ ' and e.Descrip like ''' + @Dato + ''''
	else if(@Colum = 'ECant') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Cant) else ''-'' like ''' + @Dato + ''''
	else if(@Colum = 'ECant') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Cant) else ''-'' like ''' + @Dato + ''''
	else if(@Colum = 'ECosUnt') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then Convert(nvarchar,a.CosUnt) else ''-'' like ''' + @Dato + ''''
	else if(@Colum = 'ETotal') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Total) else ''-'' like ''' + @Dato + ''''
	else if(@Colum = 'SCant') set @Cond=@Cond +' and case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Cant*-1) else ''-'' like ''' + @Dato + ''''
	else if(@Colum = 'SCosUnt') set @Cond=@Cond +' and case(a.IC_ES) when ''S'' then Convert(nvarchar,a.CosUnt) else ''-'' like ''' + @Dato + ''''
	else if(@Colum = 'STotal') set @Cond=@Cond +' and case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Total*-1) else ''-'' like ''' + @Dato + ''''
	else if(@Colum = 'Suma_Cantidad') set @Cond=@Cond + ' and a.scant like ''' + @Dato + ''''
	else if(@Colum = 'CProm') set @Cond=@Cond + ' and a.CProm like ''' + @Dato + ''''
	else if(@Colum = 'SCT') set @Cond=@Cond + ' and a.SCT like ''' + @Dato + ''''
	else if(@Colum = 'CA01') set @Cond=@Cond + ' and a.CA01 like ''' + @Dato + ''''
	else if(@Colum = 'CA02') set @Cond=@Cond + ' and a.CA02 like ''' + @Dato + ''''
	else if(@Colum = 'CA03') set @Cond=@Cond + ' and a.CA03 like ''' + @Dato + ''''
	else if(@Colum = 'CA04') set @Cond=@Cond + ' and a.CA04 like ''' + @Dato + ''''
	else if(@Colum = 'CA05') set @Cond=@Cond + ' and a.CA05 like ''' + @Dato + ''''
	
	declare @Consulta nvarchar(4000)
	declare @x varchar(5)
	if(@Cd_Mda = '01')
		set @x =''
	else
		set @x= '_ME'
	set @Consulta = '	select *from(select top ' + convert(nvarchar,@Tampag) + '
		a.Cd_Inv, a.RegCtb, a.ID_UMP, b.DescripAlt as Descrip1,a.ID_UMBse,c.DescripAlt as Descrip2,
		a.Cd_Prod, d.CodCo1_, d.Nombre1 as NombreProducto,a.Cd_Alm, f.Nombre as NombreAlmacen,FecMov,
		case(a.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' end as IC_ES, e.Descrip as Motivo,
		case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Cant) else ''-'' end as ECant,
		case(a.IC_ES) when ''E'' then Convert(nvarchar,a.CosUnt'+@x+') else ''-'' end as ECosUnt,
		case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Total'+@x+') else ''-'' end as ETotal,
		case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Cant*-1) else ''-''end as SCant,
		case(a.IC_ES) when ''S'' then Convert(nvarchar,a.CosUnt'+@x+') else ''-'' end as SCosUnt,
		case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Total'+@x+'*-1) else ''-'' end as STotal,
		a.scant as Suma_Cantidad,
		 a.CProm as CProm,
		 a.SCT as SCT,
		 a.CA01,a.CA02,a.CA03,a.CA04,a.CA05
		 from ' + @Inter + '
		where '+@Cond+ ' order by a.FecMov desc ,a.Cd_Inv desc)  as Inventario order by FecMov,Cd_Inv' 
	print @Consulta
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
-- JJ : 2010-07-14	: <Creacion del procedimiento almacenado>
-- JJ : 2010-07-16	: <Modificacion del procedimiento almacenado>

--- Epsilower 13/04/2011 16:41:29:382 : Modificacion Correcccion del los max y min, reorden y en la condicion


GO
