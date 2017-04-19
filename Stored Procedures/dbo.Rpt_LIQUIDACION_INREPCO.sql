SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Rpt_LIQUIDACION_INREPCO]

@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
--@NroCta nvarchar(10),
@PrdoIni varchar(2),
@PrdoFin varchar(2)

as


--set @RucE= '20252619926'
--SET @EJER='2011'
Select e.Ruc,@Ejer as Ejer,e.RSocial,e.Direccion, e.Telef,udep.Nombre as DepEmpresa,upr.Nombre as ProvEmpresa,ud.Nombre as DistEmpresa
from
Empresa e
left join UDist ud on ud.Cd_UDt = e.Ubigeo
left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)
Where 
e.Ruc = @RucE 


-----ingresos ----

select /*v.NroCta,*/ 
v1.NroCta,v1.NomCta, /*p.NomCta,*/max(v.RegCtb)as RegCtb, max (v.Cd_TD) as Cd_TD,
max(v.NroSre) as NroSre,max(v.NroDoc)as NroDoc,max(v.Cd_clt)as Cd_clt,
sum(case when  v.Prdo='01'   then case when @Cd_Mda ='01'then v.MtoH else v.MtoH_ME end else 0  END )AS ENE1,
sum(case when  v.Prdo='02'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END )AS FEB1,
sum(case when  v.Prdo='03'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END )AS MAR1,
sum(case when  v.Prdo='04'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END )AS ABR1,
sum(case when  v.Prdo='05'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END )AS MAY1,
sum(case when  v.Prdo='06'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END )AS JUN1,
sum(case when  v.Prdo='07'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END )AS JUL1,
sum(case when  v.Prdo='08'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END )AS AGO1,
sum(case when  v.Prdo='09'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END  )AS SEP1,
sum(case when  v.Prdo='10'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END  )AS OCT1,
sum(case when  v.Prdo='11'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END  )AS NOV1,
sum(case when  v.Prdo='12'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end  else 0  END  )AS DIC1
from voucher as v  
left join planctas as p on v.Ejer=p.Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta 
left join (
			select v.NroCta,p.NomCta,
			max(v.RegCtb)as RegCtb, max (Cd_TD) as Cd_TD,max(NroSre) as NroSre,max(NroDoc)as NroDoc,max(Cd_clt)as Cd_clt,
			sum(case when  v.Prdo='01'   then CASE when @Cd_Mda='01' then ( v.Mtoh)else v.MtoH_ME end   else 0  END )AS ENE1,
			sum(case when  v.Prdo='02'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS FEB1,
			sum(case when  v.Prdo='03'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS MAR1,
			sum(case when  v.Prdo='04'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS ABR1,
			sum(case when  v.Prdo='05'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS MAY1,
			sum(case when  v.Prdo='06'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS JUN1,
			sum(case when  v.Prdo='07'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS JUL1,
			sum(case when  v.Prdo='08'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS AGO1,
			sum(case when  v.Prdo='09'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS SEP1,
			sum(case when  v.Prdo='10'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS OCT1,
			sum(case when  v.Prdo='11'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS NOV1,
			sum(case when  v.Prdo='12'   then case when @Cd_Mda='01'then ( v.Mtoh)else v.MtoH_ME end   else 0  END  )AS DIC1 
			from voucher v 
			left join planctas p on p.ruce=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta 
			where v.ruce=@RucE and v.Ejer=@Ejer and v.Cd_Fte='RV' and left(v.NroCta,1)='7' and v.Prdo between @PrdoIni and @PrdoFin
			group by v.NroCta  , p.NomCta   --ORDER BY v.NroCta
			)as v1 on v1.Cd_TD=v.Cd_TD and v1.NroSre=v.NroSre and v1.NroDoc=v.NroDoc and v1.Cd_Clt=v.Cd_Clt

where v.RucE=@RucE and v.Ejer=@EJER and LEFT(v.RegCtb,2)='TS' and left(p.NroCta,2)='12' and v.Prdo between @PrdoIni and @PrdoFin --and p.IB_Mdinv=0  and  p.IC_IEF='I'  
group by v.NroCta , v1.NroCta, v1.NomCta, p.NomCta   

ORDER BY v.NroCta


-----  presupuestos  --------
select * from (
select v.NroCta , p.NomCta,max(v.RegCtb)as RegCtb, max (Cd_TD) as Cd_TD,max(NroSre) as NroSre,max(NroDoc)as NroDoc,max(Cd_Prv)as Cd_Prv,
sum(case when  v.Prdo='01'   then case when @Cd_Mda ='01' then v.MtoD else v.MtoD_ME end else 0  END )AS ENE2,
sum(case when  v.Prdo='02'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS FEB2,
sum(case when  v.Prdo='03'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS MAR2,
sum(case when  v.Prdo='04'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS ABR2,
sum(case when  v.Prdo='05'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS MAY2,
sum(case when  v.Prdo='06'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS JUN2,
sum(case when  v.Prdo='07'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS JUL2,
sum(case when  v.Prdo='08'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS AGO2,
sum(case when  v.Prdo='09'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS SEP2,
sum(case when  v.Prdo='10'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS OCT2,
sum(case when  v.Prdo='11'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS NOV2,
sum(case when  v.Prdo='12'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS DIC2,
0 as IB_Psp
from voucher as v  left join planctas as p on v.Ejer=p.Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta  left join presupuesto as pr ON v.RucE=pr.RucE and v.Ejer = pr.Ejer      
 where v.RucE=@RucE and v.Ejer=@EJER and  p.IC_IEF='E'  and LEFT(RegCtb,2)='TS' and pr.NroCta<>v.NroCta and v.Prdo between @PrdoIni and @PrdoFin --and p.IB_Mdinv=0
group by v.NroCta  , p.NomCta  

union all
--    select de  presupuesto para el union ----

select pr.NroCta, p.NomCta as NomCta, '' as RegCtb, '' as Cd_TD,'' as NroSre,'' as NroDoc,'' as Cd_Prv,
sum (case when @Cd_Mda='01' then (pr.Ene)else pr.Ene_ME end) AS ENE2
,sum(case when @Cd_Mda='01' then (pr.Feb)else pr.Feb_ME end) AS FEB2
,sum(case when @Cd_Mda='01' then (pr.Mar)else pr.Mar_ME end) AS MAR2
,sum(case when @Cd_Mda='01' then (pr.Abr)else pr.Abr_ME end) AS ABR2
,sum(case when @Cd_Mda='01' then (pr.May)else pr.May_ME end) AS MAY2
,sum(case when @Cd_Mda='01' then (pr.Jun)else pr.Jun_ME end) AS JUN2
,sum(case when @Cd_Mda='01' then (pr.Jul)else pr.Jul_ME end) AS JUL2
,sum(case when @Cd_Mda='01' then (pr.Ago)else pr.Ago_ME end) AS AGO2
,sum(case when @Cd_Mda='01' then (pr.Sep)else pr.Sep_ME end) AS SEP2
,sum(case when @Cd_Mda='01' then (pr.Oct)else pr.Oct_ME end) AS OCT2
,sum(case when @Cd_Mda='01' then (pr.Nov)else pr.Nov_ME end) AS NOV2
,sum(case when @Cd_Mda='01' then (pr.Dic)else pr.Dic_ME end) AS DIC2
,1 as IB_Psp
from presupuesto  as pr  left join planctas as p on  pr.RucE=p.RucE and pr.NroCta=p.NroCta where pr.RucE=@RucE AND pr.Ejer=@EJER 
group by pr.NroCta,p.NomCta
)as v
 ORDER BY v.NroCta

-------   imprevisto----

select v.NroCta , p.NomCta as NomCta,v.Glosa as Glosa,v.FecMov,
sum(case when  v.Prdo='01'   then case when @Cd_Mda ='01' then v.MtoD else v.MtoD_ME end else 0  END )AS ENE3,
sum(case when  v.Prdo='02'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS FEB3,
sum(case when  v.Prdo='03'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS MAR3,
sum(case when  v.Prdo='04'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS ABR3,
sum(case when  v.Prdo='05'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS MAY3,
sum(case when  v.Prdo='06'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS JUN3,
sum(case when  v.Prdo='07'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS JUL3,
sum(case when  v.Prdo='08'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS AGO3,
sum(case when  v.Prdo='09'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS SEP3,
sum(case when  v.Prdo='10'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS OCT3,
sum(case when  v.Prdo='11'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS NOV3,
sum(case when  v.Prdo='12'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS DIC3
from voucher as v  left join planctas as p on v.Ejer=p.Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta where v.RucE=@RucE 
and v.Ejer=@ejer and  p.IC_IEF='E' and p.IB_Mdinv=1 and LEFT(RegCtb,2)='TS' and v.Prdo between @PrdoIni and @PrdoFin
group by v.NroCta,p.NomCta,v.FecMov,v.Glosa   ORDER BY   v.NroCta ,v.FecMov

--Creado 
--Modificado
--Fecha 
--Prueba  exec [Rpt_LIQUIDACION_INREPCO] '20252619926','2011','01','01','12'
GO
