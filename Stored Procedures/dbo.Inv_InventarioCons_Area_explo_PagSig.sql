SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_Area_explo_PagSig]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Area nvarchar(6),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@Cd_Mda char(2),
--------------------------------------
@TamPag int, --Tamano Pagina
@Ult_CdInv char(12),
@Ult_Fec Datetime,
@NroRegs int output,--Nro de Registros solo es consultado la primera vez
@NroPags int output,--Nro de Paginas solo es Consulado la primera vez
@Max char(12) output,
@Min char(12) output,
@MaxFec datetime output,
@MinFec datetime output,
--------------------------------------
@msj varchar(100) output
as

	declare @Inter varchar(1000)

	--Interseccion
	set @Inter = 'inventario a inner join Area Ar on Ar.Cd_Area=a.Cd_Area and a.RucE=Ar.RucE
	      		inner join Producto2 Pro2 on Pro2.Cd_Prod=a.Cd_Prod and a.RucE=Pro2.RucE
	      		inner join Prod_UM PUM1 on PUM1.ID_UMP=a.ID_UMP and a.RucE=PUM1.RucE and a.Cd_Prod=PUM1.Cd_Prod
	      		inner join Prod_UM PUM2 on PUM2.ID_UMP=a.ID_UMBse and a.RucE=PUM2.RucE and a.Cd_Prod=PUM2.Cd_Prod
	      		left join mtvoIngSal MIS on MIS.Cd_MIS=a.Cd_MIS and a.RucE=MIS.RucE'
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	--Condicion
	set @Cond = 'a.RucE=''' + @RucE + ''' and a.Cd_Prod='''+@Cd_Prod+''' and a.Cd_Area like '''+@Cd_Area+''' and a.FecMov between '''+ convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+' 23:59:59'''
	if @Ult_CdInv is not null
		set @Cond = @Cond + ' and a.FecMov >= '''+convert(nvarchar, @Ult_Fec, 103)+' '+convert(nvarchar, @Ult_Fec, 114) +''' and not (a.Cd_Inv <= '''+Convert(nvarchar, @Ult_CdInv) +''' and  a.FecMov = '''+convert(nvarchar, @Ult_Fec, 103)+' '+convert(nvarchar, @Ult_Fec, 114) +''')'
	print @Cond
	if(@Colum = 'Cd_Inv') set @Cond = @Cond+ ' and a.Cd_Inv like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and a.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_Area') set @Cond =@Cond+ ' and a.Cd_Area like '''+@Dato+''''
	else if(@Colum = 'Area') set @Cond = @Cond+' and Ar.Descrip like '''+@Dato+''''
	else if(@Colum = 'Cd_Prod') set @Cond = @Cond+' and a.Cd_Prod like '''+@Dato+''''
	else if(@Colum = 'Producto') set @Cond = @Cond+' and Pro2.Nombre1 like '''+@Dato+''''
	else if(@Colum = 'ID_UMP') set @Cond = @Cond+' and a.ID_UMP like '''+@Dato+''''
	else if(@Colum = 'Descripcion1') set @Cond = @Cond+' and PUM1.DescripAlt like '''+@Dato+''''
	else if(@Colum = 'ID_UMBse') set @Cond = @Cond+' and a.ID_UMBse like '''+@Dato+''''
	else if(@Colum = 'Descripcion2') set @Cond = @Cond+' and PUM2.DescripAlt like '''+@Dato+''''
	else if(@Colum = 'StockMin') set @Cond = @Cond+' and PRO2.StockMin like '''+@Dato+''''
	else if(@Colum = 'StockMax') set @Cond =@Cond+ ' and PRO2.StockMax like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond = @Cond+' and convert(nvarchar,a.FecMOv,103) like '''+@Dato+''''
	else if(@Colum = 'IC_ES') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' like '''+@Dato+''''
	else if(@Colum = 'Motivo') set @Cond=@Cond +' and MIS.Descrip like '''+@Dato+''''
	else if(@Colum = 'ECant') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Cant) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'ECosUnt') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then Convert(nvarchar, a.CosUnt) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'ETotal') set @Cond=@Cond +' and case(a.IC_ES) when ''E'' then Convert(nvarchar, a.Total) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'SCant') set @Cond=@Cond +' and case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Cant*-1) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'SCosUnt') set @Cond=@Cond +' and  case(a.IC_ES) when ''S'' then Convert(nvarchar, a.CosUnt) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'STotal') set @Cond=@Cond +' and case(a.IC_ES) when ''S'' then Convert(nvarchar, a.Total*-1) else ''-'' like '''+@Dato+''''
	else if(@Colum = 'Suma_Cantidad') set @Cond=@Cond +' and a.SCant like '''+@Dato+''''
	else if(@Colum = 'CProm') set @Cond=@Cond +' and a.CProm like '''+@Dato+''''
	else if(@Colum = 'SCT') set @Cond=@Cond +' and a.SCT like '''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond=@Cond +' and a.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond=@Cond +' and a.Cd_SC like '''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond=@Cond +' and a.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'Cd_GR') set @Cond=@Cond +' and a.Cd_GR like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond=@Cond +' and a.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond=@Cond +' and a.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond=@Cond +' and a.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond=@Cond +' and a.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond=@Cond +' and a.CA05 like '''+@Dato+''''
	
	declare @Consulta nvarchar(4000)
	declare @x varchar(5)
	if(@Cd_Mda = '01')
		set @x =''
	else
		set @x= '_ME'
	set @Consulta='		select top '+convert(nvarchar,@TamPag)+'
		a.Cd_Inv,a.RegCtb,a.Cd_Area,Ar.Descrip as Area, a.Cd_Prod, Pro2.CodCo1_, Pro2.Nombre1 as Producto,
		a.ID_UMP,PUM1.DescripAlt as Descripcion1,a.ID_UMBse,PUM2.DescripAlt as Descripcion2,
		PRO2.StockMin, PRO2.StockMax, a.FecMov, case(a.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' end as IC_ES,
		MIS.Descrip as Motivo, case(a.IC_ES) when ''E'' then Convert(nvarchar,a.Cant) else ''-'' end as ECant,
		case(a.IC_ES) when ''E'' then Convert(nvarchar, a.CosUnt'+@x+') else ''-'' end as ECosUnt,
		case(a.IC_ES) when ''E'' then Convert(nvarchar, a.Total'+@x+') else ''-'' end as ETotal,
		case(a.IC_ES) when ''S'' then Convert(nvarchar,a.Cant*-1) else ''-'' end as SCant,
		case(a.IC_ES) when ''S'' then Convert(nvarchar, a.CosUnt'+@x+') else ''-'' end as SCosUnt,
		case(a.IC_ES) when ''S'' then Convert(nvarchar, a.Total'+@x+'*-1) else ''-'' end as STotal,
		a.SCant as Suma_Cantidad, a.CProm, a.SCT, a.Cd_CC,a.Cd_SC,a.Cd_SS, a.Cd_GR,a.CA01,a.CA02,a.CA03,a.CA04,a.CA05
		from '+@inter+' 
		where '+@Cond+ ' order by a.FecMov, a.Cd_Inv'
 	
	Exec (@Consulta)
	if(@Ult_CdInv is null) -- si es primera pagina y primera busqueda
	begin
		set @sql = 'select @Regs = count(*) from ' +@Inter+ ' where '+@Cond
		exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		set @NroPags = @NroRegs/@TamPag + case when @NroRegs%@TamPag=0 then 0 else 1 end
	end
	set @sql = 'select top 1 @RMin = Cd_Inv from ' + @Inter + ' where ' +@Cond+' order by a.FecMov, a.Cd_Inv'
	exec sp_executesql @sql, N'@RMin char(12) output', @Min output
	set @sql = 'select top 1 @RMinFec = FecMov from ' + @Inter + ' where ' +@Cond+' order by a.FecMov, a.Cd_Inv'
	exec sp_executesql @sql, N'@RMinFec datetime output', @MinFec output
	
	set @sql = 'select top 1 @RMax = Cd_Inv from (select top '+ convert(nvarchar,@TamPag) +' Cd_Inv, FecMov  from ' + @Inter + ' where ' + @Cond +' order by a.FecMov, a.Cd_Inv) as Inventario order by FecMov desc,Cd_Inv desc'
	exec sp_executesql @sql, N'@RMax char(12) output',@Max output
	set @sql = 'select top 1 @RMaxFec = FecMov from (select top '+ convert(nvarchar,@TamPag) +' Cd_Inv, FecMov  from ' + @Inter + ' where ' + @Cond +' order by a.FecMov, a.Cd_Inv) as Inventario order by FecMov desc,Cd_Inv desc'
	exec sp_executesql @sql, N'@RMaxFec datetime output',@MaxFec output

-- Leyenda --
-- JJ : 2010-07-19 	: <Creacion del procedimiento almacenado>

-- Epsilower 14/04/2011 11:31:10:083 : Modificacion Correcccion del los max y min, reorden y en la condicion

/*
declare
@NroRegs int,
@NroPags int,
@Max char(12),
@Min char(12),
@MaxFec datetime,
@MinFec datetime 

exec dbo.Inv_InventarioCons_Area_explo_PagSig '11111111111','PD00001','0001','01/01/2010','31/12/2011',null, null, 10, null, null, @NroRegs output, @NroPags output, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec
exec dbo.Inv_InventarioCons_Area_explo_PagSig '11111111111','PD00001','0001','01/01/2010','31/12/2011',null, null, 10, @Max, @MaxFec, @NroRegs output, @NroPags output, @Max output, @Min output, @MaxFec output, @MinFec output, null
select @NroRegs,@NroPags, @Min, @MinFec, @Max, @MaxFec

	select top 10 *
		from inventario a inner join Area Ar on Ar.Cd_Area=a.Cd_Area and a.RucE=Ar.RucE
		      		inner join Producto2 Pro2 on Pro2.Cd_Prod=a.Cd_Prod and a.RucE=Pro2.RucE
		      		inner join Prod_UM PUM1 on PUM1.ID_UMP=a.ID_UMP and a.RucE=PUM1.RucE and a.Cd_Prod=PUM1.Cd_Prod
		      		inner join Prod_UM PUM2 on PUM2.ID_UMP=a.ID_UMBse and a.RucE=PUM2.RucE and a.Cd_Prod=PUM2.Cd_Prod
		      		left join mtvoIngSal MIS on MIS.Cd_MIS=a.Cd_MIS and a.RucE=MIS.RucE 
		where a.RucE='11111111111' and a.Cd_Prod='PD00001' and a.Cd_Area='0001' and a.FecMov between '01/01/2010' and '31/12/2011' order by a.FecMov, a.Cd_Inv
*/

GO
