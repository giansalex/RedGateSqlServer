SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_GuiaRemisionCons_explo_PagAnt3]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --TamaÃƒÂ±o Pagina
@Ult_CdGR char(10),
@Max char(10) output,
@Min char(10) output,
@IC_ES char(1),
----------------------
@msj varchar(100) output
as
	declare @Inter varchar(1000)
	set @Inter = 'GuiaRemision as GR
		left join TipoOperacion as [TO] on GR.Cd_TO = [TO].Cd_TO
		left join Cliente2 c2 on c2.RucE=GR.RucE and c2.Cd_Clt=GR.Cd_Clt
		left join Proveedor2 p2 on p2.RucE=GR.RucE and p2.Cd_Prv=GR.Cd_Prv
		left join Transportista as T on T.RucE = GR.RucE and T.Cd_Tra =GR.Cd_Tra
		left join Area as A on A.RucE = GR.RucE and A.Cd_Area = GR.Cd_Area'
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = 'GR.RucE= '''+@RucE+''' and GR.IC_ES= '''+@IC_ES+''' and GR.FecEmi between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and GR.Cd_GR<'''+isnull(@Ult_CdGR,'')+''' '
	if(@Colum = 'NroSreGR') set @Cond = @Cond+ ' and GR.NroSre+'' - ''+GR.NroGR like '''+@Dato+''''
	else if(@Colum = 'FecEmi') set @Cond = @Cond+ ' and Convert(nvarchar,GR.FecEmi,103) like '''+@Dato+''''
	else if(@Colum = 'FecIniTras') set @Cond =@Cond+ ' and Convert(nvarchar,GR.FecIniTras,103) like '''+@Dato+''''
	else if(@Colum = 'FecFinTras') set @Cond = @Cond+' and Convert(nvarchar,GR.FecFinTras,103) like '''+@Dato+''''
	else if(@Colum = 'PtoPartida') set @Cond = @Cond+' and GR.PtoPartida like '''+@Dato+''''
	else if(@Colum = 'NCortoTO') set @Cond = @Cond+' and [TO].NCorto like '''+@Dato+''''
	else if(@Colum = 'Cd_TDITra') set @Cond = @Cond+' and T.Cd_TDI like '''+@Dato+''''
	else if(@Colum = 'NDocTra') set @Cond = @Cond+' and T.Ndoc like '''+@Dato+''''
	else if(@Colum = 'NomTra') set @Cond = @Cond+' and GR.DescripTra like '''+@Dato+''' or isnull(T.ApPat,'''')+'' ''+isnull(T.ApMat,'''')+'', ''+isnull(T.Nom,'''') like '+''''+@Dato+''''
	else if(@Colum = 'PesoTotalKg') set @Cond = @Cond+' and GR.PesoTotalKg like '''+@Dato+''''
	else if(@Colum = 'AutorizadoPor') set @Cond = @Cond+' and GR.AutorizadoPor like '''+@Dato+''''
	else if(@Colum = 'NCortoArea') set @Cond =@Cond+ ' and A.NCorto like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond = @Cond+' and Convert(nvarchar,GR.FecReg,103) like'''+@Dato+''''
	else if(@Colum = 'FecMdf') set @Cond = @Cond+' and Convert(nvarchar,GR.FecMdf,103) like '''+@Dato+''''
	else if(@Colum = 'UsuCrea') set @Cond = @Cond+' and GR.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'UsuMdf') set @Cond = @Cond+' and GR.UsuMdf like '''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond = @Cond+' and GR.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond = @Cond+' and GR.Cd_SC like '''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond = @Cond+' and GR.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'Cd_Clt') set @Cond=@Cond +' and GR.Cd_Clt like '''+@Dato+''''
	else if(@Colum = 'Cliente') set @Cond=@Cond +' and case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'''')+'' ''+isnull(c2.ApMat,'''')+'', ''+isnull(c2.Nom,'''') else c2.RSocial end like '''+@Dato+''''
	else if(@Colum = 'Cd_Prv') set @Cond=@Cond +' and GR.Cd_Prv like '''+@Dato+''''
	else if(@Colum = 'Proveedor') set @Cond = @Cond+' and case(isnull(len(p2.RSocial),0)) when 0 then isnull(p2.ApPat,'''') + '' '' + isnull(p2.ApMat,'''') + '', '' + isnull(p2.Nom,'''') else p2.RSocial end like '''+@Dato+''''


	declare @Consulta nvarchar(4000)
	set @Consulta = '	select * from (select top '+Convert(nvarchar,@TamPag)+'
			GR.Cd_GR,
			GR.NroSre+'' - ''+GR.NroGR as NroSreGR,
			Case(GR.IC_ES) when ''S'' then ''Salida'' else ''Entrada'' end as IC_ES,
			Convert(nvarchar,GR.FecEmi,103) as FecEmi,
			Convert(nvarchar,GR.FecIniTras,103) as FecIniTras,
			Convert(nvarchar,GR.FecFinTras,103) as FecFinTras,
			GR.PtoPartida,
			[TO].NCorto as NCortoTO,
			T.Cd_TDI as Cd_TDITra,
			T.Ndoc as NDocTra,
			case 
				when GR.Cd_Tra is null then GR.DescripTra 
				else isnull(T.RSocial, isnull(T.ApPat,'''')+'' ''+isnull(T.ApMat,'''')+'', ''+isnull(T.Nom,'''')) end as NomTra,
			GR.PesoTotalKg,
			GR.AutorizadoPor,
			A.NCorto as NCortoArea,
			Convert(nvarchar,GR.FecReg,103) as FecReg,
			Convert(nvarchar,GR.FecMdf,103) as FecMdf,
			GR.UsuCrea,
			GR.UsuMdf,
			isnull(GR.IB_Anulado,0) as GR_IBAnulado,
			GR.Cd_CC,
			GR.Cd_SC,
			GR.Cd_SS,
			
			case 
                        when GR.Cd_Clt is null and GR.Cd_Prv is null
                             then isnull(GR.Cd_Clt,''varios'')
                             else( case when GR.Cd_Clt is null then ''-'' else GR.Cd_Clt  end ) end as Cd_Clt,                  
                  case
						when c2.RSocial is null and c2.ApMat is null and c2.ApMat is null and c2.Nom is null 
						and  p2.RSocial is null and p2.ApMat is null and p2.ApMat is null and p2.Nom is null 
							 then isnull((case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'''')+'' ''+isnull(c2.ApMat,'''')+''varios''+isnull(c2.Nom,'''') else c2.RSocial end),''varios'')
							 else (case when c2.RSocial is null and c2.ApMat is null and c2.ApMat is null and c2.Nom is null
									then  isnull((case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'''')+'' ''+isnull(c2.ApMat,'''')+''- ''+isnull(c2.Nom,'''') else c2.RSocial end),''-'')
									else c2.RSocial end 
								  )end as Cliente,  
			
			--isnull(GR.Cd_Clt,''Varios'') as Cd_Clt,
			--isnull((case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'''')+'' ''+isnull(c2.ApMat,'''')+'', ''+isnull(c2.Nom,'''') else c2.RSocial end),''Varios'') as Cliente,
			isnull(GR.Cd_Prv,''Varios'') as Cd_Prv,
			isnull((case(isnull(len(p2.RSocial),0)) when 0 then isnull(p2.ApPat,'''')+'' ''+isnull(p2.ApMat,'''')+'', ''+isnull(p2.Nom,'''') else p2.RSocial end),''Varios'') as Proveedor,
			GR.CA01,GR.CA02,GR.CA03,GR.CA04,GR.CA05,GR.CA06,GR.CA07,GR.CA08,GR.CA09,GR.CA10
		from '+@Inter+'
		where ' + @Cond+' order by GR.Cd_GR desc) as GuiaRemision order by Cd_GR'
		

	set @sql = 'select top 1 @RMax =Cd_GR from '+@Inter+' where  '+@Cond+' order by Cd_GR desc'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output

	set @sql = 'select @RMin = min(Cd_GR) from(select top '+Convert(nvarchar,@TamPag)+' Cd_GR from '+@Inter+' where  '+@Cond+' order by Cd_GR desc) as GuiaRemision'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output

Exec (@Consulta)
-- Leyenda --
-- PP : 2010-05-14 11:57:48.633	: <Creacion del procedimiento almacenado>
-- MP : 2011-01-07 : <Modificacion del procedimiento almacenado>




GO
