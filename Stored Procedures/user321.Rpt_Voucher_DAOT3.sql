SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
 
select *from voucher where ruce='20538349730' and ejer='2011' and RegCtb='CTGN_RC04-00046'
exec [user321].[Rpt_Voucher_DAOT3] '20538349730','2011',null
exec [user321].[Rpt_Voucher_DAOTRESUM1] '20538349730','2011',null
exec [user321].[Rpt_Voucher_DAOTRESUM] '20538349730','2011',null
select *from empresa where RSocial like '%MARSELLESA%'
*/

CREATE procedure [user321].[Rpt_Voucher_DAOT3]
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as

declare @UIT int
set @UIT=3600

declare @Table table
(NDoc varchar(15), RSocial nvarchar(150),
 Cd_Prv char(7), RegCtb nvarchar(15),
 FecMov nvarchar(12), Cd_TD nvarchar(2),
 NroSre nvarchar(4), NroDoc nvarchar(15),
 IGV numeric(13,2), BIM numeric(13,2),
 Importe numeric(13,2) )
insert into @Table 
select t.NDoc,t.RSocial, t.Cd_Prv,t.RegCtb, Convert(varchar,FecMov,103) FecMov, '' Cd_TD,  '' NroSre, '' NroDoc, .0 IGV, .0 BIM, Importe from (
select t.RucE,Ejer,t.Cd_Prv,Max(t.RegCtb) RegCtb, Max(FecMov) FecMov, p2.NDoc, case when ISNULL(p2.RSocial,'')='' then ISNULL(p2.ApPat,'')+' '+ISNULL(p2.ApMat,'')+' '+ISNULL(p2.Nom,'') else ISNULL(p2.RSocial,'') end as RSocial,
SUM(BIM_S) BIM_S, SUM(BIM_E) BIM_E, SUM(BIM_C) BIM_C, SUM(BIM_N) BIM_N,SUM(BIM_S+BIM_E+BIM_C+BIM_N) as Importe
from ( select  t.RucE,t.Ejer,t.RegCtb, FecMov, t.Cd_Prv,t.Cd_TD 
			, case when t.Cd_TD='07' then BIM_S2*-1 else BIM_S1 end as BIM_S, case when t.Cd_TD='07' then BIM_E2*-1 else BIM_E1 end as BIM_E
			, case when t.Cd_TD='07' then BIM_C2*-1 else BIM_C1 end as BIM_C, case when t.Cd_TD='07' then BIM_N2*-1 else BIM_N1 end as BIM_N
		from(select  v.RucE, v.Ejer, v.RegCtb,Max(v.FecMov) FecMov, Max(v.Cd_Prv) Cd_Prv, Max(Cd_TD) Cd_TD
			, sum(case when isnull(v.IC_TipAfec,'')='S' then v.MtoD else 0.00 end) as BIM_S1 , sum(case when isnull(v.IC_TipAfec,'')='S' then v.MtoH else 0.00 end) as BIM_S2
			, sum(case when isnull(v.IC_TipAfec,'')='E' then v.MtoD else 0.00 end) as BIM_E1 , sum(case when isnull(v.IC_TipAfec,'')='E' then v.MtoH else 0.00 end) as BIM_E2
			, sum(case when isnull(v.IC_TipAfec,'')='C' then v.MtoD else 0.00 end) as BIM_C1 , sum(case when isnull(v.IC_TipAfec,'')='C' then v.MtoH else 0.00 end) as BIM_C2
			, sum(case when isnull(v.IC_TipAfec,'')='N' then v.MtoD else 0.00 end) as BIM_N1 , sum(case when isnull(v.IC_TipAfec,'')='N' then v.MtoH else 0.00 end) as BIM_N2
			from  Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and Isnull(p.IB_CtasxPag,0)=1 where 
				v.RucE=@RucE and v.Ejer=@Ejer and RegCtb in(
				select RegCtb from Voucher  where  RucE=@RucE and Ejer=@Ejer and Cd_TD not in('00','02') and ISNULL(Cd_Prv,'')<>'' and Cd_Fte='RC')
		group by v.RucE,v.Ejer,v.RegCtb--,Cd_TD
) as t ) as t inner join Proveedor2 p2 on p2.RucE=t.RucE and p2.Cd_Prv=t.Cd_Prv
group by t.RucE, t.Ejer, t.Cd_Prv, p2.NDoc, p2.RSocial, p2.ApPat, p2.ApMat, p2.Nom
HAVING SUM(BIM_S+BIM_E+BIM_C+BIM_N)>2*@UIT
) as t
order by RSocial

