SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- CAM 12/06/2012 no se usara paginacion
CREATE procedure [dbo].[Com_SolicitudComCons_explo_PagAnt_Web] --<Explorador de Solicitud de Compras>
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
@TamPag int, --Tamanio Pagina
@Ult_CdSC char(10),
@Max char(10) output,
@Min char(10) output,
@esParaOC bit,
@msj varchar(100) output
as
	declare @Inter varchar(2000)
	set @Inter = '
		SCxProv sp
			--Inner Join SCxProvDet sd On sd.RucE=sp.RucE and sd.Cd_SCoEnv=sp.Cd_SCoEnv and isnull(sd.IB_Acp,''0'')=1
			left join SolicitudCom sc On sc.RucE=sp.RucE and sc.Cd_SCo=sp.Cd_SCo
			left join EstadoSC s on s.Id_EstSC=sc.Id_EstSC
			left join CfgAutorizacion cfg on cfg.Cd_DMA = ''SC'' and cfg.tipo = sc.tipAut and cfg.RucE = '''+@RucE+''' 
			left join EstadoSC_Srv ss on ss.Id_EstSCS = sc.Id_EstSCS
			left join Proveedor2 p on p.RucE = sp.RucE and p.Cd_Prv = sp.Cd_Prv
			left join Estado_SCResp est on sp.Id_EstSCResp = est.Id_EstSCResp
			left join FormaPC fp on fp.Cd_FPC = sp.Cd_FPC'
		
	declare @Cond varchar(2000)

	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = 'sc.RucE= '''+@RucE+ ''' and sc.Cd_SCo<='''+isnull(@Ult_CdSC,'')+''' '
	end
	else
	begin
		      set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+
 		     Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		     ''' and sc.Cd_SCo<='''+isnull(@Ult_CdSC,'')+''' '
	end
	if(@esParaOC = 1) set @Cond = @Cond + ' and sc.Id_EstSC in (''02'',''03'',''04'',''08'',''11'') and isnull(sp.IB_Acp,''0'')=0'
			

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
	else if(@Colum = 'DescripS')
		Set @Cond = @Cond+' and ss.Descrip like '+'''%'+@Dato+'%'''

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
	--	     ''' and sc.Cd_SCo<'''+isnull(@Ult_CdSC,'')+''' '
	print 'aca4'
	Declare @CONSULTA varchar(4000)
	Set @CONSULTA='	select *from (select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SCo,sp.Cd_SCoEnv,sc.NroSC+'' -''+Convert(varchar,row_number() over (order by sc.Cd_SCo)) As NroSC,
			Convert(nvarchar(10),sc.FecEmi,103) as FecEmi,Convert(nvarchar(10),sc.FecEntR,103) as FecEntR,
			sc.Cd_FPC, sc.Cd_SR, sc.Asunto,sc.Cd_Area,sc.Obs,sc.ElaboradoPor,sc.AutorizadoPor,sc.FecReg,
			sc.FecMdf,sc.UsuCrea,sc.UsuMdf,sc.Id_EstSC,sc.Cd_CC,sc.Cd_SC,sc.Cd_SS,isnull(sc.tipAut, 0) as TipAut, isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip, case sc.IB_Aut when 1 then convert(bit,1) else convert(bit,0) end as IB_Aut, 
			s.Descrip, ss.Descrip as DescripS,
			p.Cd_Prv, p.NDoc as NroDocProv, 
			est.Descrip as DescripEstado,
			fp.Cd_FPC, fp.Nombre as NombreFPC, sp.DiasPago,sp.Id_EstSCResp,
			case(isnull(len(p.RSocial),0)) when 0 then p.ApPat + '' '' + p.ApMat + '', '' + p.Nom else p.RSocial end as RSocial
			from '+@Inter+'
			where '+@Cond+' order by sc.Cd_SCo desc) as Solicitud order by Cd_SCo,Cd_SCoEnv'
	Print @CONSULTA
	Exec (@CONSULTA)
	print 'aca5'


		--Declare @sql nvarchar(1000)
		--set @sql = 'select top 1 @RMax =sc.Cd_SCo from '+@Inter+' where  '+@Cond+' order by sc.Cd_SCo desc'
		--exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	--print @sql
	--print @max
		--set @sql = 'select @RMin = min(Cd_SCo) from(select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SCo from '+@Inter+' 
		--	    where  '+@Cond+' order by sc.Cd_SCo desc) as SolicitudCompra'
		--exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	--print @sql
	--print @min



--	LEYENDA
--	DI : <01/06/12 : Se creo referente al SP anterior y se agrego condicion para filtrar>


GO
