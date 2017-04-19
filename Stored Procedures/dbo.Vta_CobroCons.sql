SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CobroCons]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@UsuCons nvarchar(10),
@msj varchar(100) output
as

Declare @Cadena nvarchar(100)
Set @Cadena = ''
if(@UsuCons not in ('admin','diego','emer1','jesus'))
begin
	Set @Cadena = ' and c.UsuCrea='''+@UsuCons+''''
end
else

Declare @SQL nvarchar(4000)
Set @SQL = ''

Set @SQL =
	'
Select
		c.ItmCo,
		c.RegCtb,
		v.Cd_Vta as Cod_Vta,
		v.RegCtb as RegCtb_Vta,
		v.Cd_TD,
		--s.NroSerie,
		v.NroSre as NroSerie,
		v.NroDoc,
		SubString(c.RegCtb,8,2) as Prdo,
		Convert(varchar,c.FecPag,103) as FecPag,
		c.Monto,
		Case(c.Cd_Mda) when ''01'' then ''S/.'' else ''US$.'' end Moneda,
		Case(c.Cd_Mda) when ''01'' then '''' else convert(varchar,c.CamMda) end TipCamb,
		c.Itm_BC,
		b.NroCta,
		p.NomCta,
		c.NroChke,
		a.NDoc as NroVdr,
		case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end as NomVdr,
		--isnull(au.RSocial,au.ApPat+'' ''+au.ApMat+'' ''+au.Nom) as NomVdr,
		c.UsuCrea,
		c.UsuModf,
		c.FecReg,
		c.FecMdf
		
	from Cobro c
	left Join Venta v On v.RucE=c.RucE and v.Cd_Vta=c.Cd_Vta
	left Join Banco b On b.RucE=c.RucE and b.Itm_BC=c.Itm_BC
	left Join PlanCtas p On p.RucE=b.RucE and p.NroCta=b.NroCta and p.Ejer=c.Ejer
	left join Vendedor2 a on a.RucE=v.RucE and a.Cd_Vdr=v.Cd_Vdr
	--left Join Auxiliar au On au.RucE=v.RucE and au.Cd_Aux=v.Cd_Vdr
	--left Join Serie s On s.RucE=v.RucE and s.Cd_Sr=v.Cd_Sr
	where c.RucE='''+@RucE+''' and SubString(c.RegCtb,8,2) between '''+@PrdoIni+''' and '''+@PrdoFin+''' and c.Ejer='''+@Ejer+''''+@Cadena+'
	'
Print @SQL
Exec(@SQL)

--PV: Mar 26/01/2010 Mdf:  se agregaron campos de consulta NroDoc, Cd_Vta, RegCtb Vta
--DI:  Mar 276/01/2010 Mdf:  se agregaron campos de consulta Cd_TD,NroSerie
--JS : VIE 30/07/2010 Mdf : Se descomento el campo Ejer en la condicion del Where
--(antes) -> where c.RucE='''+@RucE+''' and SubString(c.RegCtb,8,2) between '''+@PrdoIni+''' and '''+@PrdoFin+'''-- and c.Ejer='''+@Ejer+''''+@Cadena+'

GO
