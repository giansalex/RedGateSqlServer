SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
exec [user321].[Rpt_Voucher_DAOT2] '20501996140','2011',null
select *from voucher where ruce='20538349730' and ejer='2011' and RegCtb='CTGN_RC06-00121'
exec [user321].[Rpt_Voucher_DAOT] '20538349730','2011',null
exec [user321].[Rpt_Voucher_DAOTRESUM1] '20501996140','2011',null
exec [user321].[Rpt_Voucher_DAOTRESUM] '20538349730','2011',null
exec [Rpt_Voucher_DAOTRESUM2] '20538349730','2011',null
*/

CREATE procedure [dbo].[Rpt_Voucher_DAOTRESUM2]
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as

declare @UIT int
set @UIT=3650


/******************************************DAOT COMPRAS************************************************/
select t.NDoc,t.RSocial, t.Cd_Prv, Importe as Total 
		from (select t.RucE,Ejer,t.Cd_Prv,Max(t.RegCtb) RegCtb, Max(FecMov) FecMov, p2.NDoc, 
		      case when ISNULL(p2.RSocial,'')='' then ISNULL(p2.ApPat,'')+' '+ISNULL(p2.ApMat,'')+' '+ISNULL(p2.Nom,'') else ISNULL(p2.RSocial,'') 
		      end as RSocial,SUM(BIM_S) BIM_S, SUM(BIM_E) BIM_E, SUM(BIM_C) BIM_C, SUM(BIM_N) BIM_N,SUM(BIM_S+BIM_E+BIM_C+BIM_N) as Importe
					from ( select  t.RucE,t.Ejer,t.RegCtb, FecMov, t.Cd_Prv,t.Cd_TD,
					       case when t.Cd_TD='07' then -1*BIM_S2 else BIM_S1 end as BIM_S, case when t.Cd_TD='07' then -1*BIM_E2 else BIM_E1 end as BIM_E,
					       case when t.Cd_TD='07' then -1*BIM_C2 else BIM_C1 end as BIM_C, case when t.Cd_TD='07' then -1*BIM_N2 else BIM_N1 end as BIM_N
		                   from(  select  v.RucE, v.Ejer, v.RegCtb,Max(v.FecMov) FecMov, Max(v.Cd_Prv) Cd_Prv, Max(Cd_TD) Cd_TD,
			                     sum(case when isnull(v.IC_TipAfec,'')='S' then v.MtoD else 0.00 end) as BIM_S1, 
			                     sum(case when isnull(v.IC_TipAfec,'')='S' then v.MtoH else 0.00 end) as BIM_S2,
			                     sum(case when isnull(v.IC_TipAfec,'')='E' then v.MtoD else 0.00 end) as BIM_E1,
			                     sum(case when isnull(v.IC_TipAfec,'')='E' then v.MtoH else 0.00 end) as BIM_E2,
			                     sum(case when isnull(v.IC_TipAfec,'')='C' then v.MtoD else 0.00 end) as BIM_C1,
			                     sum(case when isnull(v.IC_TipAfec,'')='C' then v.MtoH else 0.00 end) as BIM_C2,
			                     sum(case when isnull(v.IC_TipAfec,'')='N' then v.MtoD else 0.00 end) as BIM_N1,
			                     sum(case when isnull(v.IC_TipAfec,'')='N' then v.MtoH else 0.00 end) as BIM_N2
                                 from Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and Isnull(p.IB_CtasxPag,0)=1
                                 where v.RucE=@RucE and v.Ejer=@Ejer and RegCtb 
                                 in(select RegCtb 
                                    from Voucher  where  RucE=@RucE and Ejer=@Ejer and Cd_TD not in ('00','02','91') and ISNULL(Cd_Prv,'')<>'' and Cd_Fte='RC')
	                        	group by v.RucE,v.Ejer,v.RegCtb--,Cd_TD
                               ) as t 
                         ) as t inner join Proveedor2 p2 on p2.RucE=t.RucE and p2.Cd_Prv=t.Cd_Prv
                           group by t.RucE, t.Ejer, t.Cd_Prv, p2.NDoc, p2.RSocial, p2.ApPat, p2.ApMat, p2.Nom
                            HAVING SUM(BIM_S+BIM_E+BIM_C+BIM_N)>2*@UIT
              ) as t
order by RSocial

/******************************************DAOT COMPRAS FIN************************************************

select*from venta
/********************************************DAOT VENTAS**************************************************/*/

