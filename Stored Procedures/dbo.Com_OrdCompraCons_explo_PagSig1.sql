SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraCons_explo_PagSig1]

@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --TamaÃƒÆ’Ã‚Â±o Pagina
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
	on oc.AutdoPorN3 = us3.NomUsu '
	declare @Cond varchar(4000)
	declare @sql nvarchar(4000)

	if(@FecD='' or @FecD is null)
	begin
		set @Cond = 'oc.RucE= '''+@RucE+''' and oc.Cd_OC >'''+isnull(@Ult_CdOC,'')+''''
	end
	else
	begin
		set @Cond = 'oc.RucE= '''+@RucE+'''
		and oc.FecE between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and oc.Cd_OC >'''+isnull(@Ult_CdOC,'')+''''
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
	set @Consulta = 'select top '+Convert(nvarchar,@TamPag)+' oc.Cd_OC, oc.NroOC,oc.Cd_Prv,
			case(isnull(len(pr.RSocial),0)) when 0 
			then pr.ApPat +'' ''+ pr.ApMat +'',''+ pr.Nom 
			else pr.RSocial end as Nomb, 
			Convert(nvarchar,oc.FecEntR,103) as FecEntR,Convert(nvarchar,oc.FecE,103) as FecE,oc.Cd_SCo,oc.Obs,oc.Cd_Mda,
			mo.Nombre as Desc_Mda,oc.ValorNeto,oc.DsctoFnzP,oc.IB_Aut,
			oc.DsctoFnzI,oc.BIM,oc.IGV,oc.Total ,case(oc.IC_NAut) when ''1'' then ''Autorizacion Nivel 1''
			when ''2'' then ''Autorizacion Nivel 2'' when ''3'' then ''Autorizacion Nivel 3'' else '''' end as IC_NAut
			,us1.NomComp as N1,us2.NomComp as N2,us3.NomComp as N3 from '
			+@Inter+' 
			where '+ @Cond+' order by oc.Cd_OC'

	exec (@Consulta)

	print @Consulta
	--print @Cond
	--print @Inter

	
	if(@Ult_CdOC is null) -- si es primera pagina y primera busqueda
	begin
		set @sql= 'select @Regs = count(*) from '+@Inter+ '  where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
	end
	set @sql = 'select @RMax = max(Cd_OC) from(select top '+Convert(nvarchar,@TamPag)+' Cd_OC from '+@Inter+' where '+@Cond+' order by Cd_OC) as GuiaRemision'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output

	set @sql = 'select top 1 @RMin =Cd_OC from '+@Inter+' where '+@Cond+' order by Cd_OC'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output

	--exec Com_OrdCompraCons_explo_PagSig  '11111111111','01/01/2010','31/12/2010',null,null,5,null,null,null,null,null,null
-------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------Select Inicial-------------------------------------------------------
--select oc.Cd_OC, oc.NroOC,oc.Cd_Prv,case(isnull(len(pr.RSocial),0)) when 0 then pr.ApPat +' '+ pr.ApMat +','+ pr.Nom else pr.RSocial end as Nomb 
--,oc.FecEntR,oc.FecE,oc.Cd_SCo,oc.Obs,oc.Cd_Mda,mo.Nombre as Desc_Mda,oc.ValorNeto,
--oc.DsctoFnzP,oc.DsctoFnzI,oc.BIM,oc.IGV,oc.Total from OrdCompra oc, Proveedor2 pr, Moneda mo
--where oc.RucE = '11111111111' and (oc.RucE = pr.RucE  and oc.Cd_Prv = pr.Cd_Prv) and (oc.Cd_Mda = mo.Cd_Mda)
-------------------------------------------------------------------------------------------------------------------------
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>



GO
