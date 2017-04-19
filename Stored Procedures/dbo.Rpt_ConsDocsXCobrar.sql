SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_ConsDocsXCobrar]

--exec Rpt_ConsDocsXCobrar '20507826467','2012','','09340577','01',null,'01/01/2012','18/12/2012',true,'01',null

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt nvarchar(100),
@NroDoc nvarchar(20),
@Cd_TD char(2),
@NroSre char(3),
@FecIni datetime,
@FecFin datetime,
@VerSaldados bit,
@Cd_Mda char(2),
@msj varchar(100) output

as

Declare @Table table (
						NDoc nvarchar(100),
						NroDoc nvarchar(50),
						DR_NDoc nvarchar(50),
						Moneda nvarchar(5),
						aCobrar decimal(10,2),
						Cobrado decimal(10,2),
						Saldo decimal(10,2)
						)
insert into @Table (NDoc,NroDoc,DR_NDoc,Moneda,aCobrar,
						Cobrado,Saldo) (

			select t1.* from ( 
			select 
			cli.NDoc,
			vta.NroDoc as NroDoc,
			isnull(vta.DR_NDoc,vta.NroDoc) as DR_NDoc,
			case when v.Cd_MdRg=01 then 'S/.' else 'US$' end as Moneda ,
			convert(decimal,case when tip.NCorto='NOC' then (Sum(v.MtoD) * -1) else sum(v.MtoD) end) as aCobrar,
			convert(decimal,case when tip.NCorto='NOC' then (Sum(v.MtoH) * -1) else sum(v.MtoH) end) as Cobrado, 
			convert(decimal,(Sum(v.MtoD) - Sum(v.MtoH))) as Saldo
			from voucher v  
			inner join planctas p on p.RucE=v.RucE and p.ejer=v.ejer and p.NroCta=v.NroCta
			inner join venta vta  on vta.RucE=v.RucE and vta.eje=v.ejer and vta.NroDoc=v.NroDoc
			inner join cliente2 cli  on cli.RucE=v.RucE and cli.Cd_Clt=v.Cd_Clt
			inner join tipDoc tip on tip.Cd_TD=v.Cd_TD 
			left join tipDoc tipDR on tipDR.Cd_TD = v.DR_CdTD
			where v.ruce = @RucE and v.ejer=@Ejer 
			and vta.Cd_Clt in (select Cd_Clt from Cliente2 where ruce=@ruce and (isnull(RSocial,isnull(ApPat,'')+' '+isnull(ApMat,'')+' '+isnull(Nom,''))) like '%'+@Cd_Clt+'%')
			and case when isnull(@Cd_TD,'') <> '' then cli.Cd_TDI else '' end = isnull(@Cd_TD,'') 
			and case when isnull(@NroSre,'') <> '' then vta.NroSre  else '' end = isnull(@NroSre ,'') 
			and case when isnull(@NroDoc,'') <> '' then cli.NDoc else '' end = isnull(@NroDoc,'') 
			and vta.Cd_Mda = @Cd_Mda
			group by vta.NroDoc,vta.DR_NDoc,cli.NDoc,tip.NCorto,v.Cd_MdRg
			having case when @Cd_Mda='01' then (Sum(v.MtoD) - Sum(v.MtoH)) else (Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) end + @VerSaldados <> 0
			) as t1 
			left join voucher v on v.NroDoc = t1.DR_NDoc and v.NroDoc = t1.DR_NDoc 
			where v.ruce = @RucE and v.ejer=@Ejer and v.TipOper is not null
			group by 
			t1.NDoc,t1.NroDoc,t1.DR_NDoc,t1.Moneda,t1.aCobrar,t1.Cobrado,
			t1.Saldo,v.RucE,v.Cd_Vou,v.Ejer,v.Prdo,v.RegCtb,v.Cd_Fte,v.FecMov,v.FecCbr,v.NroCta,v.Cd_Aux,v.Cd_TD,v.NroSre,v.NroDoc,v.FecED,v.FecVD,v.Glosa,v.MtoOr,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.Cd_MdOr
			,v.Cd_MdRg,v.CamMda,v.Cd_CC,v.Cd_SC,v.Cd_SS,v.Cd_Area,v.Cd_MR,v.Cd_TG,v.IC_CtrMd,v.IC_TipAfec,v.TipOper,v.NroChke,v.Grdo,v.IB_Cndo,v.IB_Conc,v.IB_EsProv,v.FecReg,v.FecMdf,v.UsuCrea,v.UsuModf,v.IB_Anulado,v.DR_CdVou,v.DR_FecED,v.DR_CdTD,v.DR_NSre,v.DR_NDoc,v.IC_Gen,v.FecConc,v.IB_EsDes
			,v.DR_NCND,v.DR_NroDet,v.DR_FecDet,v.Cd_Clt,v.Cd_Prv,v.IB_Imdo,v.CA01,v.CA02,v.Cd_TMP,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,v.CA11,v.CA12,v.CA13,v.CA14,v.CA15			
		) 


