SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComCons_explo_PagSig_Aut]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@Usuario varchar(10),
@TamPag int, --TamaÃƒÂ±o Pagina
@Ult_CdSC char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,
----------------------
@msj varchar(100) output
as

	declare @Inter varchar(2000)
	set @Inter = 'SolicitudCom sc
		left join FormaPC f on f.Cd_FPC=sc.Cd_FPC
		left join Area a on a.RucE=sc.RucE and a.Cd_Area=sc.Cd_Area
		left join EstadoSC s on s.Id_EstSC=sc.Id_EstSC
		left join CfgAutorizacion cfg on cfg.Cd_DMA = ''SC'' and cfg.tipo = sc.tipAut and cfg.RucE = '''+@RucE+''' 
		join(
		select cd_doc as ''Cd_SCAut'' from(
		select ac.cd_dma, isnull(sco.cd_sco,'''')as CD_DOC, isnull(ascom.cd_sco, '''') as CD_DOC_AUT
		from cfgautsxusuario cau
		join cfgnivelaut cn on nomusu = '''+@usuario+''' and cn.id_niv = cau.id_niv
		join cfgautorizacion ac on ac.RucE = '''+@RucE+''' and ac.id_aut = cn.id_aut
		left join solicitudcom sco on sco.RucE = '''+@RucE+''' and ac.cd_dma = ''SC'' and sco.tipaut = ac.tipo and (sco.ib_aut = 0 or sco.ib_aut is null)
		left join autsc ascom on ascom.RucE = '''+@RucE+''' and ascom.NomUsu = '''+@usuario+''' and sco.cd_sco = ascom.cd_sco
		where sco.cd_sco is not null 
		) SCAut 
		where cd_doc != cd_doc_aut
		) SolComAut on sc.Cd_Sco = SolComAut.Cd_SCAut and sc.RucE = '''+@RucE+''''
	--print 'aca1'
	declare @sql nvarchar(2000)

	declare @Cond varchar(2000)

	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = 'sc.RucE= '''+@RucE+ ''' and sc.Cd_SCo>'''+isnull(@Ult_CdSC,'')+''' '
	end
	else
	begin
	      set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi <= '''+Convert(nvarchar(10),@FecH,103)+''' and sc.Cd_SCo>'''+isnull(@Ult_CdSC,'')+''' '
/*
		      set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+
 		     Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		     ''' and sc.Cd_SCo>'''+isnull(@Ult_CdSC,'')+''' '
*/
	end


	print @Cond
	if(@Colum = 'Cd_SCo') 
		Set @Cond = @Cond+' and sc.Cd_SCo like '+'''%'+@Dato+'%'''
	else if(@Colum = 'NroSC') 
		Set @Cond = @Cond+' and sc.NroSC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEmi') 
		Set @Cond = @Cond+' and Convert(nvarchar,sc.FecEmi,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEntR') 
		Set @Cond = @Cond+' and Convert(nvarchar,sc.FecEntR,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_FPC') 
		Set @Cond = @Cond+' and sc.Cd_FPC like '+'%'+@Dato+'%'
	else if(@Colum = 'Asunto') 
		Set @Cond = @Cond+' and sc.Asunto like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_Area') 
		Set @Cond = @Cond+' and sc.Cd_Area like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Obs') 
		Set @Cond = @Cond+' and sc.Obs like '+'''%'+@Dato+'%'''
	else if(@Colum = 'ElaboradoPor') 
		Set @Cond = @Cond+' and sc.ElaboradoPor like '+'''%'+@Dato+'%'''
	else if(@Colum = 'AutorizadoPor') 
		Set @Cond = @Cond+' and sc.AutorizadoPor like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecReg') 
		Set @Cond = @Cond+' and sc.FecReg like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecMdf') 
		Set @Cond = @Cond+' and sc.FecMdf like '+'''%'+@Dato+'%'''
	else if(@Colum = 'UsuCrea') 
		Set @Cond = @Cond+' and sc.UsuCrea like '+'''%'+@Dato+'%'''
	else if(@Colum = 'UsuMdf') 
		Set @Cond = @Cond+' and sc.UsuMdf like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Id_EstSC') 
		Set @Cond = @Cond+' and sc.Id_EstSC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_CC') 
		Set @Cond = @Cond+' and sc.Cd_CC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SC') 
		Set @Cond = @Cond+' and sc.Cd_SC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SS') 
		Set @Cond = @Cond+' and sc.Cd_SS like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SR')
		Set @Cond = @Cond+' and sc.Cd_SR like '+''''+@Dato+''''
	else if(@Colum = 'IB_Aut')
		Set @Cond = @Cond+' and sc.IB_Aut like '+''''+@Dato+''''
	else if(@Colum = 'Descrip')
		Set @Cond = @Cond+' and s.Descrip like '+''''+@Dato+''''

	--print 'aca3'
--print 'Cadena = '+@Cond

	/*set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
     ''' and sc.Cd_SCo>'''+isnull(@Ult_CdSC,'')+''' '*/

	Declare @CONSULTA nvarchar(2000)
	Set @CONSULTA='	select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SCo,sc.NroSC,
			Convert(nvarchar(10),sc.FecEmi,103) as FecEmi,Convert(nvarchar(10),sc.FecEntR,103) as FecEntR,
			sc.Cd_FPC,sc.Cd_SR,sc.Asunto,sc.Cd_Area,sc.Obs,sc.ElaboradoPor,sc.AutorizadoPor,sc.FecReg,
			sc.FecMdf,sc.UsuCrea,sc.UsuMdf,sc.Id_EstSC,sc.Cd_CC,sc.Cd_SC,sc.Cd_SS, isnull(sc.tipAut, 0) as TipAut, isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip, isnull(sc.IB_Aut, Convert(bit,0)) as IB_Aut, 		
			s.Descrip 
			from '+@Inter+'
			where '+@Cond+' order by sc.Cd_SCo'
	exec (@CONSULTA)
	Print @CONSULTA

	if(@Ult_CdSC='' or @Ult_CdSC is null) -- si es primera pagina y primera busqueda
	begin
		/*set @sql= 'select @Regs = count(Cd_SCo) from '+@Inter+ '  where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end*/
		
--		declare @sql nvarchar(1000)
		set @sql= 'select @Regs = count(Cd_SCo) from '+@Inter+ '  where ' + @Cond
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
	set @sql = 'select @RMax = max(Cd_SCo) from(select top '+Convert(nvarchar,@TamPag)+' Cd_SCo from '+@Inter+' where '+@Cond+' order by Cd_SCo) as SolicitudCom'
	exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output

	print 'esecuele 1 : '+@sql
	print @Max
	
	set @sql = 'select top 1 @RMin =Cd_SCo from '+@Inter+' where '+@Cond+' order by Cd_SCo/*ApPat, ApMat,RSocial*/'
	exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output	
	
	print 'esecuele 2 : ' +@sql
	print @Min


GO
