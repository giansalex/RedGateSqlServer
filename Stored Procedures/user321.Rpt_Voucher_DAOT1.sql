SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
exec [user321].[Rpt_Voucher_DAOT1] '20538349730','2011',null
select *from voucher where ruce='20538349730' and ejer='2011' and RegCtb='CTGN_RC06-00121'
exec [user321].[Rpt_Voucher_DAOT] '20538349730','2011',null
exec [user321].[Rpt_Voucher_DAOTRESUM1] '20538349730','2011',null
exec [user321].[Rpt_Voucher_DAOTRESUM] '20538349730','2011',null
*/

CREATE procedure [user321].[Rpt_Voucher_DAOT1]
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as

declare @UIT int
set @UIT=3600
select NDoc, RSocial, Cd_Prv, RegCtb, FecMov, Cd_TD,NroSre, NroDoc, Sum(SumBase) SumBase from (
select 
	p2.NDoc
	,case(isnull(p2.RSocial,'')) when ''  then isnull(p2.ApPat,'')+' '+isnull(p2.ApMat,'')+' '+isnull(p2.Nom,'') else Isnull(p2.RSocial,'') end as RSocial
	,v.Cd_Prv,v.RegCtb, Convert(varchar,v.FecMov,103) FecMov,v.Cd_TD,v.NroSre,v.NroDoc
	,case when Isnull(Cd_TD,'')='07' then Isnull(MtoD,0.0) else isnull(MtoH,0.0) end as SumBase
from 
	voucher v left join proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
where 
	v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='RC'
	and v.Cd_Prv in (select  Cd_Prv from (select v.RegCtb,Max(v.Cd_TD) Cd_TD,Max(v.NroSre) NroSre, Max(v.NroDoc) NroDoc,Max(v.Cd_Prv) Cd_Prv,MAX(p2.NDoc) as NDoc,
							Case when isnull(Max(p2.RSocial),'')='' then isnull(Max(p2.ApPat),'') +' '+isnull(Max(p2.ApMat),'')+' '+Isnull(Max(p2.Nom),'') else Max(p2.RSocial) end as RSocial,
							SUM(v.MtoD) MtoD,SUM(v.MtoH) MtoH
					from voucher v left join proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
					where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='RC' and Isnull(v.IB_Anulado,0)<>1
					group by v.RegCtb) as Cons
			group by Cd_Prv,NDoc,RSocial
			Having Sum(MtoD) >2*@UIT )
) as Cons
group by NDoc, RSocial, Cd_Prv, RegCtb, FecMov, Cd_TD,NroSre, NroDoc
order by NDoc desc

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
	
		set @rpta =(select  'Se tiene que declarar DAOT' as Declarar
		            from Voucher v where RucE=@RucE and Ejer=@Ejer and v.Cd_Fte='RC' and Isnull(v.IB_Anulado,0)<>1
			    Having 
			    --Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)+
	  			--Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end)>75*@UIT
	  			  Sum(v.MtoD) >75*@UIT
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
GO
