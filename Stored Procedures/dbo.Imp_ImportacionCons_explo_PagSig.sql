SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionCons_explo_PagSig]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
--------------------------------------
@TamPag int, --Tamano Pagina
@Ult_CdIP char(7),
@NroRegs int output,--Nro de Registros solo es consultado la primera vez
@NroPags int output,--Nro de Paginas solo es Consulado la primera vez
@Max char(7) output,
@Min char(7) output,
--------------------------------------
@msj varchar(100) output
as
	declare @Inter varchar(1000)
	--Interseccion	
	set @Inter = 'importacion as a
	left join almacen as b on a.RucE = b.RucE and a.Cd_Alm = b.Cd_Alm
	left join area as c on a.RucE = c.RucE and a.Cd_Area = c.Cd_Area'
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	--Condicion
	set @Cond = 'a.RucE=''' + @RucE + '''	and a.Cd_IP >'''+isnull(@Ult_CdIP,'')+''' and a.FecMov between '''+ convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''''
	if(@Colum = 'Cd_IP') set @Cond = @Cond+ ' and a.Cd_IP like '''+@Dato+''''
	else if(@Colum = 'NroImp') set @Cond = @Cond+ ' and a.NroImp like '''+@Dato+''''
	else if(@Colum = 'Ejer') set @Cond =@Cond+ ' and a.Ejer like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond = @Cond+' and a.FecMov like '''+@Dato+''''
	else if(@Colum = 'Cd_Alm') set @Cond = @Cond+' and a.Cd_Alm like '''+@Dato+''''
	else if(@Colum = 'AlmNom') set @Cond = @Cond+' and b.Nombre like '''+@Dato+''''
	else if(@Colum = 'Cd_Area') set @Cond = @Cond+' and a.Cd_Area like '''+@Dato+''''
	else if(@Colum = 'AreaDesc') set @Cond = @Cond+' and c.Descrip like '''+@Dato+''''
	else if(@Colum = 'Asunto') set @Cond = @Cond+' and a.Asunto like '''+@Dato+''''
	else if(@Colum = 'Obs') set @Cond = @Cond+' and a.Obs like '''+@Dato+''''
	else if(@Colum = 'EXWT') set @Cond = @Cond+' and  a.EXWT like '''+@Dato+''''
	else if(@Colum = 'ComT') set @Cond = @Cond+' and  a.ComT like '''+@Dato+''''
	else if(@Colum = 'OtroET') set @Cond = @Cond+' and  a.OtroET like '''+@Dato+''''
	else if(@Colum = 'FOBT') set @Cond = @Cond+' and  a.FOBT like '''+@Dato+''''
	else if(@Colum = 'FleteT') set @Cond = @Cond+' and  a.FleteT like '''+@Dato+''''
	else if(@Colum = 'SegT') set @Cond = @Cond+' and  a.SegT like '''+@Dato+''''
	else if(@Colum = 'OtroFT') set @Cond = @Cond+' and  a.OtroFT like '''+@Dato+''''
	else if(@Colum = 'CIFT') set @Cond = @Cond+' and  a.CIFT like '''+@Dato+''''
	else if(@Colum = 'AdvT') set @Cond = @Cond+' and  a.AdvT like '''+@Dato+''''
	else if(@Colum = 'OtroCT') set @Cond = @Cond+' and  a.OtroCT like '''+@Dato+''''
	else if(@Colum = 'Total') set @Cond = @Cond+' and  a.Total like '''+@Dato+''''
	else if(@Colum = 'RatioT') set @Cond = @Cond+' and  a.RatioT like '''+@Dato+''''
	else if(@Colum = 'EXWT_ME') set @Cond = @Cond+' and  a.EXWT_ME like '''+@Dato+''''
	else if(@Colum = 'ComT_ME') set @Cond = @Cond+' and  a.ComT_ME like '''+@Dato+''''
	else if(@Colum = 'OtroET_ME') set @Cond = @Cond+' and  a.OtroET_ME like '''+@Dato+''''
	else if(@Colum = 'FOBT_ME') set @Cond = @Cond+' and  a.FOBT_ME like '''+@Dato+''''
	else if(@Colum = 'FleteT_ME') set @Cond = @Cond+' and  a.FleteT_ME like '''+@Dato+''''
	else if(@Colum = 'SegT_ME') set @Cond = @Cond+' and  a.SegT_ME like '''+@Dato+''''
	else if(@Colum = 'OtroFT_ME') set @Cond = @Cond+' and  a.OtroFT_ME like '''+@Dato+''''
	else if(@Colum = 'CIFT_ME') set @Cond = @Cond+' and  a.CIFT_ME like '''+@Dato+''''
	else if(@Colum = 'AdvT_ME') set @Cond = @Cond+' and  a.AdvT_ME like '''+@Dato+''''
	else if(@Colum = 'OtroCT_ME') set @Cond = @Cond+' and  a.OtroCT_ME like '''+@Dato+''''
	else if(@Colum = 'Total_ME') set @Cond = @Cond+' and  a.Total_ME like '''+@Dato+''''
	else if(@Colum = 'RatioT_ME') set @Cond = @Cond+' and  a.RatioT_ME like '''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond =@Cond+ ' and a.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond = @Cond+' and a.Cd_CC like'''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond = @Cond+' and a.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond=@Cond +' and convert(varchar,a.FecReg,103) like '''+@Dato+''''
	else if(@Colum = 'FecMdf') set @Cond=@Cond +' and convert(varchar,a.FecMdf,103) like '''+@Dato+''''
	else if(@Colum = 'UsuCrea') set @Cond=@Cond +' and a.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'UsuModf') set @Cond=@Cond +' and a.UsuModf like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond=@Cond +' and a.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond=@Cond +' and a.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond=@Cond +' and a.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond=@Cond +' and a.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond=@Cond +' and a.CA05 like '''+@Dato+''''
	else if(@Colum = 'CA06') set @Cond=@Cond +' and a.CA06 like '''+@Dato+''''
	else if(@Colum = 'CA07') set @Cond=@Cond +' and a.CA07 like '''+@Dato+''''
	else if(@Colum = 'CA08') set @Cond=@Cond +' and a.CA08 like '''+@Dato+''''
	else if(@Colum = 'CA09') set @Cond=@Cond +' and a.CA09 like '''+@Dato+''''
	else if(@Colum = 'CA10') set @Cond=@Cond +' and a.CA10 like '''+@Dato+''''
	

	declare @Consulta nvarchar(4000)
	set @Consulta = '	select top '+ convert(nvarchar,@TamPag) +'
		a.RucE,a.Cd_IP,a.NroImp,a.Ejer,a.FecMov,a.Cd_Alm,b.Nombre as AlmNom,a.Cd_Area,c.Descrip as AreaDesc,a.Asunto,
		a.Obs,a.EXWT,a.ComT,a.OtroET,a.FOBT,a.FleteT,a.SegT,a.OtroFT,a.CIFT,a.AdvT,a.OtroCT,a.Total,a.RatioT,
		a.EXWT_ME,a.ComT_ME,a.OtroET_ME,a.FOBT_ME,a.FleteT_ME,a.SegT_ME,a.OtroFT_ME,a.CIFT_ME,a.AdvT_ME,a.OtroCT_ME,a.Total_ME,a.RatioT_ME,
		a.Cd_CC,a.Cd_SC,a.Cd_SS,a.FecReg,a.FecMdf,a.UsuCrea,a.UsuModf,
		a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10
		from '+@inter+' 
		where '+@Cond+ ' order by a.FecMov' 
	Exec (@Consulta)
	if(@Ult_CdIP is null) -- si es primera pagina y primera busqueda
	begin
		set @sql = 'select @Regs = count(*) from ' +@Inter+ ' where '+@Cond
		exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		set @NroPags = @NroRegs/@TamPag + case when @NroRegs%@TamPag=0 then 0 else 1 end
	end
	set @sql = 'select top 1 @RMin = a.Cd_IP from ' + @Inter + ' where ' +@Cond+' order by a.Cd_IP'
	exec sp_executesql @sql, N'@RMin char(7) output', @Min output	
	set @sql = 'select top 1 @RMax = Cd_IP from (select top '+ convert(nvarchar,@TamPag) +' Cd_IP from ' + @Inter + ' where ' + @Cond +' order by a.Cd_IP) as Importacion order by Cd_IP desc'
	print @sql
	exec sp_executesql @sql, N'@RMax char(7) output',@Max output

-- Leyenda --

-- Epsilower 13/04/2011 11:01:32:293 : <Creacion del procedimiento almacenado>
GO
