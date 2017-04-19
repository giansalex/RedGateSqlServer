SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CotizacionCons_explo]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Colum varchar(100),
@Dato varchar(100),
@msj varchar(100) output

as

Declare @Cond varchar(200)
Set @Cond = ''

if(@Colum = 'Cd_Cot') Set @Cond = ' and c.Cd_Cot like '+'''%'+@Dato+'%'''
else if(@Colum = 'NroCot') Set @Cond = ' and c.NroCot like '+'''%'+@Dato+'%'''
else if(@Colum = 'FecEmi') Set @Cond = ' and Convert(nvarchar,c.FecEmi,103) like '+'''%'+@Dato+'%'''
else if(@Colum = 'FecCad') Set @Cond = ' and Convert(nvarchar,c.FecCad,103) like '+'''%'+@Dato+'%'''
else if(@Colum = 'Asunto') Set @Cond = ' and c.Asunto like '+'%'+@Dato+'%'
else if(@Colum = 'CostoTot') Set @Cond = ' and c.CostoTot like '+'''%'+@Dato+'%'''
else if(@Colum = 'Valor') Set @Cond = ' and c.Valor like '+'''%'+@Dato+'%'''
else if(@Colum = 'MU_Imp') Set @Cond = ' and c.MU_Imp like '+'''%'+@Dato+'%'''
else if(@Colum = 'INF') Set @Cond = ' and c.INF like '+'''%'+@Dato+'%'''
else if(@Colum = 'DsctoFnzInf_I') Set @Cond = ' and c.DsctoFnzInf_I like '+'''%'+@Dato+'%'''
else if(@Colum = 'INF_Neto') Set @Cond = ' and c.INF_Neto like '+'''%'+@Dato+'%'''
else if(@Colum = 'BIM') Set @Cond = ' and c.BIM like '+'''%'+@Dato+'%'''
else if(@Colum = 'DsctoFnzAf_I') Set @Cond = ' and c.DsctoFnzAf_I like '+'''%'+@Dato+'%'''
else if(@Colum = 'BIM_Neto') Set @Cond = ' and c.BIM_Neto like '+'''%'+@Dato+'%'''
else if(@Colum = 'IGV') Set @Cond = ' and c.IGV like '+'''%'+@Dato+'%'''
else if(@Colum = 'Total') Set @Cond = ' and c.Total like '+'''%'+@Dato+'%'''
else if(@Colum = 'Simbolo') Set @Cond = ' and s.Simbolo like '+'''%'+@Dato+'%'''
else if(@Colum = 'CamMda') Set @Cond = ' and c.CamMda like '+'''%'+@Dato+'%'''
else if(@Colum = 'NomFPC') Set @Cond = ' and f.Nombre like '+'''%'+@Dato+'%'''
--else if(@Colum = 'Cd_TDICli') Set @Cond = ' and e.Cd_TDI like '+'''%'+@Dato+'%'''
--else if(@Colum = 'NroCli') Set @Cond = ' and e.NroCli like '+'''%'+@Dato+'%'''
--else if(@Colum = 'NomCli') Set @Cond = ' and e.NomCli like '+'''%'+@Dato+'%'''
else if(@Colum = 'Cd_TDIVdr') Set @Cond = ' and v.Cd_TDI like '+'''%'+@Dato+'%'''
else if(@Colum = 'NroVdr') Set @Cond = ' and v.NDoc like '+'''%'+@Dato+'%'''
else if(@Colum = 'NomVdr') Set @Cond = ' and isnull(v.ApPat,'''')+'' ''+isnull(v.ApMat,'''')+'' ''+isnull(v.Nom,'''') like '+'''%'+@Dato+'%'''
else if(@Colum = 'NCortoArea') Set @Cond = ' and a.NCorto like '+'''%'+@Dato+'%'''
else if(@Colum = 'Obs') Set @Cond = ' and c.Obs like '+'''%'+@Dato+'%'''
else if(@Colum = 'NroCotBase') Set @Cond = ' and o.NroCot like '+'''%'+@Dato+'%'''
else if(@Colum = 'FecReg') Set @Cond = ' and Convert(nvarchar,c.FecReg,103) like '+'''%'+@Dato+'%'''
else if(@Colum = 'FecMdf') Set @Cond = ' and Convert(nvarchar,c.FecMdf,103) like '+'''%'+@Dato+'%'''
else if(@Colum = 'UsuCrea') Set @Cond = ' and c.UsuCrea like '+'''%'+@Dato+'%'''
else if(@Colum = 'UsuMdf') Set @Cond = ' and c.UsuMdf like '+'''%'+@Dato+'%'''
else if(@Colum = 'Estado') Set @Cond = ' and s.Descrip like '+'''%'+@Dato+'%'''

print 'Cadena = '+@Cond

Declare @CONSULTA nvarchar(4000)
Set @CONSULTA='	select 
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
			Case(c.Cd_Mda) when ''02'' then c.CamMda else 0.000 end as CamMda,
			f.Nombre as NomFPC,
			v.Cd_TDI as Cd_TDIVdr,v.NDoc as NroVdr,isnull(v.ApPat,'''')+'' ''+isnull(v.ApMat,'''')+'' ''+isnull(v.Nom,'''') as NomVdr,
			a.NCorto as NCortoArea,
			c.Obs,
			--c.CdCot_Base,
			o.NroCot as NroCotBase,
			Convert(nvarchar,c.FecReg,103) as FecReg,
			Convert(nvarchar,c.FecMdf,103) as FecMdf,
			c.UsuCrea,c.UsuMdf
		from Cotizacion c
		left join Moneda m on m.Cd_Mda=c.Cd_Mda
		left join FormaPC f on f.Cd_FPC=c.Cd_FPC
		left join Cliente2 e on e.RucE=c.RucE and e.Cd_Clt=c.Cd_Cte
		left join Vendedor2 v on v.RucE=c.RucE and v.Cd_Vdr=c.Cd_Vdr
		left join Area a on a.RucE=c.RucE and a.Cd_Area=c.Cd_Area
		left join Cotizacion o on o.RucE=c.RucE and o.Cd_Cot=c.CdCot_Base
		left join EstadoCot s on s.Id_EstC=c.Id_EstC
		where c.RucE='''+@RucE+''' and year(c.FecEmi)='''+@Ejer+''' and Month(c.FecEmi) between convert(int,'''+@PrdoD+''') and convert(int,'''+@PrdoH+''')
	       '+@Cond
Print @CONSULTA
Exec (@CONSULTA)

-- LEYENDA --
-- DI : 16/04/2010 <Creacion del procedimiento almacenado>
GO
