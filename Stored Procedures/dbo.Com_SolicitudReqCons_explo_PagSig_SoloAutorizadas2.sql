SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Com_SolicitudReqCons_explo_PagSig_SoloAutorizadas2]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@TamPag int, --Tamano Pagina
@Ult_CdSR char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,
----------------------
@msj varchar(100) output
as

	declare @Inter varchar(1000)
	set @Inter = 'SolicitudReq2 sc
		left join Area a on a.RucE=sc.RucE and a.Cd_Area=sc.Cd_Area
		left join CfgAutorizacion cfg on cfg.Cd_DMA = ''SR'' and cfg.tipo = sc.tipAut and cfg.RucE = '''+@RucE+''' '
	declare @sql nvarchar(1000)

	declare @Cond varchar(1000)
	
	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = 'sc.RucE= '''+@RucE+ ''' and sc.Cd_SR>'''+isnull(@Ult_CdSR,'')+''' and ((isnull(sc.TipAut,0) = 0) or (isnull(sc.TipAut,0) != 0 and isnull(IB_EsAut,0) = 1))'
	end
	else
	begin
		set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+
		Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		''' and sc.Cd_SR>'''+isnull(@Ult_CdSR,'')+''' and ((isnull(sc.TipAut,0) = 0) or (isnull(sc.TipAut,0) != 0 and isnull(IB_EsAut,0) = 1))'
	end
	print @Cond
	if(@Colum = 'Cd_SR') 
		Set @Cond = @Cond+' and sc.Cd_SR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'NroSR') 
		Set @Cond = @Cond+' and sc.NroSR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEmi') 
		Set @Cond = @Cond+' and Convert(nvarchar,sc.FecEmi,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEnt') 
		Set @Cond = @Cond+' and Convert(nvarchar,sc.FecEnt,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Asunto') 
		Set @Cond = @Cond+' and sc.Asunto like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_Area') 
		Set @Cond = ' and sc.Cd_Area like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Obs') 
		Set @Cond = @Cond+' and sc.Obs like '+'''%'+@Dato+'%'''
	else if(@Colum = 'ElaboradoPor') 
		Set @Cond = @Cond+' and sc.ElaboradoPor like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecCrea') 
		Set @Cond = @Cond+' and sc.FecCrea like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecMdf') 
		Set @Cond =@Cond+ ' and sc.FecMdf like '+'''%'+@Dato+'%'''
	else if(@Colum = 'UsuCrea') 
		Set @Cond = @Cond+' and sc.UsuCrea like '+'''%'+@Dato+'%'''
	else if(@Colum = 'UsuMdf') 
		Set @Cond = @Cond+' and sc.UsuMdf like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_CC') 
		Set @Cond = @Cond+' and sc.Cd_CC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SC') 
		Set @Cond = @Cond+' and sc.Cd_SC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SS') 
		Set @Cond = @Cond+' and sc.Cd_SS like '+'''%'+@Dato+'%'''
	else if(@Colum = 'TipAut') 
		Set @Cond = @Cond+' and sc.TipAut like '+'''%'+@Dato+'%'''
	else if(@Colum = 'IB_EsAut') 
		Set @Cond = @Cond+' and sc.IB_EsAut like '+'''%'+@Dato+'%'''
	else if(@Colum = 'IB_Anulado') 
		Set @Cond = @Cond+' and sc.IB_Anulado like '+'''%'+@Dato+'%'''
	else if(@Colum = 'IB_Eliminado') 
		Set @Cond = @Cond+' and sc.IB_Eliminado like '+'''%'+@Dato+'%'''
	else if(@Colum = 'CA01') 
		Set @Cond = @Cond+' and sc.CA01 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA02') 
		Set @Cond = @Cond+' and sc.CA02 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA03') 
		Set @Cond = @Cond+' and sc.CA03 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA04') 
		Set @Cond = @Cond+' and sc.CA04 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA05') 
		Set @Cond = @Cond+' and sc.CA05 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA06') 
		Set @Cond = @Cond+' and sc.CA06 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA07') 
		Set @Cond = @Cond+' and sc.CA07 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA08') 
		Set @Cond = @Cond+' and sc.CA08 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA09') 
		Set @Cond = @Cond+' and sc.CA09 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA10') 
		Set @Cond = @Cond+' and sc.CA10 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA11') 
		Set @Cond = @Cond+' and sc.CA11 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA12') 
		Set @Cond = @Cond+' and sc.CA12 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA13') 
		Set @Cond = @Cond+' and sc.CA13 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA14') 
		Set @Cond = @Cond+' and sc.CA14 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA15') 
		Set @Cond = @Cond+' and sc.CA15 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA16') 
		Set @Cond = @Cond+' and sc.CA16 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA17') 
		Set @Cond = @Cond+' and sc.CA17 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA18') 
		Set @Cond = @Cond+' and sc.CA18 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA19') 
		Set @Cond = @Cond+' and sc.CA19 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA20') 
		Set @Cond = @Cond+' and sc.CA20 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA21') 
		Set @Cond = @Cond+' and sc.CA21 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA22') 
		Set @Cond = @Cond+' and sc.CA22 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA23') 
		Set @Cond = @Cond+' and sc.CA23 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA24') 
		Set @Cond = @Cond+' and sc.CA24 like '+'''%'+@Dato+'%'''		
	else if(@Colum = 'CA25') 
		Set @Cond = @Cond+' and sc.CA25 like '+'''%'+@Dato+'%'''		
		
	Declare @CONSULTA nvarchar(1500)
	Set @CONSULTA='	select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SR,sc.NroSR,
			Convert(nvarchar(10),sc.FecEmi,103) as FecEmi,Convert(nvarchar(10),sc.FecEnt,103) as FecEnt,
			sc.Asunto,sc.Cd_Area,sc.Obs,sc.ElaboradoPor,sc.FecCrea,
			sc.FecMdf,sc.UsuCrea,sc.UsuMdf,sc.Cd_CC,sc.Cd_SC,sc.Cd_SS,isnull(sc.tipAut, 0) as TipAut,sc.IB_EsAut,sc.IB_Anulado,sc.IB_Eliminado,sc.CA01,sc.CA02,sc.CA03,sc.CA04,sc.CA05,sc.CA06,sc.CA07,sc.CA08,sc.CA09,sc.CA10,sc.CA11,sc.CA12,sc.CA13,sc.CA14,sc.CA15,sc.CA16,sc.CA17,sc.CA18,sc.CA19,sc.CA20,sc.CA21,sc.CA22,sc.CA23,sc.CA24,sc.CA25
			from '+@Inter+'
			where '+@Cond+' order by sc.Cd_SR'
	exec (@CONSULTA)
	Print @CONSULTA

	if(@Ult_CdSR='' or @Ult_CdSR is null) -- si es primera pagina y primera busqueda
	begin
		set @sql= 'select @Regs = count(Cd_SR) from '+@Inter+ '  where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end

		print 'sql1 ->' + @sql
		print @NroRegs
		print @NroPags
		
	end
	set @sql = 'select @RMax = max(Cd_SR) from(select top '+Convert(nvarchar,@TamPag)+' Cd_SR from '+@Inter+' where '+@Cond+' order by Cd_SR) as SolicitudReq'
	exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output

	print 'esecuele 1 : '+@sql
	print @Max
	
	set @sql = 'select top 1 @RMin =Cd_SR from '+@Inter+' where '+@Cond+' order by Cd_SR/*ApPat, ApMat,RSocial*/'
	exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output	
	
	print 'esecuele 2 : ' +@sql
	print @Min
GO
