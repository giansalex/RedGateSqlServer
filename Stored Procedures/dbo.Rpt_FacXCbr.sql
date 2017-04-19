SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Rpt_FacXCbr]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),
@NroDoc nvarchar(7),
@Cd_TD char(2),
@NroSre char(3),
@FecIni datetime,
@FecFin datetime,
@VerSaldados bit,
@Cd_Mda char(2)

as


--set @RucE = '20507826467'
--set @Ejer = '2012'
--set @Cd_Clt = ''--'CLT0000004'
--set @NroDoc = ''
--set @FecIni = '01/01/2012'
--set @FecFin = '31/10/2012'
--set @Cd_TD = ''
--set @NroSre = ''
--set @VerSaldados = 1
--set @Cd_Mda = '01'

select 
ROW_NUMBER()OVER(ORDER BY vta.NroDoc asc) AS ID,
cli.NDoc,isnull(cli.RSocial,isnull(cli.ApPat,'')+' '+isnull(cli.ApMat,'')+' '+isnull(cli.Nom,'')) as NomCli,
tip.NCorto,
vta.FecMov,
vta.FecVD,
vta.Cd_TD,
vta.NroSre,
vta.NroDoc,
vta.DR_CdTD,
vta.DR_NSre,
vta.DR_NDoc,
case when v.Cd_MdRg=01 then 'S/.' else 'US$' end as Moneda ,
Sum(v.MtoD) as aCobrar,Sum(v.MtoH) as Cobrado, 
(Sum(v.MtoD) - Sum(v.MtoH)) as Saldo, 
case when (datediff(day,vta.FecMov,getdate()) <= 30) then datediff(day,vta.FecMov,getdate()) else 0 end as [30],
case when (datediff(day,vta.FecMov,getdate()) between 31 and 60) then datediff(day,vta.FecMov,getdate()) else 0 end as [3160],
case when (datediff(day,vta.FecMov,getdate()) between 61 and 90) then datediff(day,vta.FecMov,getdate()) else 0 end as [6190],
case when (datediff(day,vta.FecMov,getdate()) > 90) then datediff(day,vta.FecMov,getdate()) else 0 end as [91]
from voucher v  
inner join planctas p on p.RucE=v.RucE and p.ejer=v.ejer and p.NroCta=v.NroCta
inner join venta vta  on vta.RucE=v.RucE and vta.eje=v.ejer and vta.NroDoc=v.NroDoc
inner join cliente2 cli  on cli.RucE=v.RucE and cli.Cd_Clt=v.Cd_Clt
inner join tipDoc tip on tip.Cd_TD=v.Cd_TD
where v.ruce = @RucE and v.ejer=@Ejer 
and case when isnull(@Cd_Clt,'') <> '' then vta.Cd_clt else '' end = isnull(@Cd_Clt,'') 
and case when isnull(@Cd_TD,'') <> '' then vta.Cd_TD else '' end = isnull(@Cd_TD,'') 
and case when isnull(@NroSre,'') <> '' then vta.NroSre  else '' end = isnull(@NroSre ,'') 
and case when isnull(@NroDoc,'') <> '' then vta.NroDoc else '' end = isnull(@NroDoc,'') 
and vta.Cd_Mda = @Cd_Mda
and vta.FecMov between @FecIni and @FecFin  
group by vta.NroDoc,vta.NroSre, v.Cd_MdRg,cli.NDoc,cli.ApPat,cli.ApMat,cli.Nom,vta.FecMov,vta.FecVD,tip.NCorto,cli.RSocial,
vta.Cd_TD,vta.DR_CdTD,vta.DR_NSre,vta.DR_NDoc
having case when @Cd_Mda='01' then (Sum(v.MtoD) - Sum(v.MtoH)) else (Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) end + @VerSaldados <> 0   
GO
