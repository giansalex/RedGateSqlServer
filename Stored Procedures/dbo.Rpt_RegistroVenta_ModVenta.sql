SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RegistroVenta_ModVenta]
--declare 
@RucE nvarchar(11)
,@Ejer nvarchar(4)
,@PrdoIni nvarchar(2)
,@PrdoFin nvarchar(2)
,@Cd_Mda nvarchar(2)
,@ColOrder nvarchar(1)
,@TipOrder nvarchar(4)

as
--set @RucE = '20545551641'
--set @Ejer = '2013'
--set @PrdoIni = '01'
--set @PrdoFin = '03'
--set @Cd_Mda = '01'
--set @ColOrder = '1'
--set @TipOrder = 'desc'




declare @SqlDet1 nvarchar(4000)
declare @SqlOrder nvarchar(20)

select e.*,case when @Cd_Mda ='01' then 'Nuevos Soles' else 'Dolares Americanos' end as Moneda,@Ejer as Ejer,@PrdoIni as PrdoIni,@PrdoFin as PrdoFin from Empresa e where e.Ruc = @RucE

set @SqlDet1 = 
'
select
v.UsuCrea as NomUsu,
v.Cd_Mda,
v.IB_Anulado,
v.RegCtb 
,v.FecMov
,v.FecCbr
,v.Cd_Td
,v.NroSre
,v.NroDoc
,clt.Cd_TDI
,clt.NDoc as NDocCli
,isnull(clt.RSocial,isnull(clt.ApPat,'''')+'' ''+isnull(clt.ApMat,'''')+'' ''+isnull(clt.Nom,'''')) as Cliente
,case when v.IB_Anulado = 1 then 0 else 1 end * case when Cd_TD = ''07'' then -1 else 1 end * case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.EXPO_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.EXPO_Neto,0)*v.CamMda else isnull(v.EXPO_Neto,0) / v.CamMda end end as EXPO
,case when v.IB_Anulado = 1 then 0 else 1 end * case when Cd_TD = ''07'' then -1 else 1 end * case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.Bim_Neto,0)*v.CamMda else isnull(v.Bim_Neto,0) / v.CamMda end end as BIM --Soles
,case when v.IB_Anulado = 1 then 0 else 1 end * case when Cd_TD = ''07'' then -1 else 1 end * case when v.Cd_Mda = ''01'' then isnull(v.BIM_Neto,0)*v.CamMda else isnull(v.Bim_Neto,0) end as BIM_ME--Dolares
,case when v.IB_Anulado = 1 then 0 else 1 end * case when Cd_TD = ''07'' then -1 else 1 end * case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.EXO_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.EXO_Neto,0)*v.CamMda else isnull(v.EXO_Neto,0) / v.CamMda end end as EXO
,case when v.IB_Anulado = 1 then 0 else 1 end * case when Cd_TD = ''07'' then -1 else 1 end * case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.INF_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.INF_Neto,0)*v.CamMda else isnull(v.INF_Neto,0) / v.CamMda end end as INF
,0.0 as ISC
,case when v.IB_Anulado = 1 then 0 else 1 end * case when Cd_TD = ''07'' then -1 else 1 end * case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.IGV,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.IGV,0)*v.CamMda else isnull(v.IGV,0) / v.CamMda end end as IGV
,0.00 as Otros
,case when v.IB_Anulado = 1 then 0 else 1 end * case when Cd_TD = ''07'' then -1 else 1 end * case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.TOTAL,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.TOTAL,0)*v.CamMda else isnull(v.TOTAL,0) / v.CamMda end end as TOTAL

,v.CamMda
,v.DR_FecED
,v.DR_CdTD
,v.DR_NSre
,v.DR_NDoc
from VEnta v 
left join Cliente2 clt on clt.RucE = v.RucE and clt.Cd_Clt = v.Cd_Clt
where v.RucE = '''+@RucE+''' and v.Eje = '''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''

set @SqlOrder =' Order by '+@ColOrder+ ' '+@TipOrder

print (@SqlDet1 + @SqlOrder)
exec (@SqlDet1 + @SqlOrder)

--create <JA: 08/03/2013>
GO