select daov.Ndoc, daov.Cliente,sum(daov.BIM) as BIM, SUM(daov.IGV) as IGV ,SUM(daov.Total) as Total from 
(
Select t1.RucE,t1.RegCtb,t1.Cd_Clt,t1.FecMov,t1.CamMda,t1.Cd_MdRg,t1.Cd_TD
,case when isnull(Cd_TD,'')<>'07' then t1.MtoD-t3.IGV else -1*(t1.MtoD-t3.IGV) end as BIM
,case when isnull(Cd_TD,'')<>'07' then t3.IGV else -1*t3.IGV end as IGV
,case when isnull(Cd_TD,'')<>'07' then t1.MtoD else -1*t1.MtoD end as Total
,t2.Ic_TipAfec
,clt.NDoc
,case when isnull(clt.RSocial,'')<>'' then clt.RSocial else clt.Nom +' '+clt.ApPat+' '+clt.ApMat end as Cliente 
from
(
	select 
	v.RucE,v.RegCtb,Max(v.Cd_Clt) as Cd_Clt,v.Fecmov,v.CamMda,v.Cd_MdRg,sum(v.MtoD) as MtoD,sum(MtoD_ME) as MtoD_ME,MAX(v.Cd_TD) as Cd_TD
	from voucher v inner join
	(
		select	RegCtb	from Voucher Where 
		RucE = '20501996140' 
		and Ejer = '2012' and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
	) as t on t.RegCtb = v.RegCtb
	Where RucE = @RucE and Ejer = @Ejer 
	group by v.RucE,v.RegCtb,v.Fecmov,v.CamMda,v.Cd_MdRg
) as t1
Inner join 
(
	select
	v.RegCtb,v.Ic_TipAfec 
	from Voucher v
	inner join 
	(
		select	RegCtb	from Voucher Where 
		RucE = @RucE 
		and Ejer = @Ejer and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
	) as t on t.RegCtb = v.RegCtb
	Where RucE = @RucE and Ejer = @Ejer and isnull(v.Ic_tipAfec,'') <>''
	group by v.RegCtb,v.Ic_TipAfec 
) as t2 on t1.RegCtb = t2.RegCtb
Left join Cliente2 clt on clt.RucE = t1.RucE and t1.Cd_Clt = clt.Cd_Clt
inner join
(
	select 
	v.RucE,v.RegCtb,
	case Max(Cd_TD) when '07'  then sum(case when isnull(p.IB_IGV,0) = 1 then v.MtoD else 0.0 end)
	else  sum(case when isnull(p.IB_IGV,0) = 1 then v.MtoH else 0.0 end)end as IGV
	from
	voucher v inner join
	(
		select	RegCtb	from Voucher Where 
		RucE = @RucE 
		and Ejer = @Ejer and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
	) as t on t.RegCtb = v.RegCtb
	inner join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta
	Where 
	v.RucE = @RucE
	and v.Ejer = @Ejer 
	group by 
	v.RucE,v.RegCtb
) as t3 on t1.RegCtb=t3.RegCtb and t1.RucE = t3.RucE
) as daov
group by daov.Ndoc,daov.Cliente
having sum(daov.BIM)>2*@UIT
order by Cliente



/******************************************DAOT VENTAS FIN************************************************/

