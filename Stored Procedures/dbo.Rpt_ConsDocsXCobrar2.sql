SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Rpt_ConsDocsXCobrar2]

--exec Rpt_ConsDocsXCobrar2 '20522276236','2013','CLT0000030','','','','01/12/2012','31/01/2013',1,'02',null

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
Cd_TD nvarchar(2),
NroSre nvarchar(5),
DR_NDoc nvarchar(50),
Moneda nvarchar(5),
aCobrar decimal(10,4),
Cobrado decimal(10,4),
Saldo decimal(10,4)
)

insert into @Table (NDoc,NroDoc	,Cd_TD,NroSre,DR_NDoc,Moneda,aCobrar,
						Cobrado,Saldo) (

			select t1.* from ( 
								--select 
								--cli.NDoc,
								--vta.NroDoc as NroDoc,
								--isnull(vta.DR_NDoc,vta.NroDoc) as DR_NDoc,
								--case when v.Cd_MdRg='01' then 'S/.' else 'US$' end as Moneda ,
								--convert(decimal(10,4),(sum(case when @Cd_Mda = '01' then v.MtoD else v.MtoD_ME end) )) as aCobrar,
								--convert(decimal(10,4),(sum(case when @Cd_Mda = '01' then v.MtoH else v.MtoH_ME end) )) as Cobrado, 
								--convert(decimal(10,4),(Sum(case when @Cd_Mda = '01' then v.MtoD else v.MtoD_ME end) - Sum(case when @Cd_Mda = '01' then v.MtoH else v.MtoH_ME end))) as Saldo
								--from voucher v  
								--inner join venta vta  on vta.RucE=v.RucE and vta.eje=v.ejer and vta.Cd_TD = v.Cd_TD and vta.NroSre = v.NroSre and vta.NroDoc=v.NroDoc
								--inner join cliente2 cli  on cli.RucE=v.RucE and cli.Cd_Clt=v.Cd_Clt
								--inner join tipDoc tip on tip.Cd_TD=v.Cd_TD 
								--left join tipDoc tipDR on tipDR.Cd_TD = v.DR_CdTD
								--where v.ruce = @RucE --and v.ejer=@Ejer 
								----and vta.Cd_Clt in (select Cd_Clt from Cliente2 where ruce=@ruce and (isnull(RSocial,isnull(ApPat,'')+' '+isnull(ApMat,'')+' '+isnull(Nom,''))) like '%'+@Cd_Clt+'%')
								--and case when isnull(@Cd_Clt,'') <> '' then vta.Cd_Clt  else '' end = ISNULL(@Cd_Clt,'')
								--and case when isnull(@Cd_TD,'') <> '' then vta.Cd_TD else '' end = isnull(@Cd_TD,'') 
								--and case when isnull(@NroSre,'') <> '' then vta.NroSre  else '' end = isnull(@NroSre ,'') 
								--and case when isnull(@NroDoc,'') <> '' then vta.NroDoc else '' end = isnull(@NroDoc,'') 
								--and vta.Cd_Mda = @Cd_Mda and vta.FecMov between @FecIni and @FecFin
								--group by vta.NroDoc,
								--vta.DR_NDoc,cli.NDoc,tip.NCorto,v.Cd_MdRg
								--having case when @Cd_Mda='01' then (Sum(v.MtoD) - Sum(v.MtoH)) else (Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) end + @VerSaldados <> 0
								select 
								cli.NDoc,
								vta.NroDoc,
								vta.Cd_TD,
								vta.NroSre,
								isnull(vta.DR_NDoc,vta.NroDoc) as DR_NDoc,
								case when v.Cd_MdRg='01' then 'S/.' else 'US$' end as Moneda ,
								convert(decimal(10,4),(sum(case when @Cd_Mda = '01' then v.MtoD else v.MtoD_ME end) )) as aCobrar,
								convert(decimal(10,4),(sum(case when @Cd_Mda = '01' then v.MtoH else v.MtoH_ME end) )) as Cobrado, 
								convert(decimal(10,4),(Sum(case when @Cd_Mda = '01' then v.MtoD else v.MtoD_ME end) - Sum(case when @Cd_Mda = '01' then v.MtoH else v.MtoH_ME end))) as Saldo
								from voucher v  
								inner join venta vta  on vta.RucE=v.RucE and vta.eje=v.ejer and vta.Cd_TD = v.Cd_TD and vta.NroSre = v.NroSre and vta.NroDoc=v.NroDoc
								inner join cliente2 cli  on cli.RucE=v.RucE and cli.Cd_Clt=v.Cd_Clt
								inner join tipDoc tip on tip.Cd_TD=v.Cd_TD 
								left join tipDoc tipDR on tipDR.Cd_TD = v.DR_CdTD
								where v.ruce = @RucE --and v.ejer=@Ejer 
								--and vta.Cd_Clt in (select Cd_Clt from Cliente2 where ruce=@ruce and (isnull(RSocial,isnull(ApPat,'')+' '+isnull(ApMat,'')+' '+isnull(Nom,''))) like '%'+@Cd_Clt+'%')
								and case when isnull(@Cd_Clt,'') <> '' then vta.Cd_Clt  else '' end = ISNULL(@Cd_Clt,'')
								and case when isnull(@Cd_TD,'') <> '' then vta.Cd_TD else '' end = isnull(@Cd_TD,'') 
								and case when isnull(@NroSre,'') <> '' then vta.NroSre  else '' end = isnull(@NroSre ,'') 
								and case when isnull(@NroDoc,'') <> '' then vta.NroDoc else '' end = isnull(@NroDoc,'') 
								and vta.Cd_Mda = @Cd_Mda and vta.FecMov between @FecIni and @FecFin
								and vta.Cd_TD not in ('07','08')
								group by vta.NroDoc,vta.Cd_TD,
								vta.NroSre,
								vta.DR_NDoc,cli.NDoc,tip.NCorto,v.Cd_MdRg
								having case when @Cd_Mda='01' then (Sum(v.MtoD) - Sum(v.MtoH)) else (Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) end + @VerSaldados <> 0
			) as t1 
			left join voucher v on v.NroDoc = t1.DR_NDoc
			where v.ruce = @RucE /*and v.ejer=@Ejer and v.TipOper is not null*/ and v.FecMov between @FecIni and @FecFin
			group by 
			t1.NDoc,t1.NroDoc,t1.Cd_TD,t1.NroSre,t1.DR_NDoc,t1.Moneda,t1.aCobrar,t1.Cobrado,t1.Saldo                  		
		) 				
