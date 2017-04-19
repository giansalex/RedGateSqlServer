SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--
--exec [user321].[DAOT_Exportacion_Sunat] '20164486720','2011',null
create procedure [user321].[DAOT_Exportacion_Sunat_ventas]
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as
		if not exists(select top 1 *from Voucher where RucE=@RucE and Ejer=@Ejer)
			set @msj='No cuenta con movimientos de voucher'
		else
		begin
			declare @UIT int
			set @UIT=3600
			select 
	'|6|'+@RucE+'|'+@Ejer+'|'+TPer+'|'+CONVERT(nvarchar,Cd_TDI)+'|'+NDoc+'|'+
	Convert(varchar,Convert(int,Importe))+'|'+Ltrim(Rtrim(ApPat))+'|'+Ltrim(Rtrim(ApMat))+'|'+replace(rtrim(ltrim(Nom)),' ','|')+'|'+RSocial+'|' as FormatoExportacion
--t.NDoc,t.RSocial, t.Cd_Prv,t.RegCtb, Convert(varchar,FecMov,103) FecMov, '' Cd_TD,  '' NroSre, '' NroDoc, .0 IGV, .0 BIM, Importe 
from (
select t.RucE,Ejer,t.Cd_Clt,Max(t.RegCtb) RegCtb, Max(FecMov) FecMov, p2.NDoc, 
ISNULL(p2.RSocial,'') RSocial,
ISNULL(p2.ApPat,'') ApPat,
ISNULL(p2.ApMat,'') ApMat,
ISNULL(p2.Nom,'') Nom,
case (ISNULL(p2.RSocial,'')) when '' then '01' else '02' end as TPer,
CONVERT(int,MAX(p2.Cd_TDI)) Cd_TDI,
SUM(BIM_S) BIM_S,
SUM(BIM_E) BIM_E,
SUM(BIM_C) BIM_C, 
SUM(BIM_N) BIM_N,
SUM(BIM_S+BIM_E+BIM_C+BIM_N) as Importe
from (
      select  t.RucE,t.Ejer,t.RegCtb, FecMov, t.Cd_Clt,t.Cd_TD 
			, case when t.Cd_TD='07' then BIM_S2 else BIM_S1 end as BIM_S, 
			 case when t.Cd_TD='07' then BIM_E2 else BIM_E1 end as BIM_E
			, case when t.Cd_TD='07' then BIM_C2 else BIM_C1 end as BIM_C,
			 case when t.Cd_TD='07' then BIM_N2 else BIM_N1 end as BIM_N
		from(
		   select  v.RucE, v.Ejer, v.RegCtb,Max(v.FecMov) FecMov, Max(v.Cd_Clt) Cd_Clt, Max(Cd_TD) Cd_TD
			, sum(case when isnull(v.IC_TipAfec,'')='S' then v.MtoD else 0.00 end) as BIM_S1 
			, sum(case when isnull(v.IC_TipAfec,'')='S' then v.MtoH else 0.00 end) as BIM_S2
			, sum(case when isnull(v.IC_TipAfec,'')='E' then v.MtoD else 0.00 end) as BIM_E1 
			, sum(case when isnull(v.IC_TipAfec,'')='E' then v.MtoH else 0.00 end) as BIM_E2
			, sum(case when isnull(v.IC_TipAfec,'')='C' then v.MtoD else 0.00 end) as BIM_C1 
			, sum(case when isnull(v.IC_TipAfec,'')='C' then v.MtoH else 0.00 end) as BIM_C2
			, sum(case when isnull(v.IC_TipAfec,'')='N' then v.MtoD else 0.00 end) as BIM_N1 
			, sum(case when isnull(v.IC_TipAfec,'')='N' then v.MtoH else 0.00 end) as BIM_N2
			from  Voucher v
			 left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and Isnull(p.IB_CtasxPag,0)=1 where 
				v.RucE=@RucE and v.Ejer=@Ejer and RegCtb 
				in(select RegCtb from Voucher where  RucE=@RucE and Ejer=@Ejer 
				and Cd_TD not in('00','02') and ISNULL(v.Cd_Clt,'')<>'' and Cd_Fte='RV')
		     group by v.RucE,v.Ejer,v.RegCtb--,Cd_TD
			)
 as t ) as t inner join Cliente2 p2 on p2.RucE=t.RucE and p2.Cd_Clt=t.Cd_Clt
group by t.RucE, t.Ejer, t.Cd_Clt, p2.NDoc, p2.RSocial, p2.ApPat, p2.ApMat, p2.Nom
HAVING SUM(BIM_S+BIM_E+BIM_C+BIM_N)>2*@UIT
) as t
order by RSocial
		end
		
		
GO
