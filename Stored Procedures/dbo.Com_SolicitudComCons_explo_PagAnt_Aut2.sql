SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComCons_explo_PagAnt_Aut2]
@RucE nvarchar(11),
--@Ejer nvarchar(4),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@Usuario varchar(10),
----------------------
@TamPag int, --Tamanio Pagina
@Ult_CdSC char(10),
@Max char(10) output,
@Min char(10) output,
@msj varchar(100) output
as
	declare @Inter varchar(2500)
	set @Inter = 'SolicitudCom sc
		left join FormaPC f on f.Cd_FPC=sc.Cd_FPC
		left join Area a on a.RucE=sc.RucE and a.Cd_Area=sc.Cd_Area
		left join EstadoSC s on s.Id_EstSC=sc.Id_EstSC
		left join CfgAutorizacion cfg on cfg.Cd_DMA = ''SC'' and cfg.tipo = sc.tipAut and cfg.RucE = '''+@RucE+''' 
		join(
			select DOC as ''Cd_SCAut'' from(
			select sc.cd_SCo as ''DOC'',
			case (niv) when 1 then (case (dbo.verificarAutNvl('''+@RucE+''', sc.cd_sco, 1, ib_autcomniv, 2)) when 1 then ''NO'' else ''SI'' end) 
			else ( case (dbo.verificarAutNvl('''+@RucE+''', sc.cd_sco, niv, ib_autcomniv, 2)) when 1 then ''NO''
			else (case (dbo.verificarAutNvl('''+@RucE+''', sc.cd_sco, niv-1, ib_autcomniv, 2)) when 1 then ''SI'' else ''NO'' end) end) end
			as ''Autoriza''
			from solicitudCom sc 
			join CfgAutorizacion ca on sc.RucE = ca.RucE and ca.Cd_DMA = ''SC'' and ca.Tipo = sc.TipAut 
			join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
			join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
			left join autsc asco on sc.RucE = asco.RucE and asco.CD_SCo = sc.Cd_SCo and cau.nomusu = asco.nomusu 
			where sc.RucE = '''+@RucE+''' and (IB_Aut is null or IB_Aut = 0) and TipAut !=0
			and cau.nomusu = '''+@Usuario+''' and asco.nomusu is null
			
			) as tabla 
			where Autoriza = ''SI''
		) SolComAut on sc.Cd_Sco = SolComAut.Cd_SCAut and sc.RucE = '''+@RucE+''''
	
	declare @Cond varchar(2000)

	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = 'sc.RucE= '''+@RucE+ ''' and sc.Cd_SCo<'''+isnull(@Ult_CdSC,'')+''' '
	end
	else
	begin
	      set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi <= '''+Convert(nvarchar,@FecH,103)+''' and sc.Cd_SCo<'''+isnull(@Ult_CdSC,'')+''' '
/*
		      set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+
 		     Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		     ''' and sc.Cd_SCo<'''+isnull(@Ult_CdSC,'')+''' '
