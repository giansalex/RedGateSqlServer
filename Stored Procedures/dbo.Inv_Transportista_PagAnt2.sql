SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Transportista_PagAnt2]
@RucE nvarchar(11),
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --Tamaño Pagina
@Ult_CdTra char(7),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(7) output,
@Min char(7) output,

----------------------
@msj varchar(100) output
as
	declare @Inter varchar(1000)
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	declare @Consulta  nvarchar(4000)
	set @Inter =  'Transportista tra 
			left join TipDocIdn tdi on tra.Cd_TDI= tdi.Cd_TDI'
	set @Cond = 'tra.RucE='''+@RucE + '''and tra.Cd_TDI = tdi.Cd_TDI' + ' and Cd_Tra < '''+isnull(@Ult_CdTra,'') +''''
	if(@Colum = 'Cd_Tra') set @Cond = @Cond+ ' and tra.Cd_Tra like '''+@Dato+''''
	else if(@Colum = 'NCorto') set @Cond = @Cond+ ' and tdi.NCorto like '''+@Dato+''''
	else if(@Colum = 'NDoc') set @Cond = @Cond+ ' and tra.NDoc like '''+@Dato+''''
	else if(@Colum = 'RSocial') set @Cond = @Cond+ ' and tra.RSocial like '''+@Dato+''''
	else if(@Colum = 'ApPat') set @Cond = @Cond+ ' and tra.ApPat like '''+@Dato+''''
	else if(@Colum = 'ApMat') set @Cond = @Cond+ ' and tra.ApMat like '''+@Dato+''''
	else if(@Colum = 'Nom') set @Cond = @Cond+ ' and tra.Nom like '''+@Dato+''''
	else if(@Colum = 'Cd_Pais') set @Cond = @Cond+ ' and tra.Cd_Pais like '''+@Dato+''''
	else if(@Colum = 'Direc') set @Cond = @Cond+ ' and tra.Direc like '''+@Dato+''''
	else if(@Colum = 'Telf') set @Cond = @Cond+ ' and tra.Telf like '''+@Dato+''''
	else if(@Colum = 'LicCond') set @Cond = @Cond+ ' and tra.LicCond like '''+@Dato+''''
	else if(@Colum = 'NroPlaca') set @Cond = @Cond+ ' and tra.NroPlaca like '''+@Dato+''''
	else if(@Colum = 'McaVeh') set @Cond = @Cond+ ' and tra.McaVeh like '''+@Dato+''''
	else if(@Colum = 'Estado') set @Cond = @Cond+ ' and vnd.Estado like '''+@Dato+''''

	set @Consulta =' select * from (select top '+Convert(nvarchar,@TamPag)+'
		tra.RucE,
		tra.Cd_Tra,
		tdi.NCorto,
		tra.NDoc,
		tra.RSocial,
		tra.ApPat,
		tra.ApMat,
		tra.Nom,
		tra.Cd_Pais,
		tra.Ubigeo,
		tra.Direc,
		tra.Telf,
		tra.LicCond,
		tra.NroPlaca,
		tra.McaVeh,
		tra.Estado,
		tra.UsuCrea,
		tra.FecReg,
		tra.UsuMdf,
		tra.FecMdf
	from '+@Inter+'
	where '+@Cond+'
	order by tra.RucE, Cd_Tra desc) as Transportistas order by Cd_Tra'
print @Consulta
	Exec (@Consulta)

	set @sql = 'select top 1 @RMax = Cd_Tra from '+@Inter+' where '+@Cond+'order by Cd_Tra DESC'
	exec sp_executesql @sql, N'@RMax char(7) output', @Max output
print @sql
	set @sql = 'select @RMin = min(Cd_Tra) from (select top ' + convert(nvarchar,@TamPag)+' Cd_Tra from ' + @Inter+'
		where '+@Cond+'
		order by Cd_Tra DESC) as Transportista'

	exec sp_executesql @sql, N'@RMin char(7) output', @Min output
print @sql

----------------------------------------------------------------------------------------------------
-- Leyenda --
-- CAM 04/10/2010 Creado.

--exec Inv_Transportista_PagAnt '11111111111',null,null,100,TRA0301,null,null,null,null,null
--sp_help Inv_Transportista_PagAnt
--select * from Transportista where RucE= '11111111111'
GO
