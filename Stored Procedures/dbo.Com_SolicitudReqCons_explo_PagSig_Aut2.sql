SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReqCons_explo_PagSig_Aut2]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@Usuario varchar(10),
@TamPag int, --Tamano Pagina
@Ult_CdSR char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,
----------------------
@msj varchar(100) output
as

	declare @Inter varchar(2000)
	set @Inter = 'SolicitudReq sc
		left join Area a on a.RucE=sc.RucE and a.Cd_Area=sc.Cd_Area
		left join EstadoSR s on s.Id_EstSR=sc.Id_EstSR
		left join CfgAutorizacion cfg on cfg.Cd_DMA = ''SR'' and cfg.tipo = sc.tipAut and cfg.RucE = '''+@RucE+''' 
		join(
		select DOC as ''Cd_SRAut'' from(
		select sr.cd_SR as ''DOC'',
		case (niv) when 1 then (case (dbo.verificarAutNvl('''+@RucE+''', sr.cd_sr, 1, ib_autcomniv, 3)) when 1 then ''NO'' else ''SI'' end) 
		else ( case (dbo.verificarAutNvl('''+@RucE+''', sr.cd_sr, niv, ib_autcomniv, 3)) when 1 then ''NO'' 
		else (case (dbo.verificarAutNvl('''+@RucE+''', sr.cd_sr, niv-1, ib_autcomniv, 3)) when 1 then ''SI'' else ''NO'' end) end) end
		as ''Autoriza''
		from solicitudReq sr
		join CfgAutorizacion ca on sr.RucE = ca.RucE and ca.Cd_DMA = ''SR'' and ca.Tipo = sr.TipAut 
		join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
		join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
		left join autsr asr on sr.RucE = asr.RucE and asr.CD_SR = sr.Cd_SR and cau.nomusu = asr.nomusu 
		where sr.RucE = '''+@RucE+''' and (IB_Aut is null or IB_Aut = 0) and TipAut !=0
		and cau.nomusu = '''+@Usuario+''' and asr.nomusu is null
		
		) as tabla 
		where Autoriza = ''SI''
		) SolReqAut on sc.Cd_SR = SolReqAut.Cd_SRAut and sc.RucE = '''+@RucE+''''

	declare @sql nvarchar(2000)

	declare @Cond varchar(2000)
	
	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = 'sc.RucE= '''+@RucE+ ''' and sc.Cd_SR>'''+isnull(@Ult_CdSR,'')+''' '
	end
	else
	begin
		set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi <= '''+Convert(nvarchar(10),@FecH,103)+''' and sc.Cd_SR>'''+isnull(@Ult_CdSR,'')+''' '
/*
		set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+
		Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		''' and sc.Cd_SR>'''+isnull(@Ult_CdSR,'')+''' '
*/
	end



	print @Cond
	if(@Colum = 'Cd_SR') 
		Set @Cond = @Cond+' and sc.Cd_SR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'NroSR') 
		Set @Cond = @Cond+' and sc.NroSR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEmi') 
		Set @Cond = @Cond+' and Convert(nvarchar,sc.FecEmi,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEntR') 
		Set @Cond = @Cond+' and Convert(nvarchar,sc.FecEntR,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Asunto') 
		Set @Cond = @Cond+' and sc.Asunto like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_Area') 
		Set @Cond = ' and sc.Cd_Area like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Obs') 
		Set @Cond = @Cond+' and sc.Obs like '+'''%'+@Dato+'%'''
	else if(@Colum = 'ElaboradoPor') 
		Set @Cond = @Cond+' and sc.ElaboradoPor like '+'''%'+@Dato+'%'''
	else if(@Colum = 'AutorizadoPor') 
		Set @Cond = @Cond+' and sc.AutorizadoPor like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecReg') 
		Set @Cond = @Cond+' and sc.FecReg like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecMdf') 
		Set @Cond =@Cond+ ' and sc.FecMdf like '+'''%'+@Dato+'%'''
	else if(@Colum = 'UsuCrea') 
		Set @Cond = @Cond+' and sc.UsuCrea like '+'''%'+@Dato+'%'''
	else if(@Colum = 'UsuMdf') 
		Set @Cond = @Cond+' and sc.UsuMdf like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Id_EstSR') 
		Set @Cond = @Cond+' and sc.Id_EstSR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_CC') 
		Set @Cond = @Cond+' and sc.Cd_CC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SC') 
		Set @Cond = @Cond+' and sc.Cd_SC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SS') 
		Set @Cond = @Cond+' and sc.Cd_SS like '+'''%'+@Dato+'%'''
	else if(@Colum = 'IB_Aut') 
		Set @Cond = @Cond+' and sc.IB_Aut like '+'''%'+@Dato+'%'''
	else if(@Colum = 'DescripTip')
		Set @Cond = @Cond+' and cfg.DescripTip like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Descrip')
		Set @Cond = @Cond+' and s.Descrip like '+'''%'+@Dato+'%'''


	--print 'aca3'
