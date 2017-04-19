SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionCons_explo_PagSig_Aut]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Colum varchar(100),
@Dato varchar(100),
@TipBusq int,
@usuario varchar(10),
----------------------
@TamPag int, --Tamaño Pagina
@Ult_CdCot nvarchar(15),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max nvarchar(15) output,
@Min nvarchar(15) output,
----------------------

@msj varchar(100) output

as

-- TipBusq --
-- 1 - Palabra contenida
-- 2 - Izquierda - Derecha
-- 3 - Derecha - Izquierda

Declare @D varchar(1) -- Buscar por derecha
Declare @I varchar(1) -- Buscar por izquierda
Set @D = ''
Set @I = ''

if(@TipBusq = 1) begin  Set @D = '%' Set @I = '%' end
else if (@TipBusq = 2)	Set @I = '%'
else if (@TipBusq = 3)	Set @D = '%'

print 'Lado derecho -> `'+@D+'´'
Print 'Lado izquierdo -> `'+@I+'´'


/*------------------------------------------------------------------------------*/
/**************************** Condiciones de busqueda ***************************/
/*------------------------------------------------------------------------------*/

Declare @Cond varchar(200)

if(@PrdoD = '' or @PrdoD is null)
begin
	Set @Cond = ' c.RucE='''+@RucE+''' and c.Cd_Cot > '''+isnull(@Ult_CdCot,'')+''''
end
else
begin
	Set @Cond = ' c.RucE='''+@RucE+''' and year(c.FecEmi)<='''+@Ejer+''' and c.Cd_Cot > '''+
	Convert(nvarchar,@Ult_CdCot)+''''
end

if(@Colum = 'Cd_Cot') Set @Cond = @Cond + ' and c.Cd_Cot like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'NroCot') Set @Cond = @Cond + ' and c.NroCot like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'FecEmi') Set @Cond = @Cond + ' and Convert(nvarchar,c.FecEmi,103) like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'FecCad') Set @Cond = @Cond + ' and Convert(nvarchar,c.FecCad,103) like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'Asunto') Set @Cond = @Cond + ' and c.Asunto like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'CostoTot') Set @Cond = @Cond + ' and c.CostoTot like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'Valor') Set @Cond = @Cond + ' and c.Valor like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'MU_Imp') Set @Cond = @Cond + ' and c.MU_Imp like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'INF') Set @Cond = @Cond + ' and c.INF like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'DsctoFnzInf_I') Set @Cond = @Cond + ' and c.DsctoFnzInf_I like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'INF_Neto') Set @Cond = @Cond + ' and c.INF_Neto like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'BIM') Set @Cond = @Cond + ' and c.BIM like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'DsctoFnzAf_I') Set @Cond = @Cond + ' and c.DsctoFnzAf_I like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'BIM_Neto') Set @Cond = @Cond + ' and c.BIM_Neto like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'IGV') Set @Cond = @Cond + ' and c.IGV like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'Total') Set @Cond = @Cond + ' and c.Total like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'Simbolo') Set @Cond = @Cond + ' and s.Simbolo like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'CamMda') Set @Cond = @Cond + ' and c.CamMda like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'NomFPC') Set @Cond = @Cond + ' and f.Nombre like '+''''+@D+''+@Dato+''+@I+''''
--else if(@Colum = 'Cd_TDICli') Set @Cond = @Cond + ' and e.Cd_TDI like '+''''+@D+''+@Dato+''+@I+''''
--else if(@Colum = 'NroCli') Set @Cond = @Cond + ' and e.NroCli like '+''''+@D+''+@Dato+''+@I+''''
--else if(@Colum = 'NomCli') Set @Cond = @Cond + ' and e.NomCli like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'Cd_TDIVdr') Set @Cond = @Cond + ' and v.Cd_TDI like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'NroVdr') Set @Cond = @Cond + ' and v.NDoc like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'NomVdr') Set @Cond = @Cond + ' and isnull(v.ApPat,'''')+'' ''+isnull(v.ApMat,'''')+'' ''+isnull(v.Nom,'''') like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'NCortoArea') Set @Cond = @Cond + ' and a.NCorto like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'Obs') Set @Cond = @Cond + ' and c.Obs like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'NroCotBase') Set @Cond = @Cond + ' and o.NroCot like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'FecReg') Set @Cond = @Cond + ' and Convert(nvarchar,c.FecReg,103) like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'FecMdf') Set @Cond = @Cond + ' and Convert(nvarchar,c.FecMdf,103) like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'UsuCrea') Set @Cond = @Cond + ' and c.UsuCrea like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'UsuMdf') Set @Cond = @Cond + ' and c.UsuMdf like '+''''+@D+''+@Dato+''+@I+''''
else if(@Colum = 'Estado') Set @Cond = @Cond + ' and s.Descrip like '+''''+@D+''+@Dato+''+@I+''''

