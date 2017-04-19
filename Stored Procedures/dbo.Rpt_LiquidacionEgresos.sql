SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare @PrdoI varchar(2)
--declare @PrdoF varchar(2)
--declare @RucE nvarchar(11)
--declare @Ejer varchar(4)
--set @RucE='20504743561'
--set @Ejer='2010'
--set @PrdoI='12'
--set @PrdoF='12'


CREATE PROCEDURE [dbo].[Rpt_LiquidacionEgresos]
@RucE nvarchar(11),
@Ejer varchar(4),
@PrdoI varchar(2),
@PrdoF varchar(2),
@FecI nvarchar(15),
@FecF nvarchar(15)
as
select 
	*
from (
	select sel3.*,case(ISNULL(LEN(p.RSocial),0)) when 0 then ISNULL(p.ApPat,'')+' '+ISNULL(p.Nom,'') else p.RSocial end as Proveedor from(
select '--' NroCta,'----------------------' RegCtb,'EGRESOS' titulo,null MtoD,null Prdo, null Cd_Blc,null Descrip,null Cd_Prv,null as FecED,null as FecCbr,null as NroDoc

union all 

select '--' NroCta,'----------------------',null,null,null,Cd_Rb, Descrip,null Cd_Prv,null,null,null

from(
SELECT r.Cd_Rb,Max(r.Descrip) Descrip FROM Voucher v 
	  Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
      Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF
where 
	  v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='CB'
            and v.Cd_Prv is not null 
            --and v.Prdo between @PrdoI and @PrdoF
            and v.FecMov between @FecI and @FecF
            
            and v.NroCta 
            in (
					Select NroCta from 
					(
					select v.NroCta/*,v.RegCtb,*/,v.cd_Td+v.NroSre+v.NroDoc+v.cd_prv as Clave  from voucher v
					left join(
					select * from voucher where ruce = @RucE and Ejer =@Ejer and cd_fte = 'CB') as t --and RegCtb = 'TSGE_CB05-00005'
					on v.Cd_Td =t.Cd_TD and v.NroSre = t.NroSre and v.NroDoc = t.NroDoc and v.Cd_Prv = t.Cd_Prv
					where v.ruce = @RucE and v.Ejer =@Ejer and v.cd_fte = 'rc' and v.IC_TipAfec is not null --and v.RegCtb = 'CTGE_RC05-00002'
					) as t
					where Clave is not null
				)
      group by r.Cd_Rb
      ) as sel
      
union all



select 
      NroCta,RegCtb,null Titulo, Monto, Prdo, Cb_Rb, null Descrip, Cd_Prv,FecED,FecCbr,NroDoc
from(
      SELECT 
            Max(v.RegCtb) RegCtb, Max(v.NroCta) NroCta, Max(p.Cd_EGPF) Cb_Rb, v.Cd_Prv, 
            Sum(Case When p.Cd_EGPF=r.Cd_Rb Then (Case When isnull(v.MtoH,0)=0 Then v.MtoD Else v.MtoH End) Else 0.00 End) As Monto,
            Max(v.Prdo) Prdo,
            --v.Prdo as Prdo,
			Convert(nvarchar,Max(v.FecED),103) as FecED, Convert(nvarchar,Max(v.FecCbr),103) as FecCbr,Max(v.NroDoc) NroDoc
      FROM 
            Voucher v
            Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
            Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF
      where 
            v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='CB'
            and v.Cd_Prv is not null 
            --and v.Prdo between @PrdoI and @PrdoF
            and v.FecMov between @FecI and @FecF
            and v.NroCta 
            in (
					Select NroCta from 
					(
					select v.NroCta/*,v.RegCtb,*/,v.cd_Td+v.NroSre+v.NroDoc+v.cd_prv as Clave  from voucher v
					left join(
					select * from voucher where ruce = @RucE and Ejer =@Ejer and cd_fte = 'CB') as t 
					on v.Cd_Td =t.Cd_TD and v.NroSre = t.NroSre and v.NroDoc = t.NroDoc and v.Cd_Prv = t.Cd_Prv
					where v.ruce = @RucE and v.Ejer =@Ejer and v.cd_fte = 'rc' and v.IC_TipAfec is not null 
					) as t
					where Clave is not null
				)

      group by v.Cd_Prv--,v.Prdo
)as Sel2
) as sel3
left join Proveedor2 p on p.RucE=@RucE and p.Cd_Prv=sel3.Cd_Prv


union all
/***************************totales por EF*********************************/


select null as NroCta,null as RegCtb, 'Total  '+Cb_Rb as Titulo, SUM(Monto) as MtoD, null as Prdo,Cb_Rb, null as Descrip, null as Cd_Prv, null as FecED, null as FecCbr, null as NroDoc, 'Total  '+Cb_Rb as Proveedor
from(
select 
      NroCta,RegCtb,null Titulo, Monto, Prdo, Cb_Rb, null Descrip, Cd_Prv,FecED,FecCbr,NroDoc
from(
      SELECT 
            Max(v.RegCtb) RegCtb, Max(v.NroCta) NroCta, Max(p.Cd_EGPF) Cb_Rb, v.Cd_Prv, 
            Sum(Case When p.Cd_EGPF=r.Cd_Rb Then (Case When isnull(v.MtoH,0)=0 Then v.MtoD Else v.MtoH End) Else 0.00 End) As Monto,
            Max(v.Prdo) Prdo,
            --v.Prdo as Prdo,
			Convert(nvarchar,Max(v.FecED),103) as FecED, Convert(nvarchar,Max(v.FecCbr),103) as FecCbr,Max(v.NroDoc) NroDoc
      FROM 
            Voucher v
            Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
            Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF
      where 
            v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='CB'
            and v.Cd_Prv is not null 
            --and v.Prdo between @PrdoI and @PrdoF
            and v.FecMov between @FecI and @FecF
            and v.NroCta 
            in (
					Select NroCta from 
					(
					select v.NroCta/*,v.RegCtb,*/,v.cd_Td+v.NroSre+v.NroDoc+v.cd_prv as Clave  from voucher v
					left join(
					select * from voucher where ruce = @RucE and Ejer =@Ejer and cd_fte = 'CB') as t 
					on v.Cd_Td =t.Cd_TD and v.NroSre = t.NroSre and v.NroDoc = t.NroDoc and v.Cd_Prv = t.Cd_Prv
					where v.ruce = @RucE and v.Ejer =@Ejer and v.cd_fte = 'rc' and v.IC_TipAfec is not null 
					) as t
					where Clave is not null
				)
      group by v.Cd_Prv--,v.Prdo
)as Sel2
) as Sel group by Cb_Rb






union all 



select null as NroCta,null as RegCtb, 'Total  '+Cb_Rb as Titulo, null as MtoD, null as Prdo,Cb_Rb, null as Descrip, null as Cd_Prv, null as FecED, null as FecCbr, null as NroDoc, 'Total  '+Cb_Rb as Proveedor
from(
select 
      NroCta,RegCtb,null Titulo, Monto, Prdo, Cb_Rb, null Descrip, Cd_Prv,FecED,FecCbr,NroDoc
from(
      SELECT 
            Max(v.RegCtb) RegCtb, Max(v.NroCta) NroCta, Max(p.Cd_EGPF) Cb_Rb, v.Cd_Prv, 
            Sum(Case When p.Cd_EGPF=r.Cd_Rb Then (Case When isnull(v.MtoH,0)=0 Then v.MtoD Else v.MtoH End) Else 0.00 End) As Monto,
            Max(v.Prdo) Prdo,
            --v.Prdo as Prdo,
			Convert(nvarchar,Max(v.FecED),103) as FecED, Convert(nvarchar,Max(v.FecCbr),103) as FecCbr,Max(v.NroDoc) NroDoc
      FROM 
            Voucher v
            Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
            Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF
      where 
            v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='CB'
            and v.Cd_Prv is not null 
            --and v.Prdo between @PrdoI and @PrdoF
            and v.FecMov between @FecI and @FecF
            and v.NroCta 
            in (
					Select NroCta from 
					(
					select v.NroCta/*,v.RegCtb,*/,v.cd_Td+v.NroSre+v.NroDoc+v.cd_prv as Clave  from voucher v
					left join(
					select * from voucher where ruce = @RucE and Ejer =@Ejer and cd_fte = 'CB') as t 
					on v.Cd_Td =t.Cd_TD and v.NroSre = t.NroSre and v.NroDoc = t.NroDoc and v.Cd_Prv = t.Cd_Prv
					where v.ruce = @RucE and v.Ejer =@Ejer and v.cd_fte = 'rc' and v.IC_TipAfec is not null 
					) as t
					where Clave is not null
				)
      group by v.Cd_Prv--,v.Prdo
	)as Sel2
) as Sel group by Cb_Rb) as con 
order by Cd_Blc,Descrip desc, titulo

--Creado x JA & JJ: 16/05/2011 ---
--Modificado x JA && JJ: 19/05/2011 -- Se agrego la fila totales por cada grupo
--Exec Rpt_LiquidacionEgresos  '20504743561','2011','05','05'
GO
