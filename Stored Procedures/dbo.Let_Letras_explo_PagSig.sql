SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Let_Letras_explo_PagSig]
@RucE nvarchar(11)
,@Ejer nvarchar(4)
,@FecD datetime
,@FecH datetime
,@Colum varchar(100)
,@Dato varchar(100)
--------------------------------------
,@TamPag int --Tamano Pagina
,@Ult_CdLtr char(10)
,@NroRegs int output--Nro de Registros solo es consultado la primera vez
,@NroPags int output--Nro de Paginas solo es Consulado la primera vez
,@Max char(10) output
,@Min char(10) output
,@msj varchar(100) output
as
--exec Let_Letras_explo_PagSig '20513272848','2012','01/05/2012','30/06/2012','','',15,'','','','','',null

--set @RucE = '20513272848'
--set @Ejer = '2012'
--set @FecD = '01/05/2012'
--set @FecH = '30/06/2012'
--set @Colum = ''
--set @Dato = ''
--set @TamPag = 10
--set @Ult_CdLtr = ''
----Output--
--set @NroRegs = ''
--set @NroPags = ''
--set @Max = ''
--set @Min = ''

	declare @Cond varchar(1000)
	declare @sql nvarchar(4000)
	set @Cond = 'Can.RucE='''+@RucE+''' and can.Ejer = '''+@Ejer+''' and l.FecGiro between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+'''and l.Cd_Ltr >''' + Convert(nvarchar,isnull(@Ult_CdLtr,''))+''''	
	
	if(@Colum = 'Cd_Cnj') set @Cond = @Cond+ ' and Can.Cd_Cnj like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and Can.RegCtb like '''+@Dato+''''
	--else if(@Colum = 'Prdo') set @Cond =@Cond+ ' and Can.Prdo '''+@Dato+''''
	--else if(@Colum = 'FecMov') set @Cond=@Cond +' and Convert(nvarchar,Can.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_Clt') set @Cond=@Cond +' and Can.Cd_Clt like '''+@Dato+''''
	else if(@Colum = 'DocCli') set @Cond=@Cond +' and clt.NDoc like '''+@Dato+''''
	else if(@Colum = 'Cliente') set @Cond=@Cond +' and case(isnull(len(Can.Cd_Clt),0)) when 0 then '''' else case(isnull(len(Clt.RSocial),0)) when 0 then isnull(Clt.ApPat,'''')+'' ''+isnull(Clt.ApMat,'''')+'', ''+isnull(Clt.Nom,'''') else Clt.RSocial end end like '''+@Dato+''''
	--else if(@Colum = 'Cd_MIS') set @Cond = @Cond+' and Can.Cd_MIS like '''+@Dato+''''
	--else if(@Colum = 'CantLtr') set @Cond=@Cond +' and Abs(Can.CantLtr) like '''+@Dato+''''
	else if(@Colum = 'Cd_Ltr') set @Cond=@Cond +' and l.Cd_Ltr like '''+@Dato+''''
	else if(@Colum = 'Cd_TD') set @Cond=@Cond +' and l.Cd_TD like '''+@Dato+''''
	else if(@Colum = 'NroRenv') set @Cond=@Cond +' and l.NroRenv like '''+@Dato+''''
	else if(@Colum = 'NroLtr') set @Cond=@Cond +' and l.NroLtr like '''+@Dato+''''
	else if(@Colum = 'RefGdor') set @Cond=@Cond +' and l.RefGdor like '''+@Dato+''''
	else if(@Colum = 'LugGdor') set @Cond=@Cond +' and l.LugGdor like '''+@Dato+''''
	else if(@Colum = 'FecGiro') set @Cond=@Cond +' and l.FecGiro like '''+@Dato+''''
	else if(@Colum = 'FecVenc') set @Cond=@Cond +' and l.FecVenc like '''+@Dato+''''
	else if(@Colum = 'Plazo') set @Cond=@Cond +' and l.Plazo like '''+@Dato+''''
	else if(@Colum = 'LugGdor') set @Cond=@Cond +' and l.LugGdor like '''+@Dato+''''
	else if(@Colum = 'Imp') set @Cond=@Cond +' and Abs(l.Imp) like '''+@Dato+''''
	else if(@Colum = 'Dsct') set @Cond=@Cond +' and Abs(l.Dsct) like '''+@Dato+''''
	else if(@Colum = 'Total') set @Cond=@Cond +' and Abs(l.Total) like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond=@Cond +' and l.RecReg like '''+@Dato+''''
	else if(@Colum = 'FecMdf') set @Cond=@Cond +' and l.FecMdf like '''+@Dato+''''
	else if(@Colum = 'LugGdor') set @Cond=@Cond +' and l.LugGdor like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond=@Cond +' and Can.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond=@Cond +' and Can.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond=@Cond +' and Can.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond=@Cond +' and Can.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond=@Cond +' and Can.CA05 like '''+@Dato+''''	
	else if(@Colum = 'CA06') set @Cond=@Cond +' and Can.CA06 like '''+@Dato+''''
	else if(@Colum = 'CA07') set @Cond=@Cond +' and Can.CA07 like '''+@Dato+''''
	else if(@Colum = 'CA08') set @Cond=@Cond +' and Can.CA08 like '''+@Dato+''''
	else if(@Colum = 'CA09') set @Cond=@Cond +' and Can.CA09 like '''+@Dato+''''
	else if(@Colum = 'CA010') set @Cond=@Cond +' and Can.CA010 like '''+@Dato+''''

	declare @SqlInter varchar(2000)
	set @SqlInter =
	'
	Canje can
	left join Letra_cobro l on l.RucE = can.RucE and l.Cd_Cnj = can.Cd_Cnj
	left join Cliente2 clt on clt.RucE = can.RucE and clt.Cd_Clt = can.Cd_Clt
	inner join Moneda Mda on Mda.Cd_Mda = Can.Cd_Mda
	'


	declare @SqlConsulta varchar(4000)
	set @SqlConsulta  =
	'
	select top '+convert(nvarchar,@TamPag)+'
	can.Ejer
	,can.Prdo
	,can.RegCtb
	,can.Cd_Clt
	,case isnull(can.Cd_Mda,'''') when ''01'' then ''S/.'' when ''02'' then ''US$'' else '''' end as SimMda
	,mda.Nombre as NomMda
	,clt.NDoc as DocCli
	,case when isnull(clt.Rsocial,'''')='''' then isnull(clt.ApPat,'''')+'' ''+isnull(clt.ApMat,'''')+'' ''+isnull(clt.Nom,'''') else clt.RSocial end as Cliente
	,l.*
	from
	'+@SqlInter+'where '+@Cond+'order by l.FecGiro asc'
	
	print @SqlConsulta
	exec (@SqlConsulta)
	
	if not exists (select top 1 * from Letra_cobro where RucE=@RucE)
		set @msj = 'No existen Letras.'
	else
	--select top 1 * from Producto2
	  begin
		
		if(@Ult_CdLtr is null) -- si es primera pagina y primera busqueda
		  begin
		    set @sql = 'select @Regs = count(*) from ' +@SqlInter+ ' where '+@Cond
		    exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		    select @NroPags = @NroRegs/@TamPag + case when @NroRegs%@TamPag=0 then 0 else 1 end		    
		    print @sql
		  end
		  set @sql = 'select @RMax = max(Cd_Ltr) from(select top '+ Convert(nvarchar,@TamPag)+' Cd_Ltr  from ' + @SqlInter + ' where ' + @Cond +' order by Cd_Ltr) as  Letra'
		  exec sp_executesql @sql, N'@RMax char(12) output',@Max output
			print @sql
		  set @sql = 'select top 1 @RMin = Cd_Ltr from ' + @SqlInter + ' where ' +@Cond+' order by Cd_Ltr'
		  exec sp_executesql @sql, N'@RMin char(12) output', @Min output
		  print @sql
	end
	

GO
