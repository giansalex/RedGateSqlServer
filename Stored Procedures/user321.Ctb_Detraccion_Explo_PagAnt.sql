SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_Detraccion_Explo_PagAnt]
@RucE nvarchar(11),
@FecD smalldatetime,
@FecH smalldatetime,
@Colum varchar(100),
@Dato varchar(100),
---------------------------
@TamPag int,
@UltCdDtr char(4),
@Max char(4) output,
@Min char(4) output,
---------------------------
@msj varchar(100) output
as
set language spanish
	declare @Inter varchar(1000)
	declare @Cond varchar(1000)
	declare @sql nvarchar(4000)

	set @Inter= '		user321.DetraccionExplorador a'

	set @Cond='a.RucE='''+@RucE+''' and a.Cd_CDtr < '''+isnull(@UltCdDtr,'')+''''
	print @Inter
	print @Cond


	if(@Colum = 'Cd_CDtr') set @Cond = @Cond + ' and a.Cd_CDtr like '''+@Dato+''''
	else if(@Colum = 'Descrip') set @Cond = @Cond + ' and a.Descrip like '''+@Dato+''''
	else if(@Colum = 'Cd_ProdServ') set @Cond = @Cond + ' and a.Cd_ProdServ like '''+@Dato+''''
	else if(@Colum = 'ProdServ') set @Cond = @Cond + ' and a.ProdServ like '''+@Dato+''''
	else if(@Colum = 'FecVig') set @Cond = @Cond + ' and convert(nvarchar, a.FecVig,103) like '''+@Dato+''''
	else if(@Colum = 'Porc') set @Cond = @Cond + ' and a.Porc like '''+@Dato+''''
	else if(@Colum = 'MtoDtr') set @Cond = @Cond + ' and a.MtoDtr like '''+@Dato+''''

	declare @Consulta varchar(8000)

	set @Consulta='Select *from (Select top '+Convert(nvarchar,@TamPag)+'	a.RucE, a.Cd_CDtr, a.Descrip, a.Cd_ProdServ, a.ProdServ, 
			convert(nvarchar, a.FecVig,103) as FecVig, a.Porc,a.MtoDtr
			from '+@Inter+'
			where '+@Cond+' order by a.Cd_CDtr) as Detraccion order by Cd_CDtr'
	print @Consulta
	exec(@Consulta)

	set @sql = 'select top 1 @RMax =Cd_CDtr from '+@Inter+' where  '+@Cond+' order by Cd_CDtr desc'
	exec sp_executesql @sql, N'@RMax char(4) output', @Max output
	print @sql
	set @sql = 'select @RMin = min(Cd_CDtr) from(select top '+Convert(nvarchar,@TamPag)+' Cd_CDtr from '+@Inter+' where  '+@Cond+' order by Cd_CDtr desc) as Detraccion'
	exec sp_executesql @sql, N'@RMin char(4) output', @Min output
	print @sql
-- Leyenda --
-- JJ : 2011-02-07 : <Creacion del procedimiento almacenado>




GO