select * from ( 
select 
--ROW_NUMBER()OVER(ORDER BY vta.NroDoc asc) AS ID,
cli.NDoc,
isnull(cli.RSocial,isnull(cli.ApPat,'')+' '+isnull(cli.ApMat,'')+' '+isnull(cli.Nom,'')) as NomCli,
tip.NCorto,
vta.FecMov,
vta.FecVD,
vta.Cd_TD,
vta.NroSre,
vta.NroDoc,
isnull(vta.DR_CdTD,''/*vta.Cd_TD*/) as DR_CdTD,
'' as DR_NCorto,
isnull(vta.DR_NSre,''/*vta.NroSre*/) as DR_NSre,
isnull(vta.DR_NDoc,''/*vta.NroDoc*/) as DR_NDoc,
case when v.Cd_MdRg=01 then 'S/.' else 'US$' end as Moneda ,
isnull((select sum(aCobrar) from @table where DR_NDoc = vta.NroDoc),0) as aCobrar,
isnull((select sum(Cobrado) from @table where DR_NDoc = vta.NroDoc),0) as Cobrado, 
isnull(((select sum(aCobrar) from @table where DR_NDoc = vta.NroDoc) - (select sum(Cobrado) from @table where DR_NDoc = vta.NroDoc)),0) as Saldo, 
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
and vta.Cd_Clt in (select Cd_Clt from Cliente2 where ruce=@ruce and (isnull(RSocial,isnull(ApPat,'')+' '+isnull(ApMat,'')+' '+isnull(Nom,''))) like '%'+@Cd_Clt+'%')
and case when isnull(@Cd_TD,'') <> '' then cli.Cd_TDI else '' end = isnull(@Cd_TD,'') 
and case when isnull(@NroSre,'') <> '' then vta.NroSre  else '' end = isnull(@NroSre ,'') 
and case when isnull(@NroDoc,'') <> '' then cli.NDoc else '' end = isnull(@NroDoc,'') 
and vta.Cd_Mda = @Cd_Mda
and vta.FecMov between @FecIni and @FecFin
and vta.DR_NDoc is null

group by vta.NroDoc,vta.DR_NDoc,vta.NroSre,vta.DR_NSre, v.Cd_MdRg,cli.NDoc,cli.ApPat,cli.ApMat,cli.Nom,vta.FecMov,vta.FecVD,tip.NCorto,cli.RSocial,
vta.Cd_TD,vta.DR_CdTD
having case when @Cd_Mda='01' then (Sum(v.MtoD) - Sum(v.MtoH)) else (Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) end + @VerSaldados <> 0
) as t1
order by NDoc,Nrodoc

----------DETALLE-----------

