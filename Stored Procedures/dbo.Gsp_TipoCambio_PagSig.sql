SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Gsp_TipoCambio_PagSig '11111111111',null,null,100,null,null,null,null,null,null
--exec Gsp_TipoCambio_PagSig '11111111111',null,null,100,'04/04/2007',null,null,null,null,null

CREATE procedure [dbo].[Gsp_TipoCambio_PagSig]
@RucE nvarchar(11),
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --TamaÃ±o Pagina
@Ult_FecTC varchar(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max varchar(10) output,
@Min varchar(10) output,


----------------------
@msj varchar(100) output
as

	declare @Inter varchar(1000)
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	declare @Consulta  nvarchar(4000)
	if (@Ult_FecTC is null)
			set @Ult_FecTC = '31/12/2050' --PV
			--PV ¿QUIEN PUSO ESTO? -->  set @Ult_FecTC = convert(varchar,day(Getdate()) + 1) + '/' + convert(varchar,month(Getdate()))+ '/' + convert(varchar,year(Getdate()))


	set @Inter = 'Empresa e, 
		Moneda m,
		TipCam c '
	set @Cond = 'Ruc='''+@RucE + ''' and e.Cd_MdaS=m.Cd_Mda and m.Cd_Mda=c.Cd_Mda' + 
	' and convert(datetime,c.FecTC,103) < convert(datetime,'''+@Ult_FecTC+''',103)'
	--'and year(c.FecTC) <= year(''' +isnull(@Ult_FecTC,'')+''') and month(c.FecTC) <= month('''+isnull(@Ult_FecTC,'')+''') and day(c.FecTC) < day('''+isnull(@Ult_FecTC,'')+''')'

	if(@Colum = 'FecTC') set @Cond = @Cond+ ' and c.FecTC like '''+@Dato+''''
	else if(@Colum = 'Cd_MdaS') set @Cond = @Cond+ ' and e.Cd_MdaS like '''+@Dato+''''
	else if(@Colum = 'Nombre') set @Cond = @Cond+ ' and m.Nombre like '''+@Dato+''''
	else if(@Colum = 'TCCom') set @Cond = @Cond+ ' and c.TCCom like '''+@Dato+''''
	else if(@Colum = 'TCVta') set @Cond = @Cond+ ' and c.TCVta like '''+@Dato+''''
	else if(@Colum = 'TCPro') set @Cond = @Cond+ ' and c.TCPro like '''+@Dato+''''
	
	set @Consulta =' 
		select top '+Convert(nvarchar,@TamPag)+'
		c.FecTC,
		e.Cd_MdaS,
		m.Nombre,
		c.TCCom,
		c.TCVta,
		c.TCPro
	from '+@Inter+'
	where '+@Cond+'
	order by year(convert(datetime,c.FecTC,103)) desc ,month(convert(datetime,c.FecTC,103)) desc,day(convert(datetime,c.FecTC,103)) desc'
	print @Consulta
	Exec (@Consulta)
	
	if @Ult_FecTC = '31/12/2050'--(@Ult_FecTC=convert(varchar,day(Getdate()) + 1) + '/' + convert(varchar,month(Getdate()))+ '/' + convert(varchar,year(Getdate()))) -- si es primera pagina y primera busqueda
	begin
		print 'SI ENTRO'
		set @sql= 'select @Regs = count(*) from '+@Inter+ '
			where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		print @sql
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
		print @NroPags
	end

	set @sql = 'set @RMax = (select top 1 FecTC from(select top '+Convert(nvarchar,@TamPag)+' FecTC from '+@Inter+'
		where '+@Cond+ 'order by year(convert(datetime,FecTC,103)) desc ,month(convert(datetime,FecTC,103)) desc,day(convert(datetime,FecTC,103)) desc
	            ) as TipCam)'
	

	exec sp_executesql @sql, N'@RMax varchar(10) output', @Max output
				print 'maximo : '+ @Max
	print @sql
	set @sql = 'select top 1 @RMin =FecTC from (select top '+Convert(nvarchar,@TamPag)+' FecTC from '+@Inter+'
		where '+@Cond+'
		order by year(convert(datetime,c.FecTC,103)) desc,month(convert(datetime,c.FecTC,103)) desc ,day(convert(datetime,c.FecTC,103)) desc
	            ) as TipCam order by year(convert(datetime,FecTC,103)) asc ,month(convert(datetime,FecTC,103)) asc ,day(convert(datetime,FecTC,103)) asc'
	exec sp_executesql @sql, N'@RMin varchar(10) output', @Min output
				print 'minimo : '+@Min
	print @sql


----------------------------------------------------------------------------------------------------
-- Leyenda --
-- CAM 14/10/2010 Creado.

--exec Gsp_TipoCambio_PagSig '11111111111',null,null,100,null,null,null,null,null,null
--exec Gsp_TipoCambio_PagSig '11111111111',null,null,100,'04/04/2007',null,null,null,null,null

--PV: MAR 30/11/2010 -- MDF: set @Ult_FecTC = '31/12/2050' --PV


GO