/************************************************COMPRAS*****************************************************/
select	
		t.RucE, t.Ejer, t.RegCtb, Convert(nvarchar,t.FecMov,103) FecMov,t.Cd_Prv, p2.NDoc
		, Case when Isnull(p2.RSocial,'')='' then ISNULL(p2.ApPat,'')+' '+ISNULL(p2.ApMat,'')+' '+ISNULL(p2.Nom,'') else ISNULL(p2.RSocial,'') end as RSocial
		, t.Cd_TD,t.NroSre, t.NroDoc , Case(t.Cd_TD) When '07' Then BIM_S2 Else BIM_S1 End As BIM_S
		, Case(t.Cd_TD) When '07' Then Isnull(-1*BIM_E2,.0) Else Isnull(BIM_E1,.0) End As BIM_E ,
		 Case(t.Cd_TD) When '07' Then Isnull(-1*BIM_C2,.0) Else Isnull(BIM_C1,.0) End As BIM_C
		, Case(t.Cd_TD) When '07' Then Isnull(-1*BIM_N2,.0) Else Isnull(BIM_N1,.0) End As BIM_N
		, Case(t.Cd_TD) When '07' Then ISNULL(v.MtoH,.0) else ISNULL(v.MtoD,.0) End As IGV
from (
select v.RucE,v.Ejer, v.RegCtb, Max(v.FecMov) FecMov
	, Max(v.Cd_Prv) Cd_Prv, Max(v.Cd_TD) Cd_TD, Max(v.NroSre) NroSre, Max(v.NroDoc) NroDoc
	, SUM(Case When Isnull(v.IC_TipAfec,'')='S' then v.MtoD else 0.00 end) as BIM_S1, SUM(Case When Isnull(v.IC_TipAfec,'')='S' then v.MtoH else 0.00 end) as BIM_S2
	, SUM(Case When Isnull(v.IC_TipAfec,'')='E' then v.MtoD else 0.00 end) as BIM_E1, SUM(Case when Isnull(v.IC_TipAfec,'')='E' then v.MtoH else 0.00 end) as BIM_E2
	, SUM(Case when Isnull(v.IC_TipAfec,'')='C' then v.MtoD else 0.00 end) as BIM_C1, SUM(Case when Isnull(v.IC_TipAfec,'')='C' then v.MtoH else 0.00 end) as BIM_C2
	, SUM(Case when Isnull(v.IC_TipAfec,'')='N' then v.MtoD else 0.00 end) as BIM_N1, SUM(Case when Isnull(v.IC_TipAfec,'')='N' then v.MtoH else 0.00 end) as BIM_N2
from 
	Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and p.IB_CtasxPag=1
where 
	v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='RC'
	and v.RegCtb in (select RegCtb from  Voucher  where RucE=@RucE and Ejer=@Ejer and Cd_Prv in(select Cd_Prv from @Table))
Group By v.RucE,v.Ejer,v.RegCtb) as t inner join Proveedor2 p2 on p2.RucE=t.RucE and p2.Cd_Prv=t.Cd_Prv
left join Voucher v on v.RucE=t.RucE and v.Ejer=t.Ejer and v.RegCtb=t.RegCtb and left(v.NroCta,2)='40'
order by RSocial
/************************************************************************************************************/




declare @rpta varchar(50)
set @rpta=''

