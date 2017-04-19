SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_Detraccion_Explo_PagSig]
@RucE nvarchar(11),
@FecD smalldatetime,
@FecH smalldatetime,
@Colum varchar(100),
@Dato varchar(100),
---------------------------
@TamPag int,
@UltCdDtr char(4),
@NroRegs int output, 
@NroPags int output,
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
	Set @Cond = ''
	set @Cond='a.RucE='''+@RucE+''' and a.Cd_CDtr > '''+isnull(@UltCdDtr,'')+''''
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

	set @Consulta='Select top '+Convert(nvarchar,@TamPag)+'	a.RucE, a.Cd_CDtr, a.Descrip, a.Cd_ProdServ, a.ProdServ, 
			convert(nvarchar, a.FecVig,103) as FecVig, a.Porc,a.MtoDtr
			from '+@Inter+'
			where '+@Cond+' order by a.Cd_CDtr'
	print @Consulta
	exec(@Consulta)

	if(@UltCdDtr is null)
	begin
		set @sql='select @Regs = count(*) from '+@Inter+ ' where ' +@Cond
		exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		select @NroPags = @NroRegs/@TamPag+case when @NroRegs%@TamPag=0 then 0 else 1 end
	end
	set @sql='select @RMax = max(Cd_CDtr) from(select top '+Convert(nvarchar,@TamPag)+ ' Cd_CDtr from '+@Inter+' where ' +@Cond+' order by Cd_CDtr) as Detraccion'
	exec sp_executesql @sql, N'@RMax char(4) output', @Max output

	set @sql = 'select top 1 @RMin =Cd_CDtr from '+@Inter+' where '+@Cond+' order by Cd_CDtr'
	exec sp_executesql @sql, N'@RMin char(4) output', @Min output


-- Leyenda --
-- JJ : 2011-02-07 : <Creacion del procedimiento almacenado>
GO
