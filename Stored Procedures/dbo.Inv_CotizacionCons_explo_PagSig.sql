SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionCons_explo_PagSig]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Colum varchar(100),
@Dato varchar(100),
@TipBusq int,

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

/*
Declare @RucE nvarchar(11)	Set @RucE = '11111111111'
Declare @Ejer nvarchar(4)	Set @Ejer = '2010'
Declare @PrdoD nvarchar(2)	Set @PrdoD = '04'
Declare @PrdoH nvarchar(2)	Set @PrdoH = '04'
Declare @Colum varchar(100)	Set @Colum = ''
Declare @Dato varchar(100)	Set @Dato = ''
Declare @TipBusq int		Set @TipBusq = '2'
Declare @TamPag int		Set @TamPag = '2'
Declare @Ult_CdCot int		Set @Ult_CdCot = ''

Declare @NroRegs int
Declare @NroPags int
Declare @Max varchar(100)
Declare @Min varchar(100)
*/

/*------------------------------------------------------------------------------*/
/************************* Condiciones de tipo busqueda *************************/
/*------------------------------------------------------------------------------*/

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
	Set @Cond = ' c.RucE='''+@RucE+''' and c.Cd_Cot > '''+Convert(nvarchar,@Ult_CdCot)+''''
end
else
begin
	Set @Cond = ' c.RucE='''+@RucE+''' and year(c.FecEmi)='''+@Ejer+''' and Month(c.FecEmi) between convert(int,'''+@PrdoD+''') and convert(int,'''+@PrdoH+''') and c.Cd_Cot > '''+
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

Declare @Tablas nvarchar(1000)
Set @Tablas  = 'Cotizacion c
		left join Moneda m on m.Cd_Mda=c.Cd_Mda
		left join FormaPC f on f.Cd_FPC=c.Cd_FPC
		left join Cliente2 e on e.RucE=c.RucE and e.Cd_Clt=c.Cd_Cte
		left join Vendedor2 v on v.RucE=c.RucE and v.Cd_Vdr=c.Cd_Vdr
		left join Area a on a.RucE=c.RucE and a.Cd_Area=c.Cd_Area
		left join Cotizacion o on o.RucE=c.RucE and o.Cd_Cot=c.CdCot_Base
		left join EstadoCot s on s.Id_EstC=c.Id_EstC
		left join CfgAutorizacion cfg on cfg.Cd_DMA = ''CT'' and cfg.tipo = c.tipAut and cfg.RucE = '''+@RucE+'''
	       '

/*------------------------------------------------------------------------------*/
/******************************** Datos a mostrar *******************************/
/*------------------------------------------------------------------------------*/

Declare @Consulta nvarchar(4000)
Set @Consulta = 'select  top '+Convert(nvarchar,@TamPag)+'
			c.Cd_Cot,
			c.NroCot,
			'''' as Cd_TDICli,'''' as NroCli,'''' as NomCli,
			Convert(nvarchar,c.FecEmi,103) as FecEmi,
			Convert(nvarchar,c.FecCad,103) as FecCad,
			c.Asunto,
			--c.Id_EstC,
			s.Descrip as Estado,
			c.CostoTot,
			c.Valor,
			c.MU_Imp,
			--c.MU_Porc,
			--c.TotDsctoI,
			--c.TotDsctoP,
			c.INF,
			c.DsctoFnzInf_I,
			--c.DsctoFnzInf_P,
			c.INF_Neto,
			c.BIM,
			c.DsctoFnzAf_I,
			--c.DsctoFnzAf_P,
			c.BIM_Neto,
			c.IGV,
			c.Total,
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
		from '+@Tablas+
		'where'+@Cond+ ' Order by c.RucE, c.Cd_Cot'


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

	set @sql = 'select @Maxi = max(Cd_Cot) from (select top '+Convert(nvarchar,@TamPag)+' c.Cd_Cot from '+@Tablas+' where '+@Cond+' order by c.RucE, c.Cd_Cot) as CotizacionX'
	print @sql
	exec sp_executesql @sql,N'@Maxi varchar(15) output',@Max output

/*----------------------------------------------------------------------------*/
/************************ Registro minimo de la pagina ************************/
/*----------------------------------------------------------------------------*/
	
	set @sql = ' Set @Mini = ( select top 1 c.Cd_Cot from '+@Tablas+' where '+@Cond+' order by c.RucE, c.Cd_Cot )'
	print @sql
	exec sp_executesql @sql,N'@Mini varchar(15) output',@Min output

/*----------------------------------------------------------------------------*/
/********************************** Resultado *********************************/
/*----------------------------------------------------------------------------*/

print 'Total de numero de registros -> '+Convert(varchar,@NroRegs)
print 'Numero de paginas -> '+Convert(varchar,@NroPags)
print 'Valor maximo -> '+@Max
print 'Valor minimo -> '+@Min

/********************************** LEYENDA *********************************/
-- DI : 03/05/2010 <Creacion del procedimiento almacenado>
-- DI : 26/05/2010 <Se modifico el codigo del procedimiento almacenado>




/********************************** PRUEBAS *********************************/
/*
declare @NroRegs int
declare @NroPags int
declare @Max nvarchar(15)
declare @Min nvarchar(15)
exec Inv_CotizacionCons_explo_PagSig '11111111111','2010','04','04','','',2,'2','',@NroRegs output, @NroPags output,@Max output,@Min output,null

print @NroRegs
print @NroPags
print @Max
print @Min
*/
GO