(
select * from ( 
			select 
			--ROW_NUMBER()OVER(ORDER BY vta.NroDoc asc) AS ID,
			cli.NDoc,
			isnull(cli.RSocial,isnull(cli.ApPat,'')+' '+isnull(cli.ApMat,'')+' '+isnull(cli.Nom,'')) as NomCli,
			tip.NCorto,
			vta.FecMov,
			vta.FecVD,
			vta.Cd_TD+vta.NroSre+vta.NroDoc as ID,
			case when len(isnull(vta.DR_CdTD,'')+isnull(vta.DR_NSre,'')+isnull(vta.DR_NDoc,'')) = 0 then '0' else isnull(vta.DR_CdTD,'')+isnull(vta.DR_NSre,'')+isnull(vta.DR_NDoc,'')end  as ParentID,
			vta.Cd_TD,
			vta.NroSre,
			vta.NroDoc,
			isnull(vta.DR_CdTD,''/*vta.Cd_TD*/) as DR_CdTD,
			'' as DR_NCorto,
			isnull(vta.DR_NSre,''/*vta.NroSre*/) as DR_NSre,
			isnull(vta.DR_NDoc,''/*vta.NroDoc*/) as DR_NDoc,
			case when v.Cd_MdRg=01 then 'S/.' else 'US$' end as Moneda ,
			isnull((select sum(aCobrar) from @Table where DR_NDoc = vta.NroDoc),0) as aCobrar,
			isnull((select sum(Cobrado) from @Table where DR_NDoc = vta.NroDoc),0) as Cobrado, 
			isnull(((select sum(aCobrar) from @Table where DR_NDoc = vta.NroDoc) - (select sum(Cobrado) from @Table where DR_NDoc = vta.NroDoc)),0) as Saldo, 
			case when (datediff(day,vta.FecMov,getdate()) <= 30) then datediff(day,vta.FecMov,getdate()) else 0 end as [30],
			case when (datediff(day,vta.FecMov,getdate()) between 31 and 60) then datediff(day,vta.FecMov,getdate()) else 0 end as [3160],
			case when (datediff(day,vta.FecMov,getdate()) between 61 and 90) then datediff(day,vta.FecMov,getdate()) else 0 end as [6190],
			case when (datediff(day,vta.FecMov,getdate()) > 90) then datediff(day,vta.FecMov,getdate()) else 0 end as [91]
			from voucher v  
			inner join planctas p on p.RucE=v.RucE and p.ejer=v.ejer and p.NroCta=v.NroCta
			inner join venta vta  on vta.RucE=v.RucE and vta.eje=v.ejer and vta.Cd_TD = v.Cd_TD and vta.NroSre = v.NroSre and vta.NroDoc=v.NroDoc
			inner join cliente2 cli  on cli.RucE=v.RucE and cli.Cd_Clt=v.Cd_Clt
			inner join tipDoc tip on tip.Cd_TD=v.Cd_TD
			where v.ruce = @RucE --and v.ejer=@Ejer 
			--and vta.Cd_Clt in (select Cd_Clt from Cliente2 where ruce=@ruce and (isnull(RSocial,isnull(ApPat,'')+' '+isnull(ApMat,'')+' '+isnull(Nom,''))) like '%'+@Cd_Clt+'%')
			and case when isnull(@Cd_Clt,'') = '' then '' else vta.Cd_Clt end = ISNULL(@Cd_Clt,'')
			and case when isnull(@Cd_TD,'') <> '' then vta.Cd_TD else '' end = isnull(@Cd_TD,'') 
			and case when isnull(@NroSre,'') <> '' then vta.NroSre  else '' end = isnull(@NroSre ,'') 
			and case when isnull(@NroDoc,'') <> '' then vta.NroDoc else '' end = isnull(@NroDoc,'') 
			and vta.Cd_Mda = @Cd_Mda
			and vta.FecMov between @FecIni and @FecFin
			and vta.DR_NDoc is null

			group by vta.Cd_TD,vta.NroDoc,vta.DR_NDoc,vta.NroSre,vta.DR_NSre, v.Cd_MdRg,cli.NDoc,cli.ApPat,cli.ApMat,cli.Nom,vta.FecMov,vta.FecVD,tip.NCorto,cli.RSocial,
			vta.DR_CdTD
			having case when @Cd_Mda='01' then (Sum(v.MtoD) - Sum(v.MtoH)) else (Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) end + @VerSaldados <> 0
) as t1
)
----------DETALLE-----------
union all
(
select 
					cli.NDoc,
					isnull(cli.RSocial,isnull(cli.ApPat,'')+' '+isnull(cli.ApMat,'')+' '+isnull(cli.Nom,'')) as NomCli,
					tip.NCorto,
					vta.FecMov,
					vta.FecVD,
					vta.Cd_TD+vta.NroSre+vta.NroDoc as ID,
					case when len(isnull(vta.DR_CdTD,vta.Cd_TD)+isnull(vta.DR_NSre,vta.NroSre)+isnull(vta.DR_NDoc,vta.NroDoc))= 0 then '0' else isnull(vta.DR_CdTD,vta.Cd_TD)+isnull(vta.DR_NSre,vta.NroSre)+isnull(vta.DR_NDoc,vta.NroDoc)end as ParentID,
					vta.Cd_TD as Cd_TD,
					vta.NroSre as NroSre,
					vta.NroDoc as NroDoc,
					isnull(vta.DR_CdTD,vta.Cd_TD) as DR_CdTD,
					isnull(tipDR.NCorto,tip.NCorto) as DR_NCorto,
					isnull(vta.DR_NSre,vta.NroSre) as DR_NSre,
					isnull(vta.DR_NDoc,vta.NroDoc) as DR_NDoc,
					case when v.Cd_MdRg=01 then 'S/.' else 'US$' end as Moneda ,
					Sum(case when @Cd_Mda = '01' then v.MtoD else v.MtoD_ME end) as aCobrar,
					Sum(case when @Cd_Mda = '01' then v.MtoH else v.MtoH_ME end) as Cobrado, 
					(Sum(case when @Cd_Mda = '01' then v.MtoD else v.MtoD_ME end) - Sum(case when @Cd_Mda = '01' then v.MtoH else v.MtoH_ME end)) as Saldo,
					case when (datediff(day,vta.FecMov,getdate()) <= 30) then datediff(day,vta.FecMov,getdate()) else 0 end as [30],
					case when (datediff(day,vta.FecMov,getdate()) between 31 and 60) then datediff(day,vta.FecMov,getdate()) else 0 end as [3160],
					case when (datediff(day,vta.FecMov,getdate()) between 61 and 90) then datediff(day,vta.FecMov,getdate()) else 0 end as [6190],
					case when (datediff(day,vta.FecMov,getdate()) > 90) then datediff(day,vta.FecMov,getdate()) else 0 end as [91]
					from voucher v  
					inner join venta vta  on vta.RucE=v.RucE and vta.eje=v.ejer and vta.DR_CDTD = v.DR_CDTD and vta.DR_NSre = v.DR_NSre and vta.DR_NDoc  = v.DR_NDoc  --and vta.NroDoc=v.NroDoc and vta.Cd_TD = v.Cd_TD and vta.NroSre = v.NroSre
					inner join cliente2 cli  on cli.RucE=v.RucE and cli.Cd_Clt=v.Cd_Clt
					inner join tipDoc tip on tip.Cd_TD=v.Cd_TD 
					left join tipDoc tipDR on tipDR.Cd_TD = v.DR_CdTD
					where v.ruce = @RucE
					and case when isnull(@Cd_Clt,'') = '' then '' else vta.Cd_Clt end = ISNULL(@Cd_Clt,'')
					and case when isnull(@Cd_TD,'') <> '' then cli.Cd_TDI else '' end = isnull(@Cd_TD,'') 
					and case when isnull(@NroSre,'') <> '' then vta.NroSre  else '' end = isnull(@NroSre ,'') 
					and case when isnull(@NroDoc,'') <> '' then cli.NDoc else '' end = isnull(@NroDoc,'') 
					and vta.Cd_Mda = @Cd_Mda
					and v.FecMov between @FecIni and @FecFin
					
					group by 
					cli.NDoc,
					isnull(cli.RSocial,isnull(cli.ApPat,'')+' '+isnull(cli.ApMat,'')+' '+isnull(cli.Nom,'')),
					tip.NCorto,
					vta.FecMov,
					vta.FecVD,
					vta.Cd_TD,
					vta.NroSre,
					vta.NroDoc,
					isnull(vta.DR_CdTD,vta.Cd_TD),
					isnull(tipDR.NCorto,tip.NCorto),
					isnull(vta.DR_NSre,vta.NroSre),
					isnull(vta.DR_NDoc,vta.NroDoc),
					case when v.Cd_MdRg=01 then 'S/.' else 'US$' end,
					case when (datediff(day,vta.FecMov,getdate()) <= 30) then datediff(day,vta.FecMov,getdate()) else 0 end,
					case when (datediff(day,vta.FecMov,getdate()) between 31 and 60) then datediff(day,vta.FecMov,getdate()) else 0 end,
					case when (datediff(day,vta.FecMov,getdate()) between 61 and 90) then datediff(day,vta.FecMov,getdate()) else 0 end,
					case when (datediff(day,vta.FecMov,getdate()) > 90) then datediff(day,vta.FecMov,getdate()) else 0 end
					having case when @Cd_Mda='01' then (Sum(v.MtoD) - Sum(v.MtoH)) else (Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) end + @VerSaldados <> 0
)


GO