print 'Cadena = '+@Cond



/*------------------------------------------------------------------------------*/
/****************************** Tablas relacionadas *****************************/
/*------------------------------------------------------------------------------*/

Declare @Tablas nvarchar(2000)
Set @Tablas  = 'Cotizacion c
		left join Moneda m on m.Cd_Mda=c.Cd_Mda
		left join FormaPC f on f.Cd_FPC=c.Cd_FPC
		left join Cliente2 e on e.RucE=c.RucE and e.Cd_Clt=c.Cd_Clt
		left join Vendedor2 v on v.RucE=c.RucE and v.Cd_Vdr=c.Cd_Vdr
		left join Area a on a.RucE=c.RucE and a.Cd_Area=c.Cd_Area
		left join Cotizacion o on o.RucE=c.RucE and o.Cd_Cot=c.CdCot_Base
		left join EstadoCot s on s.Id_EstC=c.Id_EstC
		left join CfgAutorizacion cfg on cfg.Cd_DMA = ''CT'' and cfg.tipo = c.tipAut and cfg.RucE = '''+@RucE+''' 
		join (
		select DOC as ''Cd_CTAut'' from(
		select ct.cd_cot as ''DOC'',
		case (niv) when 1 then (case (dbo.verificarAutNvl('''+@RucE+''', ct.cd_cot, 1, ib_autcomniv, 5)) when 1 then ''NO'' else ''SI'' end) 
		else ( case (dbo.verificarAutNvl('''+@RucE+''', ct.cd_cot, niv, ib_autcomniv, 5)) when 1 then ''NO'' 
		else (case (dbo.verificarAutNvl('''+@RucE+''', ct.cd_cot, niv-1, ib_autcomniv, 5)) when 1 then ''SI'' else ''NO'' end) end) end
		as ''Autoriza''
		from cotizacion ct
		join CfgAutorizacion ca on ct.RucE = ca.RucE and ca.Cd_DMA = ''CT'' and ca.Tipo = ct.TipAut 
		join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
		join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
		left join autcot act on ct.RucE = act.RucE and act.CD_cot = ct.Cd_cot and cau.nomusu = act.nomusu 
		where ct.RucE = '''+@RucE+''' and (IB_Aut is null or IB_Aut = 0) and TipAut !=0
		and cau.nomusu = '''+@usuario+''' and act.nomusu is null
	
		) as tabla 
		where Autoriza = ''SI''
		) CotAut on c.Cd_Cot = CotAut.Cd_CTAut and c.RucE = '''+@RucE+''''

/*------------------------------------------------------------------------------*/
/******************************** Datos a mostrar *******************************/
/*------------------------------------------------------------------------------*/

