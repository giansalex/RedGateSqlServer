SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraCons_explo_PagAnt_Aut1]

@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@Usuario varchar(10),
----------------------
@TamPag int, --TamaÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â±o Pagina
@Ult_CdOC char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,
----------------------
@msj varchar(100) output
as
	declare @Inter varchar(4000)
	set @Inter = 'OrdCompra oc inner join Proveedor2 pr
	on oc.RucE = pr.RucE  and oc.Cd_Prv = pr.Cd_Prv  inner join Moneda mo
	on oc.Cd_Mda = mo.Cd_Mda left join Usuario us1
	on oc.AutdoPorN1 = us1.NomUsu left join  Usuario us2
	on oc.AutdoPorN2 = us2.NomUsu left join  Usuario us3
	on oc.AutdoPorN3 = us3.NomUsu 
	left join EstadoOC s on s.Id_EstOC=oc.Id_EstOC
	left join CfgAutorizacion cfg on cfg.Cd_DMA = ''OC'' and cfg.tipo = oc.tipAut and cfg.RucE = '''+@RucE+''' 
	join(
	select cd_doc as ''Cd_OCAut'' from(
	select ac.cd_dma, isnull(oc.cd_oc,'''')as CD_DOC, isnull(aoc.cd_oc, '''') as CD_DOC_AUT
	from cfgautsxusuario cau
	join cfgnivelaut cn on nomusu = '''+@usuario+''' and cn.id_niv = cau.id_niv
	join cfgautorizacion ac on ac.RucE = '''+@RucE+''' and ac.id_aut = cn.id_aut
	left join ordcompra oc on oc.RucE = '''+@RucE+''' and ac.cd_dma = ''OC'' and oc.tipaut = ac.tipo and (oc.ib_aut = 0 or oc.ib_aut is null)
	left join autoc aoc on aoc.RucE = '''+@RucE+''' and aoc.NomUsu = '''+@usuario+''' and oc.cd_oc = aoc.cd_oc
	where oc.cd_oc is not null 
	) OCAut 
	where cd_doc != cd_doc_aut
	) OrdCompraAut on oc.Cd_OC = OrdCompraAut.Cd_OCAut and oc.RucE = '''+@RucE+''''
	

	declare @Cond varchar(4000)
	declare @sql nvarchar(4000)

	if(@FecD='' or @FecD is null)
	begin
		set @Cond = 'oc.RucE= '''+@RucE+''' and oc.Cd_OC <'''+isnull(@Ult_CdOC,'')+''''
	end
	else
	begin
		set @Cond = 'oc.RucE= '''+@RucE+''' and oc.FecE <= '''+Convert(nvarchar,@FecH,103)+''' and oc.Cd_OC <'''+isnull(@Ult_CdOC,'')+''''
/*
		set @Cond = 'oc.RucE= '''+@RucE+'''
		and oc.FecE between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and oc.Cd_OC <'''+isnull(@Ult_CdOC,'')+''''
*/
	end

	if(@Colum = 'Cd_OC') set @Cond = @Cond+ ' and oc.Cd_OC like '''+@Dato+''''
	else if(@Colum = 'NroOC') set @Cond = @Cond+ ' and oc.NroOC like '''+@Dato+''''
	else if(@Colum = 'Cd_Prv') set @Cond =@Cond+ ' and oc.Cd_Prv like '''+@Dato+''''
	else if(@Colum = 'Nomb') set @Cond = @Cond+' and case(isnull(len(pr.RSocial),0)) when 0 then pr.ApPat +'' ''+ pr.ApMat +'',''+ pr.Nom else pr.RSocial end  like '''+@Dato+''''
	else if(@Colum = 'FecE') set @Cond = @Cond+' and Convert(nvarchar,oc.FecE,103) like '''+@Dato+''''
	else if(@Colum = 'FecEntR') set @Cond = @Cond+' and Convert(nvarchar,oc.FecEntR,103) like '''+@Dato+''''
	else if(@Colum = 'Obs') set @Cond = @Cond+' and oc.Obs like '''+@Dato+''''
	else if(@Colum = 'Cd_SCo') set @Cond = @Cond+' and oc.Cd_SCo like '''+@Dato+''''
	else if(@Colum = 'Cd_Mda') set @Cond = @Cond+' and oc.Cd_Mda like '''+@Dato+''''
	else if(@Colum = 'Desc_Mda') set @Cond = @Cond+' and mo.Nombre like '''+@Dato+''''
	else if(@Colum = 'ValorNeto') set @Cond = @Cond+' and oc.ValorNeto like '''+@Dato+''''
	else if(@Colum = 'DsctoFnzP') set @Cond = @Cond+' and oc.DsctoFnzP like '''+@Dato+''''
	else if(@Colum = 'DsctoFnzI') set @Cond =@Cond+ ' and oc.DsctoFnzI like '''+@Dato+''''
	else if(@Colum = 'BIM') set @Cond = @Cond+' and oc.BIM like'''+@Dato+''''
	else if(@Colum = 'IGV') set @Cond = @Cond+' and oc.IGV like'''+@Dato+''''
	else if(@Colum = 'Total') set @Cond = @Cond+' and oc.Total like'''+@Dato+''''
	else if(@Colum = 'IC_NAut') set @Cond = @Cond+ ' and case(oc.IC_NAut) when ''1'' then ''Autorizacion Nivel 1'' when ''2'' then ''Autorizacion Nivel 2'' when ''3'' then ''Autorizacion Nivel 3'' else '''' end like '''+@Dato+''''
	else if(@Colum = 'N1') set @Cond = @Cond+ ' and us1.NomComp like '''+@Dato+''''
	else if(@Colum = 'N2') set @Cond = @Cond+ ' and us2.NomComp like '''+@Dato+''''
	else if(@Colum = 'N3') set @Cond = @Cond+ ' and us3.NomComp like '''+@Dato+''''
	else if(@Colum = 'IB_Aut') set @Cond = @Cond+ ' and oc.IB_Aut like '''+@Dato+''''

	declare @Consulta varchar(8000)
	set @Consulta = 'select * from (select top '+Convert(nvarchar,@TamPag)+' oc.Cd_OC, oc.NroOC,oc.Cd_Prv,
			case(isnull(len(pr.RSocial),0)) when 0 
			then pr.ApPat +'' ''+ pr.ApMat +'',''+ pr.Nom 
			else pr.RSocial end as Nomb, 
			Convert(nvarchar,oc.FecEntR,103) as FecEntR,Convert(nvarchar,oc.FecE,103) as FecE,oc.Cd_SCo,oc.Obs,oc.Cd_Mda,
			mo.Nombre as Desc_Mda,oc.ValorNeto,oc.DsctoFnzP,
			oc.DsctoFnzI,oc.BIM,oc.IGV,oc.Total ,case(oc.IC_NAut) when ''1'' then ''Autorizacion Nivel 1''
			when ''2'' then ''Autorizacion Nivel 2'' when ''3'' then ''Autorizacion Nivel 3''  else '''' end as IC_NAut
			,us1.NomComp as N1,us2.NomComp as N2,us3.NomComp as N3, 
			isnull(oc.tipAut, 0) as TipAut, isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip, case oc.IB_Aut when 1 then 1 else 0 end as IB_Aut, oc.AutorizadoPor, s.Descrip  
			from '
			+@Inter+' 
			where '+ @Cond+' order by oc.Cd_OC desc) as Venta order by Cd_OC'

	exec (@Consulta)

	print @Consulta
	--print @Cond
	--print @Inter

	set @sql = 'select top 1 @RMax =Cd_OC from '+@Inter+' where  '+@Cond+' order by Cd_OC desc'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	print @sql
	set @sql = 'select @RMin = min(Cd_OC) from(select top '+Convert(nvarchar,@TamPag)+' Cd_OC from '+@Inter+' where  '+@Cond+' order by Cd_OC desc) as OrdCompra'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	print @sql




GO
