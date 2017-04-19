SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReqCons_explo_PagAnt3]
--<Explorador de Solicitud de Requerimientos>
@RucE nvarchar(11),
--@Ejer nvarchar(4),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --Tamano Pagina
@Ult_CdSR char(10),
@Max char(10) output,
@Min char(10) output,
@msj varchar(100) output
as
	declare @Inter varchar(1000)
	set @Inter = 'SolicitudReq sc
		left join Area a on a.RucE=sc.RucE and a.Cd_Area=sc.Cd_Area
		left join EstadoSR s on s.Id_EstSR=sc.Id_EstSR
		left join CfgAutorizacion cfg on cfg.Cd_DMA = ''SR'' and cfg.tipo = sc.tipAut and cfg.RucE = '''+@RucE+''' '
	print 'aca1'
	
	declare @Cond varchar(1000)
	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = 'sc.RucE= '''+@RucE+ ''' and sc.Cd_SR<'''+isnull(@Ult_CdSR,'')+''' '
	end
	else
	begin
		set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+
		Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		''' and sc.Cd_SR<'''+isnull(@Ult_CdSR,'')+''' '
	end
	print 'aca2'

	if(@Colum = 'Cd_SR') 
		Set @Cond =@Cond+' and sc.Cd_SR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'NroSR') 
		Set @Cond =@Cond+' and sc.NroSR like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEmi') 
		Set @Cond =@Cond+' and Convert(nvarchar,sc.FecEmi,103) like '+'''%'+@Dato+'%'''
	else if(@Colum = 'FecEntR') 
		Set @Cond =@Cond+' and Convert(nvarchar,sc.FecEntR,103) like '+'''%'+@Dato+'%'''
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
	else if(@Colum = 'Id_EstSR') 
		Set @Cond =@Cond+' and sc.Id_EstSR like '+'''%'+@Dato+'%'''
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
	set @Cond = 'sc.RucE= '''+@RucE+''' and sc.FecEmi between '''+Convert(nvarchar(10),@FecD,103)+''' and '''+Convert(nvarchar(10),@FecH,103)+
		     ''' and sc.Cd_SR<'''+isnull(@Ult_CdSR,'')+''' '
	print 'aca4'
	Declare @CONSULTA nvarchar(1000)
	Set @CONSULTA='	select *from (select top '+Convert(nvarchar,@TamPag)+' sc.Cd_SR,sc.NroSR,
			Convert(nvarchar(10),sc.FecEmi,103) as FecEmi,Convert(nvarchar(10),sc.FecEntR,103) as FecEntR,
			sc.Asunto,sc.Cd_Area,sc.Obs,sc.ElaboradoPor,sc.AutorizadoPor,sc.FecReg,
			sc.FecMdf,sc.UsuCrea,sc.UsuMdf,sc.Id_EstSR,sc.Cd_CC,sc.Cd_SC,sc.Cd_SS, isnull(sc.tipAut, 0) as TipAut, isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip, case sc.IB_Aut when 1 then 1 else 0 end as IB_Aut,
			s.Descrip from '+@Inter+'
			where '+@Cond+' order by sc.Cd_SR desc) as SolicitudReq5 order by Cd_SR'
	Print @CONSULTA
	Exec (@CONSULTA)
	print 'aca5'


		Declare @sql nvarchar(1000)
		set @sql = 'select top 1 @RMax =Cd_SR from '+@Inter+' where  '+@Cond+' order by Cd_SR desc'
		exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	print @sql
	print @max
		set @sql = 'select @RMin = min(Cd_SR) from(select top '+Convert(nvarchar,@TamPag)+' Cd_SR from '+@Inter+' 
			    where  '+@Cond+' order by Cd_SR desc) as SolicitudReq'
		exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	print @sql
	print @min
	
-- LEYENDA --
-- J : 09/09/2010 <Creacion del procedimiento almacenado>
-- CAM: 09/02/2011 <Actualziacion: Nueva version del SP (2) y se agrego la columna Estado>

/*
select * from SolicitudCom
----Ejemplo-----
Declare @Max char(10),@Min char(10)
exec Com_SolicitudReqCons_explo_PagAnt2 '11111111111','10/01/2010','20/08/2010','Cd_SR','SR00000001',5,'SR00000006',@Max out,@Min out,null
*/

GO
