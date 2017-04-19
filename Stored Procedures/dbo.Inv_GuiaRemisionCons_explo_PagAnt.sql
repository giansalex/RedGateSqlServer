SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionCons_explo_PagAnt]
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
			GR.IB_Anulado as GR_IBAnulado
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
