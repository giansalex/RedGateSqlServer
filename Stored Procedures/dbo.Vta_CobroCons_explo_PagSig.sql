SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CobroCons_explo_PagSig]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni datetime,
@PrdoFin datetime,
@UsuCons nvarchar(10),
@Colum varchar(100),
@Dato varchar(100),
-------------------------------------
@TamPag int, --TamaÃ±o Pagina
@Ult_CdItmCo int,
@NroRegs int output,--Nro de Registros solo es consultado la primera vez
@NroPags int output,--Nro de Paginas solo es Consulado la primera vez
@Max int output,
@Min int output,
-------------------------------------
@msj varchar(100) output
as

Declare @Cadena nvarchar(100)
set @Cadena = ''
if(@UsuCons not in ('admin','diego','emer1','jesus'))
	Set @Cadena = ' and c.UsuCrea='''+@UsuCons+''''
else
	declare @Inter varchar(1000)
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	--Interseccion
	set @Inter = 'Cobro c
		left Join Venta v On v.RucE=c.RucE and v.Cd_Vta=c.Cd_Vta
		left Join Banco b On b.RucE=c.RucE and b.Itm_BC=c.Itm_BC and c.Ejer=b.Ejer
		left Join PlanCtas p On p.RucE=b.RucE and p.NroCta=b.NroCta and p.Ejer=c.Ejer
		left join Vendedor2 a on a.RucE=v.RucE and a.Cd_Vdr=v.Cd_Vdr'
	print @Inter
	set @Cond = 'c.RucE='''+@RucE+''' and c.FecPag between '''+convert(nvarchar,@PrdoIni,103)+''' and '''+Convert(nvarchar,@PrdoFin,103)+''' and c.Ejer='''+@Ejer+''' and c.ItmCo > '+Convert(nvarchar, isnull(@Ult_CdItmCo,''))+@Cadena
	print @Cond
	if(@Colum = 'ItmCo') set @Cond = @Cond+ ' and c.ItmCo like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and c.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cod_Vta') set @Cond =@Cond+ ' and v.Cd_Vta like '''+@Dato+''''
	else if(@Colum = 'RegCtb_Vta') set @Cond = @Cond+' and v.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_TD') set @Cond = @Cond+' and v.Cd_TD like '''+@Dato+''''
	else if(@Colum = 'NroSerie') set @Cond = @Cond+' and v.NroSre like '''+@Dato+''''
	else if(@Colum = 'NroDoc') set @Cond = @Cond+' and v.NroDoc like '''+@Dato+''''
	else if(@Colum = 'Prdo') set @Cond = @Cond+' and  SubString(c.RegCtb,8,2) like '''+@Dato+''''
	else if(@Colum = 'FecPag') set @Cond = @Cond+' and Convert(varchar,c.FecPag,103) like '''+@Dato+''''
	else if(@Colum = 'Monto') set @Cond = @Cond+' and c.Monto like '''+@Dato+''''
	else if(@Colum = 'Moneda') set @Cond = @Cond+' and Case(c.Cd_Mda) when ''01'' then ''S/.'' else ''US$.'' end like '''+@Dato+''''
	else if(@Colum = 'TipCamb') set @Cond = @Cond+' and Case(c.Cd_Mda) when ''01'' then '''' else convert(varchar,c.CamMda) end like '''+@Dato+''''
	else if(@Colum = 'Itm_BC') set @Cond =@Cond+ ' and c.Itm_BC like '''+@Dato+''''
	else if(@Colum = 'NroCta') set @Cond = @Cond+' and p.NomCta like'''+@Dato+''''
	else if(@Colum = 'NroChke') set @Cond = @Cond+' and c.NroChke like '''+@Dato+''''
	else if(@Colum = 'NroVdr') set @Cond = @Cond+' and a.NDoc like '''+@Dato+''''
	else if(@Colum = 'NomVdr') set @Cond = @Cond+' and case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end like '''+@Dato+''''
	else if(@Colum = 'UsuCrea') set @Cond=@Cond +' and c.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'UsuModf') set @Cond=@Cond +' and c.UsuModf like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond=@Cond +' and c.FecReg like '''+@Dato+''''
	else if(@Colum = 'FecMdf') set @Cond=@Cond +' and c.FecMdf like '''+@Dato+''''

	declare @Consulta nvarchar(4000)
	set @Consulta = '	select top '+ convert(nvarchar,@TamPag) +'
			c.ItmCo,c.RegCtb,v.Cd_Vta as Cod_Vta,v.RegCtb as RegCtb_Vta,v.Cd_TD,v.NroSre as NroSerie,
			v.NroDoc,SubString(c.RegCtb,8,2) as Prdo,Convert(varchar,c.FecPag,103) as FecPag,c.Monto,
			Case(c.Cd_Mda) when ''01'' then ''S/.'' else ''US$.'' end Moneda,Case(c.Cd_Mda) when ''01'' then '''' else convert(varchar,c.CamMda) end TipCamb,
			c.Itm_BC,b.NroCta,p.NomCta,c.NroChke,a.NDoc as NroVdr,
			case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end as NomVdr,
			c.UsuCrea,c.UsuModf,c.FecReg,c.FecMdf
			from  
			'+@inter+' 
			where 
			'+@Cond+ ' order by c.ItmCo'
		print @Consulta
	if not exists (select top 1 * from Cobro where RucE=@RucE)
		set @msj = 'No se encontro Cobro'
	else
	  begin
		Exec (@Consulta)
		if(@Ult_CdItmCo is null) -- si es primera pagina y primera busqueda
		  begin
		    set @sql = 'select @Regs = count(*) from ' +@Inter+ ' where '+@Cond
		    exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		    set @NroPags = @NroRegs/@TamPag + case when @NroRegs%@TamPag=0 then 0 else 1 end
		  end
		  set @sql = 'select @RMax = max(ItmCo) from(select top '+ Convert(nvarchar,@TamPag)+' ItmCo  from ' + @Inter + ' where ' + @Cond +' order by ItmCo) as  Cobro'
		  exec sp_executesql @sql, N'@RMax int output',@Max output

		  set @sql = 'select top 1 @RMin = ItmCo from ' + @Inter + ' where ' +@Cond+' order by ItmCo'
		  exec sp_executesql @sql, N'@RMin int output', @Min output
	  end
-- Leyenda --
-- JJ:	2010-10-01	:	<Creacion del Procedimiento Almacenado>


GO