select t1.* from ( 
select 
--ROW_NUMBER()OVER(ORDER BY vta.NroDoc asc) AS ID,
cli.NDoc,isnull(cli.RSocial,isnull(cli.ApPat,'')+' '+isnull(cli.ApMat,'')+' '+isnull(cli.Nom,'')) as NomCli,
tip.NCorto,
vta.FecMov,
vta.FecVD,
vta.Cd_TD as Cd_TD,
vta.NroSre as NroSre,
vta.NroDoc as NroDoc,
isnull(vta.DR_CdTD,vta.Cd_TD) as DR_CdTD,
isnull(tipDR.NCorto,tip.NCorto) as DR_NCorto,
isnull(vta.DR_NSre,vta.NroSre) as DR_NSre,
isnull(vta.DR_NDoc,vta.NroDoc) as DR_NDoc,
case when v.Cd_MdRg=01 then 'S/.' else 'US$' end as Moneda ,
Sum(v.MtoD) as aCobrar,
Sum(v.MtoH) as Cobrado, 
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
left join tipDoc tipDR on tipDR.Cd_TD = v.DR_CdTD
where v.ruce = @RucE and v.ejer=@Ejer 
and vta.Cd_Clt in (select Cd_Clt from Cliente2 where ruce=@ruce and (isnull(RSocial,isnull(ApPat,'')+' '+isnull(ApMat,'')+' '+isnull(Nom,''))) like '%'+@Cd_Clt+'%')
and case when isnull(@Cd_TD,'') <> '' then cli.Cd_TDI else '' end = isnull(@Cd_TD,'') 
and case when isnull(@NroSre,'') <> '' then vta.NroSre  else '' end = isnull(@NroSre ,'') 
and case when isnull(@NroDoc,'') <> '' then cli.NDoc else '' end = isnull(@NroDoc,'') 
and vta.Cd_Mda = @Cd_Mda
group by vta.NroDoc,vta.DR_NDoc,tipDR.NCorto,vta.NroSre,vta.DR_NSre, v.Cd_MdRg,cli.NDoc,
cli.ApPat,cli.ApMat,cli.Nom,vta.FecMov,vta.FecVD,tip.NCorto,cli.RSocial,
vta.Cd_TD,vta.DR_CdTD
having case when @Cd_Mda='01' then (Sum(v.MtoD) - Sum(v.MtoH)) else (Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) end + @VerSaldados <> 0
) as t1 
left join voucher v on v.NroDoc = t1.DR_NDoc and v.NroDoc = t1.DR_NDoc 
where v.ruce = @RucE and v.ejer=@Ejer and v.TipOper is not null
group by 
t1.NDoc,t1.NomCli,t1.DR_NCorto,t1.NCorto,t1.FecMov,t1.FecVD,t1.Cd_TD,t1.NroSre,t1.NroDoc,t1.DR_CdTD,t1.DR_NSre,t1.DR_NDoc,t1.Moneda,t1.aCobrar,t1.Cobrado,
t1.Saldo,t1.[30],t1.[3160],t1.[6190],t1.[91],v.RucE,v.Cd_Vou,v.Ejer,v.Prdo,v.RegCtb,v.Cd_Fte,v.FecMov,v.FecCbr,v.NroCta,v.Cd_Aux,v.Cd_TD,v.NroSre,v.NroDoc,v.FecED,v.FecVD,v.Glosa,v.MtoOr,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.Cd_MdOr
,v.Cd_MdRg,v.CamMda,v.Cd_CC,v.Cd_SC,v.Cd_SS,v.Cd_Area,v.Cd_MR,v.Cd_TG,v.IC_CtrMd,v.IC_TipAfec,v.TipOper,v.NroChke,v.Grdo,v.IB_Cndo,v.IB_Conc,v.IB_EsProv,v.FecReg,v.FecMdf,v.UsuCrea,v.UsuModf,v.IB_Anulado,v.DR_CdVou,v.DR_FecED,v.DR_CdTD,v.DR_NSre,v.DR_NDoc,v.IC_Gen,v.FecConc,v.IB_EsDes
,v.DR_NCND,v.DR_NroDet,v.DR_FecDet,v.Cd_Clt,v.Cd_Prv,v.IB_Imdo,v.CA01,v.CA02,v.Cd_TMP,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,v.CA11,v.CA12,v.CA13,v.CA14,v.CA15
order by t1.NDoc,t1.DR_NDoc,
case when t1.NroDoc = t1.DR_NDoc then 1 else 0 end desc
GO
