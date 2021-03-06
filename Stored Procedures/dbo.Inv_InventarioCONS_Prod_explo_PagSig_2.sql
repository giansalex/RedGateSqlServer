SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCONS_Prod_explo_PagSig_2]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
--------------------------------------
@TamPag int, --Tamano Pagina
@Ult_CdInv char(12),
@NroRegs int output,--Nro de Registros solo es consultado la primera vez
@NroPags int output,--Nro de Paginas solo es Consulado la primera vez
@Max char(12) output,
@Min char(12) output,
--------------------------------------
@msj varchar(100) output

as
set language 'spanish'
	declare @Inter varchar(1000)

	--Interseccion
		set @Inter = '				inventario Inv inner join Producto2 Prod on Prod.Cd_Prod=Inv.Cd_Prod and Inv.RucE=Prod.RucE
				inner join Prod_UM PUM1 on PUM1.ID_UMP=Inv.ID_UMP and Inv.RucE=PUM1.RucE and Inv.Cd_Prod=PUM1.Cd_Prod
				inner join Prod_UM PUM2 on PUM2.ID_UMP=Inv.ID_UMBse and Inv.RucE=PUM2.RucE and Inv.Cd_Prod=PUM2.Cd_Prod
				inner join Almacen Alm on Alm.Cd_Alm=Inv.Cd_Alm and Alm.RucE=Inv.RucE
				left join Area Ar on Ar.Cd_Area=Inv.Cd_Area and Inv.RucE=Ar.RucE
				left join Proveedor2 Prv on Prv.Cd_Prv=Inv.Cd_Prv and Inv.RucE=Prv.RucE
				left join Cliente2 Clt on Clt.Cd_Clt=Inv.Cd_Clt and Inv.RucE=Clt.RucE
				left join MtvoIngSal Mtvo on Mtvo.Cd_MIS=Inv.Cd_MIS and Inv.RucE=Mtvo.RucE'
	--print @Inter
	declare @Cond varchar(1000)
	declare @Cond1 varchar(1000)
	declare @sql nvarchar(1000)
	--Condicion
	set @Cond = 'Inv.RucE='''+@RucE+''' and Inv.FecMov between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and Inv.Cd_Inv > ''' + Convert(nvarchar,isnull(@Ult_CdInv,'')) +''''

	if(@Colum = 'Cd_Inv') set @Cond = @Cond+ ' and Inv.Cd_Inv like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and Inv.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_Prod') set @Cond =@Cond+ ' and Inv.Cd_Prod like '''+@Dato+''''
	else if(@Colum = 'Producto') set @Cond = @Cond+' and Prod.Nombre1 like '''+@Dato+''''
	else if(@Colum = 'ID_UMP') set @Cond = @Cond+' and Inv.ID_UMP like '''+@Dato+''''
	else if(@Colum = 'Descrip1') set @Cond = @Cond+' and PUM1.DescripAlt like '''+@Dato+''''
	else if(@Colum = 'ID_UMBse') set @Cond = @Cond+' and Inv.ID_UMBse like '''+@Dato+''''
	else if(@Colum = 'Descrip2') set @Cond = @Cond+' and PUM2.DescripAlt like '''+@Dato+''''
	else if(@Colum = 'Cd_Alm') set @Cond = @Cond+' and Inv.Cd_Alm like '''+@Dato+''''
	else if(@Colum = 'Almacen') set @Cond = @Cond+' and Alm.Nombre like '''+@Dato+''''
	else if(@Colum = 'Cd_Area') set @Cond = @Cond+' and Inv.Cd_Area like '''+@Dato+''''
	else if(@Colum = 'Area') set @Cond =@Cond+ ' and Ar.Descrip like '''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond = @Cond+' and Inv.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond=@Cond +' and Inv.Cd_SC like '''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond=@Cond +' and Inv.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'Cd_Prv') set @Cond=@Cond +' and Inv.Cd_Prv like '''+@Dato+''''
	else if(@Colum = 'NDOC_Prv') set @Cond=@Cond +' and Prv.NDOC like '''+@Dato+''''
	else if(@Colum = 'Proveedor') set @Cond=@Cond +' and case when Prv.RSocial is not null then Prv.RSocial like ''' + @Dato + ''' else (isnull(Prv.ApPat,'''') +'' ''+ isnull(Prv.ApMat,'''') + '' ''+ isnull(Prv.Nom,'''')) end like '''+@Dato+''''
	else if(@Colum = 'Cd_Clt') set @Cond=@Cond +' and Inv.Cd_Clt like '''+@Dato+''''
	else if(@Colum = 'NDOC_Clt') set @Cond=@Cond +' and  Clt.NDOC like '''+@Dato+''''
	else if(@Colum = 'Cliente') set @Cond=@Cond +' and case when Clt.RSocial is not null then Clt.RSocial like ''' + @Dato + ''' else (isnull(Clt.ApPat,'''') +'' ''+ isnull(Clt.ApMat,'''') + '' ''+ isnull(Clt.Nom,'''')) end like '''+@Dato+''''
	else if(@Colum = 'IC_ES') set @Cond=@Cond +' and Case(Inv.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' end like '''+@Dato+''''
--	else if(@Colum = 'IC_ES') set @Cond=@Cond +' and Case(Inv.IC_ES) when ''Entrada'' then ''E'' else ''S'' end like '''+@Dato+''''
	else if(@Colum = 'Mot_Ing_Sal') set @Cond=@Cond +' and Mtvo.Descrip like '''+@Dato+''''
--
	else if(@Colum = 'Cd_MIS') set @Cond = @Cond+' and INV.Cd_MIS like '''+@Dato+''''
--
	else if(@Colum = 'FecMov') set @Cond=@Cond +' and Convert(nvarchar,Inv.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'Cant') set @Cond=@Cond +' and Abs(Inv.Cant) like '''+@Dato+''''
	else if(@Colum = 'CosUnt') set @Cond=@Cond +' and Abs(Inv.CosUnt) like '''+@Dato+''''
	else if(@Colum = 'Total') set @Cond=@Cond +' and Abs(Inv.Total) like '''+@Dato+''''
	else if(@Colum = 'Cd_Gr') set @Cond=@Cond +' and Inv.Cd_Gr like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond=@Cond +' and Inv.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond=@Cond +' and Inv.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond=@Cond +' and Inv.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond=@Cond +' and Inv.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond=@Cond +' and Inv.CA05 like '''+@Dato+''''
---
	else if(@Colum = 'Cd_Vta') set @Cond=@Cond +' and Inv.Cd_Vta like '''+@Dato+''''
	else if(@Colum = 'Cd_OP') set @Cond=@Cond +' and Inv.Cd_OP like '''+@Dato+''''
	else if(@Colum = 'Cd_Com') set @Cond=@Cond +' and Inv.Cd_Com like '''+@Dato+''''
	else if(@Colum = 'Cd_OC') set @Cond=@Cond +' and Inv.Cd_OC like '''+@Dato+''''
	else if(@Colum = 'Cd_SR') set @Cond=@Cond +' and Inv.Cd_SR like '''+@Dato+''''
	else if(@Colum = 'Cd_OF') set @Cond=@Cond +' and Inv.Cd_OF like '''+@Dato+''''
---
	else if(@Colum = 'UsuCrea') set @Cond=@Cond +' and Inv.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'CodCom') set @Cond=@Cond +' and Prod.CodCo1_ like '''+@Dato+''''
	else if(@Colum = 'Factor') set @Cond=@Cond +' and PUM1.Factor like '''+@Dato+''''
	

	declare @Consulta nvarchar(4000)
		set @Consulta='		select top '+convert(nvarchar,@TamPag)+'
				Inv.Cd_Inv, Inv.RegCtb, Inv.Cd_Prod, Prod.CodCo1_ as CodCom, Prod.Nombre1 as Producto, Inv.ID_UMP, PUM1.DescripAlt as Descrip1,
				Inv.ID_UMBse, PUM2.DescripAlt as Descrip2, PUM1.Factor, Inv.Cd_Alm, Alm.Nombre as Almacen, Inv.Cd_Area, Ar.Descrip as Area,
				Inv.Cd_CC, Inv.Cd_SC, Inv.Cd_SS, Inv.Cd_Prv,Prv.NDOC as NDOC_Prv, case when Prv.RSocial is not null then Prv.RSocial else (isnull(Prv.ApPat,'''') +'' ''+ isnull(Prv.ApMat,'''') + '' ''+ isnull(Prv.Nom,'''')) end as Proveedor,
				Inv.Cd_Clt,Clt.NDOC as NDOC_Clt, case when Clt.RSocial is not null then Clt.RSocial else (isnull(Clt.ApPat,'''') +'' ''+ isnull(Clt.ApMat,'''') + '' ''+ isnull(Clt.Nom,'''')) end as Cliente,
				Case(Inv.IC_ES) when ''E'' then ''Entrada'' else ''Salida'' end as IC_ES, Mtvo.Descrip as ''Mot_Ing_Sal'', Inv.Cd_MIS,
				Inv.FecMov, Abs(Inv.Cant_Ing) as Cant_Ing, Abs(Inv.Cant) as Cant, Abs(Inv.CosUnt) as CosUnt, Abs(Inv.Total) as Total, Inv.Cd_Gr,
				Inv.CA01, Inv.CA02, Inv.CA03, Inv.CA04, Inv.CA05, Inv.Cd_Vta, Inv.Cd_OP, Inv.Cd_Com, Inv.Cd_OC, Inv.Cd_SR, Inv.Cd_OF, Inv.UsuCrea from
				' +@Inter+' where 
				'+@Cond + ' order by Inv.Cd_Inv '
				--print @Consulta
	if not exists (select top 1 * from Inventario where RucE=@RucE)
		set @msj = 'No existe movimientos de inventario.'
	else
	--select top 1 * from Producto2
	  begin
		Exec (@Consulta)
		print @Consulta
		if(@Ult_CdInv is null) -- si es primera pagina y primera busqueda
		  begin
		    set @sql = 'select @Regs = count(*) from ' +@Inter+ ' where '+@Cond
		    exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		    set @NroPags = @NroRegs/@TamPag + case when @NroRegs%@TamPag=0 then 0 else 1 end
		    --print @sql
		  end
		  set @sql = 'select @RMax = max(Cd_Inv) from(select top '+ Convert(nvarchar,@TamPag)+' Cd_Inv  from ' + @Inter + ' where ' + @Cond +' order by Cd_Inv) as  Inventario'
		  exec sp_executesql @sql, N'@RMax char(12) output',@Max output

		  set @sql = 'select top 1 @RMin = Cd_Inv from ' + @Inter + ' where ' +@Cond+' order by Cd_Inv'
		  exec sp_executesql @sql, N'@RMin char(12) output', @Min output
	end
-- Leyenda --
-- CAM : 03/02/2011 	: <Creacion del procedimiento almacenado>
-- CAM : 15/02/2011	: <Modificacion del SP><Se agrego la columna UsuCrea>
-- CAM : 16/02/2011	: <Agregue todos los campos para los filtros y busquedas pero es igual que antes>
-- CAM : 03/03/2011	: <Se quito el formato Convert a FecMov para que muestre la hora> 
-- MP  : 24/03/2011	: <Se corrigio el filtro>
-- CAM : 25/03/2011	: <Se agrego el campo para el filtro OF - Linea 80>
-- CAM : 05/12/2011	: <Se agrego el campo para el filtro CodCom>

--


--exec Inv_InventarioCONS_Prod_explo_PagSig_1 '20522276236','01/10/2011','01/12/2011',null,null,50,null,null,null,null,null,null
--exec Com_Compra_Explo_PagSig '20504743561','','',null,null,50,'',null,null,null,null,null

--exec Inv_InventarioCONS_Prod_explo_PagSig_1 '20522276236','','',null,null,50,null,null,null,null,null,null
GO
