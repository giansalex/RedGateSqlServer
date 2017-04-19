SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_VtaCtasCorrientes]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni datetime,
@FecFin datetime,
@Cd_Clt nvarchar(10),
@Cd_Mda nvarchar(2),
@VerSaldado bit

--set @RucE = '20507826467'
--set @Ejer = '2012'
--set @FecIni = '01/01/2012'
--set @FecFin = '31/12/2012'
--set @Cd_Clt = 'CLT0000266'
--set @Cd_Mda = '01'
--set @VerSaldado = 0

as
select e.*,@Cd_Mda as MdaCons,'Desde '+Convert(nvarchar,@FecIni,103)+' hasta '+Convert(nvarchar,@FecIni,103) as FecCons,@Ejer as Ejer from Empresa e where Ruc = @RucE

select 
v.Cd_Clt,
max(case when v.Cd_Fte = 'RV' then v.FecMov else '' end) as FecFac,
max(case when v.Cd_Fte = 'CB' then v.FecMov else '' end) as FecCbr,
isnull(clt.RSocial,isnull(clt.ApPat,'')+' '+isnull(clt.ApMat,'')+' '+isnull(clt.Nom,'')) as Cliente,
v.Cd_TD,
v.NroSre,
v.NroDoc,
Max(v.DR_CdTD) as DR_CdTD,
Max(v.DR_NSre) as DR_NSre,
Max(v.DR_NDoc) as DR_NDoc,
case when @Cd_Mda = '01' then Sum(v.MtoD) else Sum(v.MtoD_ME) end as MtoD,
case when @Cd_Mda = '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as MtoH,
case when @Cd_Mda = '01' then Sum(v.MtoD)-sum(v.MtoH) else Sum(v.MtoD_ME)-sum(v.MtoH_ME)end as Saldo,
sum(v.MtoD_ME) as MtoD_ME, 
sum(v.MtoH_ME) as MtoH_ME,
Sum(v.MtoD_ME)-sum(v.MtoH_ME) as Saldo_ME,
case when case when @Cd_Mda = '01' then Sum(v.MtoD)-sum(v.MtoH) else Sum(v.MtoD_ME)-sum(v.MtoH_ME) end = 0 then 1 else 0 end as Saldado,
max(td.NCorto) as NCorto
from 
voucher v 
inner join 
(
select v.RucE,v.Eje,v.Cd_Clt,v.Cd_TD,v.NroSre,v.NroDoc from Venta v where v.RucE = @RucE /*and v.Eje = @Ejer*/ and v.FecMov between @FecIni and @FecFin and isnull(v.IB_Anulado,0)<>1
) as doc on doc.RucE = v.RucE and doc.Eje = v.Ejer and doc.Cd_TD = v.Cd_TD and doc.NroSre = v.NroSre and doc.NroDoc = v.NroDoc  and doc.Cd_Clt = v.Cd_Clt 
left join Cliente2 clt on clt.RucE = v.RucE and clt.Cd_Clt = v.Cd_Clt
left join TipDoc td on td.Cd_TD = doc.Cd_TD
where 
v.RucE = @RucE and v.Prdo not in ('00','13','14')--and v.Ejer = @Ejer
and case when isnull(@Cd_Clt,'')<>'' then isnull(clt.Cd_Clt,'') else '' end = isnull(@Cd_Clt,'')
and v.Cd_MdRg = @Cd_Mda
group by 
v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Clt,isnull(clt.RSocial,isnull(clt.ApPat,'')+' '+isnull(clt.ApMat,'')+' '+isnull(clt.Nom,''))
having case when @Cd_Mda = '01' then Sum(v.MtoD)-sum(v.MtoH) else Sum(v.MtoD_ME)-sum(v.MtoH_ME) end  + @VerSaldado <> 0

--<creado: JA> <08/02/2013>
--<Modificado: JA><02/04/2013> se le quito el ejercicio y los periodos 00 13 y 14
--exec Rpt_VtaCtasCorrientes '20507826467','2013','01/01/2012','31/12/2013','','01',1
GO