--select 	Max(p.NDoc) NDoc, case(isnull(Max(p.RSocial),'')) when '' then isnull(Max(p.ApPat),'')+' '+isnull(Max(p.ApMat),'')+', '+isnull(Max(p.Nom),'') else isnull(Max(p.RSocial),'') end as 'RSocial',
--			Max(v.Cd_Prv) Cd_Prv,v.RegCtb, Convert(nvarchar,v.FecMov,103) FecMov,
--			Max(v.Cd_TD) Cd_TD,Max(v.NroSre) NroSre ,Max(v.NroDoc) NroDoc,Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) +
--			Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)+ Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) +
--			Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end) as SumBase
--select 	
--			Max(p.NDoc) NDoc, 
--			case(isnull(Max(p.RSocial),'')) when '' then isnull(Max(p.ApPat),'')+' '+isnull(Max(p.ApMat),'')+', '+isnull(Max(p.Nom),'') else isnull(Max(p.RSocial),'') end as RSocial,
--			Max(v.Cd_Prv) Cd_Prv,
--			v.RegCtb, 
--			Convert(nvarchar,Max(v.FecMov),103) FecMov,
--			Max(v.Cd_TD) Cd_TD,
--			Max(v.NroSre) NroSre,
--			Max(v.NroDoc) NroDoc, 
--			Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)
--			+Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end) as SumBase
--		from 	
--			Voucher v left join Proveedor2 p on p.RucE=v.RucE and p.Cd_Prv=v.Cd_Prv
--		where 	
--			v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='RC'
--		group by 
--			v.RegCtb/*,v.FecMov*//*,v.Cd_TD,v.NroSre,v.NroDoc*/
--		Having	
--			Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)+
--			Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end)>2*@UIT

	declare @rpta varchar(50)
	set @rpta=''
	
		set @rpta =(
		select 'Se tiene que declarar DAOT' from (
select t.RucE,Ejer,t.Cd_Prv,Max(t.RegCtb) RegCtb, Max(FecMov) FecMov, p2.NDoc, case when ISNULL(p2.RSocial,'')='' then ISNULL(p2.ApPat,'')+' '+ISNULL(p2.ApMat,'')+' '+ISNULL(p2.Nom,'') else ISNULL(p2.RSocial,'') end as RSocial,
SUM(BIM_S) BIM_S, SUM(BIM_E) BIM_E, SUM(BIM_C) BIM_C, SUM(BIM_N) BIM_N,SUM(BIM_S+BIM_E+BIM_C+BIM_N) as Importe
from ( select  t.RucE,t.Ejer,t.RegCtb, FecMov, t.Cd_Prv,t.Cd_TD 
			, case when t.Cd_TD='07' then -1*BIM_S2 else BIM_S1 end as BIM_S, case when t.Cd_TD='07' then -1*BIM_E2 else BIM_E1 end as BIM_E
			, case when t.Cd_TD='07' then -1*BIM_C2 else BIM_C1 end as BIM_C, case when t.Cd_TD='07' then -1*BIM_N2 else BIM_N1 end as BIM_N
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
					from 
					(
						select daov.Ndoc, daov.Cliente,sum(daov.BIM) as BIM, SUM(daov.IGV) as IGV ,SUM(daov.Total) as Total from 
						(
						Select t1.RucE,t1.RegCtb,t1.Cd_Clt,t1.FecMov,t1.CamMda,t1.Cd_MdRg,t1.Cd_TD
						,case when isnull(Cd_TD,'')<>'07' then t1.MtoD-t3.IGV else -1*(t1.MtoD-t3.IGV) end as BIM
						,case when isnull(Cd_TD,'')<>'07' then t3.IGV else -1*t3.IGV end as IGV
						,case when isnull(Cd_TD,'')<>'07' then t1.MtoD else -1*t1.MtoD end as Total
						,t2.Ic_TipAfec
						,clt.NDoc
						,case when isnull(clt.RSocial,'')<>'' then clt.RSocial else clt.Nom +' '+clt.ApPat+' '+clt.ApMat end as Cliente 
						from
						(
							select 
							v.RucE,v.RegCtb,Max(v.Cd_Clt) as Cd_Clt,v.Fecmov,v.CamMda,v.Cd_MdRg,sum(v.MtoD) as MtoD,sum(MtoD_ME) as MtoD_ME,MAX(v.Cd_TD) as Cd_TD
							from voucher v inner join
							(
								select	RegCtb	from Voucher Where 
								RucE = @RucE 
								and Ejer = @Ejer and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
							) as t on t.RegCtb = v.RegCtb
							Where RucE = @RucE and Ejer = @Ejer 
							group by v.RucE,v.RegCtb,v.Fecmov,v.CamMda,v.Cd_MdRg
						) as t1
						Inner join 
						(
							select
							v.RegCtb,v.Ic_TipAfec 
							from Voucher v
							inner join 
							(
								select	RegCtb	from Voucher Where 
								RucE = @RucE 
								and Ejer = @Ejer and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
							) as t on t.RegCtb = v.RegCtb
							Where RucE = @RucE and Ejer = @Ejer and isnull(v.Ic_tipAfec,'') <>''
							group by v.RegCtb,v.Ic_TipAfec 
						) as t2 on t1.RegCtb = t2.RegCtb
						Left join Cliente2 clt on clt.RucE = t1.RucE and t1.Cd_Clt = clt.Cd_Clt
						inner join
						(
							select 
							v.RucE,v.RegCtb,
							case Max(Cd_TD) when '07'  then sum(case when isnull(p.IB_IGV,0) = 1 then v.MtoD else 0.0 end)
							else  sum(case when isnull(p.IB_IGV,0) = 1 then v.MtoH else 0.0 end)end as IGV
							from
							voucher v inner join
							(
								select	RegCtb	from Voucher Where 
								RucE = @RucE 
								and Ejer = @Ejer and Cd_Fte = 'RV' and isnull(Cd_clt,'')<>''
							) as t on t.RegCtb = v.RegCtb
							inner join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta
							Where 
							v.RucE = @RucE
							and v.Ejer = @Ejer 
							group by 
							v.RucE,v.RegCtb
						) as t3 on t1.RegCtb=t3.RegCtb and t1.RucE = t3.RucE
						) as daov
						group by daov.Ndoc,daov.Cliente
						having sum(daov.BIM)>2*@UIT
					)as t5
			    Having
 				Sum(t5.BIM)>75*@UIT
 				)
	select @rpta Respuesta, @RucE Ruc, RSocial from Empresa Where Ruc=@RucE
	
--<Creado: JJ:JA> <29/02/2012> 
--<Modificado: JA> <26/02/2013> agrege Nota de credito negativa en compras. (-1*)

GO