set @rpta =(
		select 'Se tiene que declarar DAOT' from (
select t.RucE,Ejer,t.Cd_Prv,Max(t.RegCtb) RegCtb, Max(FecMov) FecMov, p2.NDoc, case when ISNULL(p2.RSocial,'')='' then ISNULL(p2.ApPat,'')+' '+ISNULL(p2.ApMat,'')+' '+ISNULL(p2.Nom,'') else ISNULL(p2.RSocial,'') end as RSocial,
SUM(BIM_S) BIM_S, SUM(BIM_E) BIM_E, SUM(BIM_C) BIM_C, SUM(BIM_N) BIM_N,SUM(BIM_S+BIM_E+BIM_C+BIM_N) as Importe
from ( select  t.RucE,t.Ejer,t.RegCtb, FecMov, t.Cd_Prv,t.Cd_TD 
			, case when t.Cd_TD='07' then BIM_S2 else BIM_S1 end as BIM_S, case when t.Cd_TD='07' then BIM_E2 else BIM_E1 end as BIM_E
			, case when t.Cd_TD='07' then BIM_C2 else BIM_C1 end as BIM_C, case when t.Cd_TD='07' then BIM_N2 else BIM_N1 end as BIM_N
		from(select  v.RucE, v.Ejer, v.RegCtb,Max(v.FecMov) FecMov, Max(v.Cd_Prv) Cd_Prv, Max(Cd_TD) Cd_TD
			, sum(case when isnull(v.IC_TipAfec,'')='S' then v.MtoD else 0.00 end) as BIM_S1 , sum(case when isnull(v.IC_TipAfec,'')='S' then v.MtoH else 0.00 end) as BIM_S2
			, sum(case when isnull(v.IC_TipAfec,'')='E' then v.MtoD else 0.00 end) as BIM_E1 , sum(case when isnull(v.IC_TipAfec,'')='E' then v.MtoH else 0.00 end) as BIM_E2
			, sum(case when isnull(v.IC_TipAfec,'')='C' then v.MtoD else 0.00 end) as BIM_C1 , sum(case when isnull(v.IC_TipAfec,'')='C' then v.MtoH else 0.00 end) as BIM_C2
			, sum(case when isnull(v.IC_TipAfec,'')='N' then v.MtoD else 0.00 end) as BIM_N1 , sum(case when isnull(v.IC_TipAfec,'')='N' then v.MtoH else 0.00 end) as BIM_N2
			from  Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and Isnull(p.IB_CtasxPag,0)=1 where 
				v.RucE=@RucE and v.Ejer=@Ejer and RegCtb in(
				select RegCtb from Voucher  where  RucE=@RucE and Ejer=@Ejer and Cd_TD<>'02' and ISNULL(Cd_Prv,'')<>'' and Cd_Fte='RC')
		group by v.RucE,v.Ejer,v.RegCtb--,Cd_TD
) as t ) as t inner join Proveedor2 p2 on p2.RucE=t.RucE and p2.Cd_Prv=t.Cd_Prv
group by t.RucE, t.Ejer, t.Cd_Prv, p2.NDoc, p2.RSocial, p2.ApPat, p2.ApMat, p2.Nom
HAVING SUM(BIM_S+BIM_E+BIM_C+BIM_N)>2*@UIT
) as t
having SUM(Importe)>75*@UIT
	  	   	    )
		if(@rpta='' or @rpta is null)
	set @rpta =(select  'Se tiene que declarar DAOT' as Declarar 
					from Voucher v where RucE=@RucE and Ejer=@Ejer and v.Cd_Fte='RV' and Isnull(v.IB_Anulado,0)<>1
			    Having 
			    --Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)+
 				--Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end)>75*@UIT)
 				Sum(v.MtoD) >75*@UIT
 				)
	select @rpta Respuesta, @RucE Ruc, RSocial from Empresa Where Ruc=@RucE










---------------------------------------------venta_dettalada-------

