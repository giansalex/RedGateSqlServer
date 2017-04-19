SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionCons_explo_PagSig1]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --TamaÃƒÂ±o Pagina
@Ult_CdGR char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,
@IC_ES char(1),
----------------------
@msj varchar(100) output
as
	--select * from GuiaRemision where RucE = '11111111111'
	declare @Inter varchar(1000)
	set @Inter = 'GuiaRemision as GR
		left join TipoOperacion as [TO] on GR.Cd_TO = [TO].Cd_TO
		left join Transportista as T on T.RucE = GR.RucE and T.Cd_Tra =GR.Cd_Tra
		left join Area as A on A.RucE = GR.RucE and A.Cd_Area = GR.Cd_Area'
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)

	set @Cond = 'GR.RucE= '''+@RucE+''' and GR.IC_ES= '''+@IC_ES+''' and GR.FecEmi between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and GR.Cd_GR>'''+isnull(@Ult_CdGR,'')+''''
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

	declare @Consulta nvarchar(4000)
	set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+'
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
			GR.Cd_SS
		from '+@Inter+'
		where '+ @Cond+' order by GR.Cd_GR'

	Exec (@Consulta)

	if(@Ult_CdGR is null) -- si es primera pagina y primera busqueda
	begin
		set @sql= 'select @Regs = count(*) from '+@Inter+ '  where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
	end
	set @sql = 'select @RMax = max(Cd_GR) from(select top '+Convert(nvarchar,@TamPag)+' Cd_GR from '+@Inter+' where '+@Cond+' order by Cd_GR) as GuiaRemision'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output

	set @sql = 'select top 1 @RMin =Cd_GR from '+@Inter+' where '+@Cond+' order by Cd_GR'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output
		
-- Leyenda --
-- PP : 2010-05-13 13:18:50.823	: <Creacion del procedimiento almacenado>
-- MP : 2011-01-07 : <Modificacion del procedimiento almacenado>



GO
