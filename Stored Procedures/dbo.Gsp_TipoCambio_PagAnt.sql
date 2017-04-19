SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipoCambio_PagAnt]
@RucE nvarchar(11),
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --Tamaño Pagina
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
	set @Inter =  'Empresa e, 
		Moneda m, 
		TipCam c'	
	set @Cond = 'Ruc='''+@RucE + ''' and e.Cd_MdaS=m.Cd_Mda and m.Cd_Mda=c.Cd_Mda' +
	' and convert(datetime,c.FecTC,103) > convert(datetime,'''+@Ult_FecTC+''',103)'
	if(@Colum = 'FecTC') set @Cond = @Cond+ ' and c.FecTC like '''+@Dato+''''
	else if(@Colum = 'Cd_MdaS') set @Cond = @Cond+ ' and e.Cd_MdaS like '''+@Dato+''''
	else if(@Colum = 'Nombre') set @Cond = @Cond+ ' and m.Nombre like '''+@Dato+''''
	else if(@Colum = 'TCCom') set @Cond = @Cond+ ' and c.TCCom like '''+@Dato+''''
	else if(@Colum = 'TCVta') set @Cond = @Cond+ ' and c.TCVta like '''+@Dato+''''
	else if(@Colum = 'TCPro') set @Cond = @Cond+ ' and c.TCPro like '''+@Dato+''''

	set @Consulta =' select * from (select top '+Convert(nvarchar,@TamPag)+'
		c.FecTC,
		e.Cd_MdaS,
		m.Nombre,
		c.TCCom,
		c.TCVta,
		c.TCPro
	from '+@Inter+'
	where '+@Cond+'
	order by year(c.FecTC) asc ,month(c.FecTC) asc,day(c.FecTC) asc) as TipCam order by year(FecTC) desc ,month(FecTC) desc,day(FecTC) desc '
	print @Consulta
	Exec (@Consulta)

	set @sql = 'set @RMax = (select top 1 FecTC from(
			select top '+Convert(nvarchar,@TamPag)+' FecTC from '+@Inter+'
		where '+@Cond+ 'order by year(FecTC) asc ,month(FecTC) asc,day(FecTC) asc
	            ) as TipCam order by year(FecTC) desc ,month(FecTC) desc,day(FecTC) desc)'
	
	exec sp_executesql @sql, N'@RMax varchar(10) output', @Max output
				print 'maximo : '+ @Max
	print @sql
	set @sql = 'select top 1 @RMin =FecTC from (
			select top '+Convert(nvarchar,@TamPag)+' FecTC from '+@Inter+'
			where '+@Cond+'
			order by year(c.FecTC) asc,month(c.FecTC) asc ,day(c.FecTC) asc
	            ) as TipCam'
	exec sp_executesql @sql, N'@RMin varchar(10) output', @Min output
				print 'minimo : '+ @Min
	print @sql
----------------------------------------------------------------------------------------------------
-- Leyenda --
-- CAM 04/10/2010 Creado.
--exec Gsp_TipoCambio_PagAnt '11111111111',null,null,100,'18/06/2010',null,null,null,null,null
--exec Gsp_TipoCambio_PagAnt '11111111111',null,null,100,'09/03/2010',null,null,null,null,null

GO
