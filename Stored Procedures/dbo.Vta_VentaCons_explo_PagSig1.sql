SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaCons_explo_PagSig1]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
--------------------------------------
@TamPag int, 
@Ult_CdVta nvarchar(10),
@NroRegs int output,--Nro de Registros solo es consultado la primera vez
@NroPags int output,--Nro de Paginas solo es Consulado la primera vez
@Max nvarchar(10) output,
@Min nvarchar(10) output,
--------------------------------------
@msj varchar(100) output
as

	declare @Inter varchar(1000)

	--Interseccion
		set @Inter = 'venta v inner join Moneda mo on mo.Cd_Mda=v.Cd_Mda
				left join FormaPC fp on fp.Cd_FPC=v.Cd_FPC
				inner join TipDoc td on td.Cd_TD=v.Cd_TD
				inner join Area ar on ar.RucE=v.RucE and ar.Cd_Area=v.Cd_Area
				left join Vendedor2 v2 on v2.RucE=v.RucE and v2.Cd_Vdr=v.Cd_Vdr
				left join Cliente2 c2 on c2.RucE=v.RucE and c2.Cd_Clt=v.Cd_Clt
				left join MtvoIngSal mis on mis.RucE=v.RucE and mis.Cd_MIS=v.Cd_MIS'

	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	--Condicion	
	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = '(v.RucE='''+@RucE+''')  and v.Cd_Vta > ''' + Convert(nvarchar,isnull(@Ult_CdVta,'')) +''' and Cd_Cte_NO is null '
	end
	else
	begin
		set @Cond = '(v.RucE='''+@RucE+''')  and (v.FecMov between '''+Convert(nvarchar,@FecD,103)+''' and '''+
		Convert(nvarchar,@FecH,103)+''') and v.Cd_Vta > ''' + Convert(nvarchar,isnull(@Ult_CdVta,'')) +''' and Cd_Cte_NO is null '
	end


	
	if(@Colum = 'Cd_Vta') set @Cond = @Cond+ ' and v.Cd_Vta like '''+@Dato+''''
	else if(@Colum = 'Eje') set @Cond = @Cond+ ' and v.Eje like '''+@Dato+''''
	else if(@Colum = 'Prdo') set @Cond =@Cond+ ' and v.Prdo like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+' and v.RegCtb like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond = @Cond+' and Convert(nvarchar,v.FecMov,103) like '''+@Dato+''''
--
	else if(@Colum = 'Cd_MIS') set @Cond = @Cond+' and v.Cd_MIS like '''+@Dato+''''
--
	else if(@Colum = 'TipoDoc') set @Cond = @Cond+' and td.Descrip like '''+@Dato+''''
	else if(@Colum = 'NroSre') set @Cond=@Cond +' and v.NroSre like '''+@Dato+''''
	else if(@Colum = 'NroDoc') set @Cond = @Cond+' and v.NroDoc like '''+@Dato+''''
	else if(@Colum = 'Cd_Clt') set @Cond=@Cond +' and v.Cd_Clt like '''+@Dato+''''
	else if(@Colum = 'Cliente') set @Cond=@Cond +' and case(isnull(len(v.Cd_Clt),0)) when 0 then '''' else case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'''')+'' ''+isnull(c2.ApMat,'''')+'', ''+isnull(c2.Nom,'''') else c2.RSocial end end like '''+@Dato+''''
	else if(@Colum = 'FecED') set @Cond=@Cond +' and Convert(nvarchar,v.FecED,103) like '''+@Dato+''''
	else if(@Colum = 'FecVD') set @Cond=@Cond +' and Convert(nvarchar,v.FecVD,103) like '''+@Dato+''''
	else if(@Colum = 'Moneda') set @Cond=@Cond +' and mo.Nombre like '''+@Dato+''''
	else if(@Colum = 'CamMda') set @Cond=@Cond +' and v.CamMda like '''+@Dato+''''
	else if(@Colum = 'Obs') set @Cond=@Cond +' and v.Obs like '''+@Dato+''''
	else if(@Colum = 'Valor') set @Cond=@Cond +' and v.Valor like '''+@Dato+''''
	else if(@Colum = 'TotDsctoP') set @Cond=@Cond +' and v.TotDsctoP like '''+@Dato+''''
	else if(@Colum = 'TotDsctoI') set @Cond=@Cond +' and v.TotDsctoI like '''+@Dato+''''
	else if(@Colum = 'ValorNeto') set @Cond=@Cond +' and v.ValorNeto like '''+@Dato+''''
	else if(@Colum = 'Cd_IAV_DF') set @Cond=@Cond +' and Case(v.Cd_IAV_DF) when ''E'' then ''Exonerado'' when ''S'' then ''Base Imponible'' when ''I'' then ''Inafecto'' when ''V'' then ''Exportacion'' else '' '' end like '''+@Dato+''''
	else if(@Colum = 'BaseSinDsctoF') set @Cond=@Cond +' and v.BaseSinDsctoF like '''+@Dato+''''
	else if(@Colum = 'DsctoFnz_P') set @Cond=@Cond +' and v.DsctoFnz_P like '''+@Dato+''''
	else if(@Colum = 'DsctoFnz_I') set @Cond=@Cond +' and v.DsctoFnz_I like '''+@Dato+''''
	else if(@Colum = 'BIM_Neto') set @Cond=@Cond +' and v.BIM_Neto like '''+@Dato+''''
	else if(@Colum = 'INF_Neto') set @Cond=@Cond +' and v.INF_Neto like '''+@Dato+''''
	else if(@Colum = 'EXO_Neto') set @Cond=@Cond +' and v.EXO_Neto like '''+@Dato+''''
	else if(@Colum = 'EXPO_Neto') set @Cond=@Cond +' and v.EXPO_Neto like '''+@Dato+''''
	else if(@Colum = 'IGV') set @Cond=@Cond +' and v.IGV like '''+@Dato+''''
	else if(@Colum = 'Total') set @Cond=@Cond +' and v.Total like '''+@Dato+''''
	else if(@Colum = 'Percep') set @Cond=@Cond +' and v.Percep like '''+@Dato+''''
	else if(@Colum = 'FormaPago') set @Cond = @Cond+' and fp.Nombre like '''+@Dato+''''
	else if(@Colum = 'FecCbr') set @Cond = @Cond+' and Convert(nvarchar,v.FecCbr,103) like '''+@Dato+''''	
	else if(@Colum = 'Cd_Vdr') set @Cond=@Cond +' and v.Cd_Vdr like '''+@Dato+''''
	else if(@Colum = 'Vendedor') set @Cond=@Cond +' and Case(isnull(len(v2.RSocial),0)) when 0 then isnull(v2.ApPat,'''')+'' ''+isnull(v2.ApMat,'''')+'' ''+isnull(v2.Nom,'''') else v2.RSocial end like '''+@Dato+''''
	else if(@Colum = 'Area') set @Cond=@Cond +' and ar.Descrip like '''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond=@Cond +' and v.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond=@Cond +' and v.Cd_SC like '''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond=@Cond +' and v.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'DR_CdVta') set @Cond=@Cond +' and v.DR_CdVta like '''+@Dato+''''
	else if(@Colum = 'DR_FecED') set @Cond=@Cond +' and Convert(nvarchar,v.DR_FecED,103) like '''+@Dato+''''
	else if(@Colum = 'DR_CdTD') set @Cond=@Cond +' and v.DR_CdTD like '''+@Dato+''''
	else if(@Colum = 'DR_NSre') set @Cond=@Cond +' and v.DR_NSre like '''+@Dato+''''
	else if(@Colum = 'DR_NDoc') set @Cond=@Cond +' and v.DR_NDoc like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond=@Cond +' and v.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond=@Cond +' and v.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond=@Cond +' and v.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond=@Cond +' and v.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond=@Cond +' and v.CA05 like '''+@Dato+''''
	else if(@Colum = 'CA06') set @Cond=@Cond +' and v.CA06 like '''+@Dato+''''
	else if(@Colum = 'CA07') set @Cond=@Cond +' and v.CA07 like '''+@Dato+''''
	else if(@Colum = 'CA08') set @Cond=@Cond +' and v.CA08 like '''+@Dato+''''
	else if(@Colum = 'CA09') set @Cond=@Cond +' and v.CA09 like '''+@Dato+''''
	else if(@Colum = 'CA10') set @Cond=@Cond +' and v.CA10 like '''+@Dato+''''
	else if(@Colum = 'CA11') set @Cond=@Cond +' and v.CA11 like '''+@Dato+''''
	else if(@Colum = 'CA12') set @Cond=@Cond +' and v.CA12 like '''+@Dato+''''
	else if(@Colum = 'CA13') set @Cond=@Cond +' and v.CA13 like '''+@Dato+''''
	else if(@Colum = 'CA14') set @Cond=@Cond +' and v.CA14 like '''+@Dato+''''
	else if(@Colum = 'CA15') set @Cond=@Cond +' and v.CA15 like '''+@Dato+''''
	else if(@Colum = 'Cd_OP') set @Cond=@Cond +' and v.Cd_OP like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond=@Cond +' and Convert(nvarchar,v.FecReg,103) like '''+@Dato+'''' 
	else if(@Colum = 'FecMdf') set @Cond=@Cond +' and Convert(nvarchar,v.FecMdf,103) like '''+@Dato+'''' 
	else if(@Colum = 'UsuCrea') set @Cond=@Cond +' and v.UsuCrea like '''+@Dato+'''' 
	else if(@Colum = 'UsuModf') set @Cond=@Cond +' and v.UsuModf like '''+@Dato+'''' 
	else if(@Colum = 'IB_Anulado') set @Cond=@Cond +' and case(v.IB_Anulado) when 0 then ''False'' else ''True'' end  like '''+@Dato+''''
	--else if(@Colum = 'Cd_MIS') set @Cond=@Cond +' and v.Cd_MIS like '''+@Dato+''''
	--else if(@Colum = 'MtvoIngSal') set @Cond=@Cond +' and mis.Descrip like '''+@Dato+''''
	
	
	

	declare @Consulta nvarchar(4000)
		set @Consulta='		select top '+convert(nvarchar,@TamPag)+'
				v.Cd_Vta, v.Eje, v.Prdo, v.RegCtb,
				Convert(nvarchar,v.FecMov,103) as FecMov,v.Cd_MIS,
				v.Cd_TD, td.Descrip as TipoDoc, v.NroSre,NroDoc, v.Cd_Clt,
				case(isnull(len(v.Cd_Clt),0)) when 0 then '''' else case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'''')+'' ''+isnull(c2.ApMat,'''')+'', ''+isnull(c2.Nom,'''') else c2.RSocial end end as Cliente,
				Convert(nvarchar,v.FecED,103) as FecED,Convert(nvarchar,v.FecVD,103) as FecVD,
				v.Cd_Mda,mo.Nombre as Moneda, v.CamMda, v.Obs, isnull(v.ValorNeto,''0.00'') as ValorNeto,
				case(v.Cd_IAV_DF) when ''E'' then ''Exonerado'' when ''S'' then ''Base Imponible'' when ''I'' then ''Inafecto'' when ''V'' then ''Exportacion'' else '' '' end as Cd_IAV_DF,
				isnull(v.BaseSinDsctoF,''0.00'') as BaseSinDsctoF,
				isnull(v.DsctoFnz_P,''0.00'') as DsctoFnz_P,
				isnull(v.DsctoFnz_I,''0.00'') as DsctoFnz_I,
				isnull(v.INF_Neto,''0.00'') as INF_Neto,
				isnull(v.EXO_Neto,''0.00'') as EXO_Neto,
				isnull(v.EXPO_Neto,''0.00'') as EXPO_Neto,
				isnull(v.BIM_Neto,''0.00'') as BIM_Neto,
				case(v.IGV) when 0 then 0 else 1 end as IncIGV,
				isnull(v.IGV,''0.00'') as IGV,
				isnull(v.Total,''0.00'') as Total,
				isnull(v.Percep, ''0.00'') as Percep,
				v.Cd_FPC,
				fp.Nombre as FormaPago,
				Convert(nvarchar,v.FecCbr,103) as FecCbr,
				case v.IB_Cbdo when 1 then 1 else 0 end as IB_Cbdo,
				v.Cd_Vdr,
				case(isnull(len(v2.RSocial),0)) when 0 then isnull(v2.ApPat,'''')+'' ''+isnull(v2.ApMat,'''')+'' ''+isnull(v2.Nom,'''') else v2.RSocial end as Vendedor,
				v.Cd_Area,
				ar.Descrip as Area,
				v.Cd_CC, v.Cd_SC, v.Cd_SS, v.DR_CdVta,
				Convert(nvarchar,v.DR_FecED,103) as DR_FecED,
				v.DR_CdTD, v.DR_NSre, v.DR_NDoc,
				v.Cd_OP,Convert(nvarchar,v.FecReg,103) as FecReg,
				v.UsuCrea,
				Convert(nvarchar,v.FecMdf,103) as FecMdf, v.UsuModf,
				
				
				isnull(v.Valor,''0.00'') as Valor, isnull(v.TotDsctoP,''0.00'') as TotDsctoP, isnull(v.TotDsctoI,''0.00'') as TotDsctoI,
				Case When (Select Count(d.Id_Doc) from DocsVta d Where d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta)>0 Then 1 Else 0 End DocAdd,
				case v.IB_Anulado when 1 then 1 else 0 end as IB_Anulado,
								v.CA01, v.CA02, v.CA03, v.CA04, v.CA05, v.CA06, v.CA07, v.CA08, v.CA09, v.CA10, v.CA11, v.CA12, v.CA13, v.CA14, v.CA15
				from
				' +@Inter+' where 
				'+@Cond + ' order by v.Cd_Vta '