*/
	end

	print 'aca2'

	if(@Colum = 'Cd_SCo') 
		Set @Cond =@Cond+' and sc.Cd_SCo like '+'''%'+@Dato+'%'''
	else if(@Colum = 'NroSC') 
		Set @Cond =@Cond+' and sc.NroSC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEmi') 
		Set @Cond =@Cond+' and Convert(nvarchar,sc.FecEmi,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEntR') 
		Set @Cond =@Cond+' and Convert(nvarchar,sc.FecEntR,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_FPC') 
		Set @Cond =@Cond+' and sc.Cd_FPC like '+'%'+@Dato+'%'
	else if(@Colum = 'Asunto') 
		Set @Cond =@Cond+' and sc.Asunto like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_Area') 
		Set @Cond =@Cond+' and sc.Cd_Area like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Obs') 
		Set @Cond =@Cond+' and sc.Obs like '+'''%'+@Dato+'%'''
	else if(@Colum = 'ElaboradoPor') 
		Set @Cond =@Cond+' and sc.ElaboradoPor like '+'''%'+@Dato+'%'''
	else if(@Colum = 'AutorizadoPor') 
		Set @Cond =@Cond+' and sc.AutorizadoPor like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecReg') 
		Set @Cond =@Cond+' and sc.FecReg like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecMdf') 
		Set @Cond =@Cond+' and sc.FecMdf like '+'''%'+@Dato+'%'''
	else if(@Colum = 'UsuCrea') 
		Set @Cond =@Cond+' and sc.UsuCrea like '+'''%'+@Dato+'%'''
	else if(@Colum = 'UsuMdf') 
		Set @Cond =@Cond+' and sc.UsuMdf like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Id_EstSC') 
		Set @Cond =@Cond+' and sc.Id_EstSC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_CC') 
		Set @Cond = @Cond+' and sc.Cd_CC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SC') 
		Set @Cond = @Cond+' and sc.Cd_SC like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SS') 
		Set @Cond = @Cond+' and sc.Cd_SS like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Cd_SR')
		Set @Cond = @Cond+' and sc.Cd_SR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'IB_Aut')
		Set @Cond = @Cond+' and sc.IB_Aut like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Descrip')
		Set @Cond = @Cond+' and s.Descrip like '+'''%'+@Dato+'%'''


	print 'aca3'
print 'Cadena = '+@Cond

	/*Declare @TamPag int
	set @TamPag =100

	Declare @FecD nvarchar(02)
	set @FecD = '01'	

	Declare @FecH nvarchar(02)
	set @FecH = '05'

	Declare @RucE nvarchar(11)
	set @RucE = '11111111111'	

	Declare @Ult_CdSC nvarchar(10)
	set @Ult_CdSC = ''

	declare @Inter varchar(1000)
	set @Inter = 'SolicitudCom sc
		left join FormaPC f on f.Cd_FPC=sc.Cd_FPC
		left join Area a on a.RucE=sc.RucE and a.Cd_Area=sc.Cd_Area
		left join EstadoSC s on s.Id_EstSC=sc.Id_EstSC'

	declare @Cond varchar(1000)*/

	--set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		--     ''' and sc.Cd_SCo<'''+isnull(@Ult_CdSC,'')+''' '
	print 'aca4'

	Declare @CONSULTA nvarchar(2000)
	Set @CONSULTA='	select *from (select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SCo,sc.NroSC,
			Convert(nvarchar(10),sc.FecEmi,103) as FecEmi,Convert(nvarchar(10),sc.FecEntR,103) as FecEntR,
			sc.Cd_FPC, sc.Cd_SR, sc.Asunto,sc.Cd_Area,sc.Obs,sc.ElaboradoPor,sc.AutorizadoPor,sc.FecReg,
			sc.FecMdf,sc.UsuCrea,sc.UsuMdf,sc.Id_EstSC,sc.Cd_CC,sc.Cd_SC,sc.Cd_SS,isnull(sc.tipAut, 0) as TipAut, isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip, case sc.IB_Aut when 1 then 1 else 0 end as IB_Aut, 
			s.Descrip
			from '+@Inter+'
			where '+@Cond+' order by sc.Cd_SCo desc) as Solicitud order by Cd_SCo'
	Print @CONSULTA
	Exec (@CONSULTA)
	print 'aca5'


		Declare @sql nvarchar(2000)
		set @sql = 'select top 1 @RMax =Cd_SCo from '+@Inter+' where  '+@Cond+' order by Cd_SCo desc'
		exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	print @sql
	print @max
		set @sql = 'select @RMin = min(Cd_SCo) from(select top '+Convert(nvarchar,@TamPag)+' Cd_SCo from '+@Inter+' 
			    where  '+@Cond+' order by Cd_SCo desc) as SolicitudCompra'
		exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	print @sql
	print @min






GO