Declare @Consulta nvarchar(4000)
Set @Consulta = 'select  top '+Convert(nvarchar,@TamPag)+'
			c.Cd_Cot,
			c.NroCot,
			e.Cd_TDI as Cd_TDICli,e.NDoc as NroCli,isnull(e.RSocial,isnull(e.ApPat,'''')+'' ''+isnull(e.ApMat,'''')+'' ''+isnull(e.Nom,'''')) as NomCli,
			Convert(nvarchar,c.FecEmi,103) as FecEmi,
			Convert(nvarchar,c.FecCad,103) as FecCad,
			c.Asunto,
			--c.Id_EstC,
			s.Descrip as Estado,
			
			isnull(c.CostoTot,0.00) As CostoTot,
			isnull(c.Valor,0.00) As Valor,
			isnull(c.MU_Imp,0.00) As MU_Imp,
			--c.MU_Porc,
			--c.TotDsctoI,
			--c.TotDsctoP,
			isnull(c.INF,0.00) As INF,
			isnull(c.DsctoFnzInf_I,0.00) As DsctoFnzInf_I,
			--c.DsctoFnzInf_P,
			isnull(c.INF_Neto,0.00) As INF_Neto,
			isnull(c.BIM,0.00) As BIM,
			isnull(c.DsctoFnzAf_I,0.00) As DsctoFnzAf_I,
			--c.DsctoFnzAf_P,
			isnull(c.BIM_Neto,0.00) As BIM_Neto,
			isnull(c.IGV,0.00) As IGV,
			isnull(c.Total,0.00) As Total,
			
			m.Simbolo,
			 c.CamMda,
			f.Nombre as NomFPC,
			v.Cd_TDI as Cd_TDIVdr,v.NDoc as NroVdr,isnull(v.ApPat,'''')+'' ''+isnull(v.ApMat,'''')+'' ''+isnull(v.Nom,'''') as NomVdr,
			a.NCorto as NCortoArea,
			c.Obs,
			--c.CdCot_Base,
			o.NroCot as NroCotBase,
			Convert(nvarchar,c.FecReg,103) as FecReg,
			Convert(nvarchar,c.FecMdf,103) as FecMdf,
			c.UsuCrea,c.UsuMdf, isnull(c.TipAut,0) TipAut, c.AutorizadoPor, isnull(c.IB_Aut, 0) IB_Aut,
			isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip
		from '+@Tablas+' where '+@Cond+' Order by c.Cd_Cot'


Print @Consulta 
Exec (@Consulta)


/*------------------------------------------------------------------------------*/
/******************** Si es primera pagina y primera busqueda *******************/
/********************  Total de Registros y Total de paginas  *******************/
/*------------------------------------------------------------------------------*/

declare @sql nvarchar(4000)	
	
if (isnull(len(@Ult_CdCot),0)=0)
begin	
	set @sql = 'select @Regs  = count(c.Cd_Cot) from '+@Tablas+' where '+@Cond
	print @sql
	exec sp_executesql @sql,N'@Regs int output',@NroRegs output 
	select @NroPags = @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
end
	
/*----------------------------------------------------------------------------*/
/************************ Registro maximo de la pagina ************************/
/*----------------------------------------------------------------------------*/

	set @sql = 'select @Maxi = max(Cd_Cot) from (select top '+Convert(nvarchar,@TamPag)+' c.Cd_Cot from '+@Tablas+' where '+@Cond+' order by c.Cd_Cot) as CotizacionX'
	print @sql
	exec sp_executesql @sql,N'@Maxi varchar(15) output',@Max output

/*----------------------------------------------------------------------------*/
/************************ Registro minimo de la pagina ************************/
/*----------------------------------------------------------------------------*/
	
	set @sql = ' Set @Mini = ( select top 1 c.Cd_Cot from '+@Tablas+' where '+@Cond+' order by c.Cd_Cot )'
	print @sql
	exec sp_executesql @sql,N'@Mini varchar(15) output',@Min output

/*----------------------------------------------------------------------------*/
/********************************** Resultado *********************************/
/*----------------------------------------------------------------------------*/

print 'Total de numero de registros -> '+Convert(varchar,@NroRegs)
print 'Numero de paginas -> '+Convert(varchar,@NroPags)
print 'Valor maximo -> '+@Max
print 'Valor minimo -> '+@Min



--exec Inv_CotizacionCons_explo_PagSig_Aut '11111111111', '2011', '07', '07', '', '', 1, 'mmedrano', 50, '', null, null, null, null, null
GO