print @Consulta
	if not exists (select top 1 * from Venta where RucE=@RucE) --and Cd_Clt = @Cd_Clt)
		set @msj = 'No se encontraron Ventas registradas'
	else
	  begin
		Exec (@Consulta)
		if(@Ult_CdVta is null) -- si es primera pagina y primera busqueda
		  begin
		    set @sql = 'select @Regs = count(*) from ' +@Inter+ ' where '+@Cond
		    exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		    set @NroPags = @NroRegs/@TamPag + case when @NroRegs%@TamPag=0 then 0 else 1 end
		  end
		  set @sql = 'select @RMax = max(Cd_Vta) from(select top '+ Convert(nvarchar,@TamPag)+' Cd_Vta  from ' + @Inter + ' where ' + @Cond +' order by Cd_Vta) as  Venta'
		  exec sp_executesql @sql, N'@RMax nvarchar(10) output',@Max output

		  set @sql = 'select top 1 @RMin = Cd_Vta from ' + @Inter + ' where ' +@Cond+' order by Cd_Vta'
		  exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output
	end
-- Leyenda --
--exec dbo.Vta_VentaCons_explo_PagSig1 '11111111111','22/04/2011','02/05/2011','','',50,'','','','','',null
-- JJ : 2010-09-21 	: <Creacion del procedimiento almacenado>
-- JJ : 2010-09-30	: <Se Agrego Percepcion>





GO