Select max(T.RucE) as RucE,max(T.Ejer)as Ejer,t.RegCtb,t.FecMov,max(t.Cd_TD)as Cd_TD,MAX(t.NroSre) as NroSre,MAX(t.NroDoc) as NroDoc,max(t.Cd_TDI) as Cd_TDI  ,max(t.NDoc) as NDoc ,max(t.Cliente)as Cliente,max(t.MtoD)as BIM_S,max(t.CamMda)as CamMda,MAX(t.MtoD_ME) as BIM_E ,max(t.IGV) as IGV,max(t.INAFECTO) as INAFECTO,max(t.Total)as Total from (
Select t1.RucE,t1.Ejer,t1.RegCtb,t1.FecMov,t3.NroSre,t3.NroDoc,t3.MtoD,t3.MtoD_ME,
t1.Cd_TD,t1.Cd_Clt/*,t1.Cd_MdRg*/,clt.Cd_TDI
,clt.NDoc
,case when isnull(clt.RSocial,'')<>'' then clt.RSocial else clt.Nom +' '+clt.ApPat+' '+clt.ApMat end as Cliente ,t1.CamMda
,case when isnull(Cd_TD,'')<>'07' then t3.IGV   else -1*IGV end  as IGV 
,case when isnull(Cd_TD,'')<>'07' then t1.MtoD else -1*t1.MtoD end as Total
,case when isnull(Cd_TD,'')<>'07' then t1.MtoD-t3.IGV else -1*(t1.MtoD-t3.IGV) end as INAFECTO
/*,t2.Ic_TipAfec*/
---   cast(case when Cd_Mda=@Cd_Mda then  v.IGV  else case when @Cd_Mda='01'then v.IGV*v.CamMda else  v.IGV/v.CamMda end    end  as decimal(16,2)) as IGV 

from
(
	select 
	v.RucE,v.Ejer,v.RegCtb,Max(v.Cd_Clt) as Cd_Clt,v.Fecmov,v.CamMda,v.Cd_MdRg,sum(v.MtoD) as MtoD,sum(MtoD_ME) as MtoD_ME,MAX(v.Cd_TD) as Cd_TD 
	from voucher v inner join
	(
		select	RegCtb	from Voucher Where 
		RucE = @RucE 
		and Ejer = @Ejer and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
	) as t on t.RegCtb = v.RegCtb
	Where RucE = @RucE and Ejer = @Ejer and Cd_TD not in ('00','02','07')
	group by v.RucE,v.Ejer,v.RegCtb,v.Fecmov,v.CamMda,v.Cd_MdRg
) as t1
Inner join 
(
	select
	v.RegCtb,v.Ic_TipAfec,v.NroSre,v.NroDoc
	from Voucher v
	inner join 
	(
		select	RegCtb	from Voucher Where 
		RucE = @RucE 
		and Ejer = @Ejer and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
	) as t on t.RegCtb = v.RegCtb
	Where RucE = @RucE and Ejer = @Ejer and isnull(v.Ic_tipAfec,'') <>''
) as t2 on t1.RegCtb = t2.RegCtb
Left join Cliente2 clt on clt.RucE = t1.RucE and t1.Cd_Clt = clt.Cd_Clt
inner join
(

	select 
	v.RucE,v.RegCtb,
	case Max(Cd_TD) when '07'  then sum(case when LEFT(v.NroCta,2)='40' then v.MtoD else 0.0 end)
	else  sum(case when LEFT(v.NroCta,2)='40' then v.MtoH else 0.0 end)end as IGV,NroSre,NroDoc,MtoD,MtoD_ME
	from
	voucher v inner join
	(
		select	RegCtb	from Voucher Where 
		RucE = @RucE 
		and Ejer = @Ejer and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
	) as t on t.RegCtb = v.RegCtb
	Where 
	RucE = @RucE
	and Ejer = @Ejer and Cd_TD not in ('00','02','07')
	group by 
	v.RucE,v.RegCtb,NroSre,NroDoc,MtoD,MtoD_ME
) as t3 on t1.RegCtb=t3.RegCtb and t1.RucE = t3.RucE
) as t
group by t.RegCtb,t.FecMov  order by t.RegCtb,t.FecMov 


----11/04/2012   cutti-----------
GO
