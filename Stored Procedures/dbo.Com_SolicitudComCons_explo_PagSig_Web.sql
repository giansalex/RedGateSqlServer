SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComCons_explo_PagSig_Web]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@TamPag int,
@Ult_CdSC char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,
@esParaOC bit,
----------------------
@msj varchar(100) output
as

	declare @Inter varchar(1000)
	set @Inter = '
		SCxProv sp
			--inner Join SCxProvDet sd On sd.RucE=sp.RucE and sd.Cd_SCoEnv=sp.Cd_SCoEnv and isnull(sd.IB_Acp,''0'')=1
			left join SolicitudCom sc On sc.RucE=sp.RucE and sc.Cd_SCo=sp.Cd_SCo
			left join EstadoSC s on s.Id_EstSC=sc.Id_EstSC
			left join CfgAutorizacion cfg on cfg.Cd_DMA = ''SC'' and cfg.tipo = sc.tipAut and cfg.RucE = '''+@RucE+''' 
			left join EstadoSC_Srv ss on ss.Id_EstSCS = sc.Id_EstSCS
			left join Proveedor2 p on p.RucE = sp.RucE and p.Cd_Prv = sp.Cd_Prv
			left join Estado_SCResp est on sp.Id_EstSCResp = est.Id_EstSCResp
			left join FormaPC fp on fp.Cd_FPC = sp.Cd_FPC'
	declare @sql nvarchar(1000)

	declare @Cond varchar(1000)

	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = 'sc.RucE= '''+@RucE+ ''' and sc.Cd_SCo>'''+isnull(@Ult_CdSC,'')+''''
	end
	else
	begin
		      set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+
 		     Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		     ''' and sc.Cd_SCo>'''+isnull(@Ult_CdSC,'')+''''
	end
	
	if(@esParaOC = 1) set @Cond = @Cond + ' and sc.Id_EstSC in (''02'',''03'',''04'',''08'',''11'') and isnull(sp.IB_Acp,''0'')=0'
	--select * from EstadoSC
	--select * from EstadoSC_Srv
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
		Set @Cond = @Cond+' and sc.Cd_SR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'IB_Aut')
		Set @Cond = @Cond+' and sc.IB_Aut like '+'''%'+@Dato+'%'''
	else if(@Colum = 'Descrip')
		Set @Cond = @Cond+' and s.Descrip like '+'''%'+@Dato+'%'''	
	else if(@Colum = 'DescripS')
		Set @Cond = @Cond+' and ss.Descrip like '+'''%'+@Dato+'%'''

	--print 'aca3'
--print 'Cadena = '+@Cond

	/*set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
     ''' and sc.Cd_SCo>'''+isnull(@Ult_CdSC,'')+''' '*/

	Declare @CONSULTA varchar(4000)
	Set @CONSULTA='	select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SCo,sp.Cd_SCoEnv,sc.NroSC/*+'' -''+Convert(varchar,row_number() over (order by sc.Cd_SCo))*/ As NroSC,
			Convert(nvarchar(10),sc.FecEmi,103) as FecEmi,Convert(nvarchar(10),sc.FecEntR,103) as FecEntR,
			sp.Cd_FPC,sc.Cd_SR,sc.Asunto,sc.Cd_Area,sc.Obs,sc.ElaboradoPor,sc.AutorizadoPor,sc.FecReg,
			sc.FecMdf,sc.UsuCrea,sc.UsuMdf,sc.Id_EstSC,sc.Cd_CC,sc.Cd_SC,sc.Cd_SS, isnull(sc.tipAut, 0) as TipAut, isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip, case sc.IB_Aut when 1 then convert(bit,1) else convert(bit,0) end as IB_Aut, 		
			s.Descrip, ss.Descrip as DescripS ,
			p.Cd_TDI, p.Cd_Prv, p.NDoc as NroDocProv, 
			est.Descrip as DescripEstado,
			fp.Cd_FPC, fp.Nombre as NombreFPC, sp.DiasPago,sp.Id_EstSCResp,
			case(isnull(len(p.RSocial),0)) when 0 then p.ApPat + '' '' + p.ApMat + '', '' + p.Nom else p.RSocial end as RSocial
			from '+@Inter+'
			where '+@Cond+' order by sc.Cd_SCo,Cd_SCoEnv'
	exec (@CONSULTA)
	Print @CONSULTA

	if(@Ult_CdSC='' or @Ult_CdSC is null) -- si es primera pagina y primera busqueda
	begin
		set @sql= 'select @Regs = count(sc.Cd_SCo) from '+@Inter+ '  where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end

		print 'sql1 ->' + @sql
		print @NroRegs
		print @NroPags
		
	end

	--set @sql = 'select @RMax = max(Cd_SCo) from(select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SCo from '+@Inter+' where '+@Cond+' order by Cd_SCo) as SolicitudCom'
	--exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output

	--print 'esecuele 1 : '+@sql
	--print @Max
	
	--set @sql = 'select top 1 @RMin =sc.Cd_SCo from '+@Inter+' where '+@Cond+' order by sc.Cd_SCo/*ApPat, ApMat,RSocial*/'
	--exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output	
	
	--print 'esecuele 2 : ' +@sql
	--print @Min
	
--	LEYENDA
--	DI : <01/06/12 : Se creo referente al SP anterior y se agrego condicion para filtrar>

-- exec Com_SolicitudComCons_explo_PagSig_Web '11111111111','01/12/2012','01/01/2013',null,null,50,'',null,null,null,null,null,0

GO