--print 'Cadena = '+@Cond

	/*set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
     ''' and sc.Cd_SCo>'''+isnull(@Ult_CdSC,'')+''' '*/

	Declare @CONSULTA nvarchar(2000)
	Set @CONSULTA='	select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SR,sc.NroSR,
			Convert(nvarchar(10),sc.FecEmi,103) as FecEmi,Convert(nvarchar(10),sc.FecEntR,103) as FecEntR,
			sc.Asunto,sc.Cd_Area,sc.Obs,sc.ElaboradoPor,sc.AutorizadoPor,sc.FecReg,
			sc.FecMdf,sc.UsuCrea,sc.UsuMdf,sc.Id_EstSR,sc.Cd_CC,sc.Cd_SC,sc.Cd_SS, isnull(sc.tipAut, 0) as TipAut, isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip, case sc.IB_Aut  when 1 then 1 else 0 end as IB_Aut,
			s.Descrip from '+@Inter+'
			where '+@Cond+' order by sc.Cd_SR'
	exec (@CONSULTA)
	Print @CONSULTA

	if(@Ult_CdSR='' or @Ult_CdSR is null) -- si es primera pagina y primera busqueda
	begin
		/*set @sql= 'select @Regs = count(Cd_SCo) from '+@Inter+ '  where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end*/
		
--		declare @sql nvarchar(1000)
		set @sql= 'select @Regs = count(Cd_SR) from '+@Inter+ '  where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end

		print 'sql1 ->' + @sql
		print @NroRegs
		print @NroPags
		
	end
	/*set @sql = 'select @RMax = max(Cd_SC) from(select top '+Convert(nvarchar,@TamPag)+' Cd_SC from '+@Inter+' where '+@Cond+' order by Cd_SC) as SolicitudCom'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output
		print 'sql2 ->' + @sql
		print @Max

	set @sql = 'select top 1 @RMin =Cd_SC from '+@Inter+' where '+@Cond+' order by Cd_SC'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output
		print 'sql3 ->' + @sql
		print @Min*/
	set @sql = 'select @RMax = max(Cd_SR) from(select top '+Convert(nvarchar,@TamPag)+' Cd_SR from '+@Inter+' where '+@Cond+' order by Cd_SR) as SolicitudReq'
	exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output

	print 'esecuele 1 : '+@sql
	print @Max
	
	set @sql = 'select top 1 @RMin =Cd_SR from '+@Inter+' where '+@Cond+' order by Cd_SR/*ApPat, ApMat,RSocial*/'
	exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output	
	
	print 'esecuele 2 : ' +@sql
	print @Min


--exec Com_SolicitudReqCons_explo_PagSig_Aut2 '111111111111','01/01/2009','31/12/2011',null,null,'mmedrano',50,'',null,null,null,null,null





GO
