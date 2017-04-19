SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_LiquidacionInrepco2]

@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@FecIni datetime,--nvarchar(10),
@FecFin datetime--nvarchar(10)

as 

--------------------------------------------------***************************************------------------------------------------
Select e.Ruc,@Ejer as Ejer,e.RSocial,e.Direccion, e.Telef,udep.Nombre as DepEmpresa,upr.Nombre as ProvEmpresa,ud.Nombre as DistEmpresa
	   ,Convert(nvarchar,@FecIni,103) as FecIni ,Convert(nvarchar,@FecFin,103) as FecFin,  case @Cd_Mda  when 01 then 'S/. ' else '$/. ' END as Sim_Mda,case @Cd_Mda when 01 then 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS' END AS Nom_Mda
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
sum(case when  v.Prdo='01'   then case when @Cd_Mda='01' then v.MtoH else v.MtoH_ME end else 0  END )AS ENE1,
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
			where v.ruce=@RucE and v.Ejer=@Ejer and v.Cd_Fte='RV' and left(v.NroCta,1)='7' 
			--and v.Prdo between @PrdoIni and @PrdoFin
			and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
			group by v.NroCta  , p.NomCta   --ORDER BY v.NroCta
			)as v1 on v1.Cd_TD=v.Cd_TD and v1.NroSre=v.NroSre and v1.NroDoc=v.NroDoc and v1.Cd_Clt=v.Cd_Clt

where v.RucE=@RucE and v.Ejer=@EJER and LEFT(v.RegCtb,2)='TS' and left(p.NroCta,2)='12' 
--and v.Prdo between @PrdoIni and @PrdoFin --and p.IB_Mdinv=0  and  p.IC_IEF='I'  
and v.FecMov between @FecIni and @FecFin
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
 where v.RucE=@RucE and v.Ejer=@EJER and  p.IC_IEF='E'  and LEFT(RegCtb,2)='TS' and pr.NroCta<>v.NroCta 
 --and v.Prdo between @PrdoIni and @PrdoFin --and p.IB_Mdinv=0
 and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
group by v.NroCta  , p.NomCta  

union all
--    select de  presupuesto para el union ----

select pr.NroCta, p.NomCta as NomCta, '' as RegCtb, '' as Cd_TD,'' as NroSre,'' as NroDoc,'' as Cd_Prv,
case when Month(@FecIni)<=1 and Month(@FecFin)>=1  then sum (case when @Cd_Mda='01' then (pr.Ene)else pr.Ene_ME end) else 0 end AS ENE2,
case when Month(@FecIni)<=2 and Month(@FecFin)>=2 then sum (case when @Cd_Mda='01' then (pr.Feb)else pr.Feb_ME end) else 0 end AS FEB2,
case when Month(@FecIni)<=3 and Month(@FecFin)>=3 then sum (case when @Cd_Mda='01' then (pr.Mar)else pr.Mar_ME end) else 0 end AS MAR2,
case when Month(@FecIni)<=4 and Month(@FecFin)>=4 then sum (case when @Cd_Mda='01' then (pr.Abr)else pr.Abr_ME end) else 0 end AS ABR2,
case when Month(@FecIni)<=5 and Month(@FecFin)>=5 then sum (case when @Cd_Mda='01' then (pr.May)else pr.May_ME end) else 0 end AS MAY2,
case when Month(@FecIni)<=6 and Month(@FecFin)>=6 then sum (case when @Cd_Mda='01' then (pr.Jun)else pr.Jun_ME end) else 0 end AS JUN2,
case when Month(@FecIni)<=7 and Month(@FecFin)>=7 then sum (case when @Cd_Mda='01' then (pr.Jul)else pr.Jul_ME end) else 0 end AS JUL2,
case when Month(@FecIni)<=8 and Month(@FecFin)>=8 then sum (case when @Cd_Mda='01' then (pr.Ago)else pr.Ago_ME end) else 0 end AS AGO2,
case when Month(@FecIni)<=9 and Month(@FecFin)>=9 then sum (case when @Cd_Mda='01' then (pr.Sep)else pr.Sep_ME end) else 0 end AS SEP2,
case when Month(@FecIni)<=10 and Month(@FecFin)>=10 then sum (case when @Cd_Mda='01' then (pr.Oct)else pr.Oct_ME end) else 0 end AS OCT2,
case when Month(@FecIni)<=11 and Month(@FecFin)>=11 then sum (case when @Cd_Mda='01' then (pr.Nov)else pr.Nov_ME end) else 0 end AS NOV2,
case when Month(@FecIni)<=12 and Month(@FecFin)>=12 then sum (case when @Cd_Mda='01' then (pr.Dic)else pr.Dic_ME end) else 0 end AS DIC2
,1 as IB_Psp
from presupuesto  as pr  left join planctas as p on  pr.RucE=p.RucE and pr.NroCta=p.NroCta 
where pr.RucE=@RucE AND pr.Ejer=@EJER 
--and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
group by pr.NroCta,p.NomCta
)as v
 ORDER BY v.NroCta
-------   imprevisto----

select Max(v.NroCta) as NroCta , Max(p.NomCta) as NomCta,v.Glosa as Glosa,
sum(case when @Cd_Mda ='01' then v.MtoD else v.MtoD_ME end )as Debe
--sum(case when  v.Prdo='01'   then case when @Cd_Mda ='01' then v.MtoD else v.MtoD_ME end else 0  END )AS ENE3,
--sum(case when  v.Prdo='02'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS FEB3,
--sum(case when  v.Prdo='03'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS MAR3,
--sum(case when  v.Prdo='04'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS ABR3,
--sum(case when  v.Prdo='05'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS MAY3,
--sum(case when  v.Prdo='06'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS JUN3,
--sum(case when  v.Prdo='07'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS JUL3,
--sum(case when  v.Prdo='08'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END )AS AGO3,
--sum(case when  v.Prdo='09'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS SEP3,
--sum(case when  v.Prdo='10'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS OCT3,
--sum(case when  v.Prdo='11'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS NOV3,
--sum(case when  v.Prdo='12'   then case when @Cd_Mda='01' then v.MtoD else v.MtoD_ME end  else 0  END  )AS DIC3
from voucher as v  
left join planctas as p on v.Ejer=p.Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta where v.RucE=@RucE 
and v.Ejer=@ejer and  p.IC_IEF='E' and p.IB_Mdinv=1 and LEFT(RegCtb,2)='TS' 
--and v.Prdo between @PrdoIni and @PrdoFin
and month(v.FecMov)  = month(@FecFin)
group by v.Glosa
--ORDER BY   v.NroCta ,v.FecMov


----------cuentas por cobrar------------

select NomAux + ' ('+ Left(DateName( month , DateAdd( month , Convert(int,Min(Prdo)) , 0 ) - 1 ),3) + ' a '+ Left(DateName( month , DateAdd( month , Convert(int,MAx(Prdo)) , 0 ) - 1 ),3) + MAx(Right(Ejer,2)) + ')' as Cliente
		,sum(Saldo) as Deuda,case @Cd_Mda  when 01 then 'S/. ' else '$/. ' END as Sim_Mda,case @Cd_Mda when 01 then 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS' END AS Nom_Mda

from(
select
	isnull(c.NDoc,'') as NDoc,
	isnull(case when isnull(c.RSocial,'')<>''then c.RSocial else c.ApPat + ' ' + c.ApMat + ' ' + c.Nom end +' - '+mg.Descrip,isnull(c.RSocial,c.ApPat + ' ' + c.ApMat + ' ' + c.Nom))as Nomaux,
	v.Prdo,
	v.Ejer,
	v.NroCta As NroCta,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) Else null End) as FecED,
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) Else null End) as FecVD,
	
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	max(v.Cd_MdRg) as Cd_MdRg,
	Max(Convert(varchar,v.FecMov,103)) As FecMov
 
from Voucher v 
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	left join MantenimientoGN mg on v.RucE = mg.RucE and mg.Codigo = case when isnull(c.CA01,'')<>''then c.CA01 else c.CA02 end
Where v.RucE = @RucE /*Ruc */ and v.Ejer = @Ejer 
--and v.Prdo between  @PrdoIni and @PrdoFin
 and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
and isnull(v.Ib_Anulado,0)=0

	Group by 
	v.NroCta,
	isnull(c.NDoc,''),
	isnull(case when isnull(c.RSocial,'')<>''then c.RSocial else c.ApPat + ' ' + c.ApMat + ' ' + c.Nom end +' - '+mg.Descrip,isnull(c.RSocial,c.ApPat + ' ' + c.ApMat + ' ' + c.Nom)),
	v.Prdo,
	v.Ejer,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,'')
	,isnull(c.RSocial,'--')
	,mg.Descrip			
				

Having
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) <> 0
) as t
group by
t.NDoc,t.Nomaux


------cuentas por Pagar -------------

select NomAux + ' ('+ Left(DateName( month , DateAdd( month , Convert(int,Min(Prdo)) , 0 ) - 1 ),3) + ' a '+ Left(DateName( month , DateAdd( month , Convert(int,MAx(Prdo)) , 0 ) - 1 ),3) + MAx(Right(Ejer,2)) + ')' as Proveedor
		,sum(Saldo) as Deuda ,case @Cd_Mda  when 01 then 'S/. ' else '$/. ' END as Sim_Mda,case @Cd_Mda when 01 then 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS' END AS Nom_Mda

from(
select
	--isnull(c.NDoc,'') as NDoc,
	--isnull(case when isnull(c.RSocial,'')<>''then c.RSocial else c.ApPat + ' ' + c.ApMat + ' ' + c.Nom end +' - '+mg.Descrip,isnull(c.RSocial,c.ApPat + ' ' + c.ApMat + ' ' + c.Nom))as Nomaux,
	isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')) As NDoc,
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --'
	Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
	Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
	End End As NomAux,
	v.Prdo,
	v.Ejer,
	v.NroCta As NroCta,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) Else null End) as FecED,
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) Else null End) as FecVD,
	
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	max(v.Cd_MdRg) as Cd_MdRg,
	Max(Convert(varchar,v.FecMov,103)) As FecMov
 
from Voucher v 
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	--left join MantenimientoGN mg on v.RucE = mg.RucE and mg.Codigo = case when isnull(c.CA01,'')<>''then c.CA01 else c.CA02 end
Where v.RucE = @RucE /*Ruc */ and v.Ejer = @Ejer 
--and v.Prdo between  @PrdoIni and @PrdoFin
 and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
and isnull(v.Ib_Anulado,0)=0

	Group by 
	v.NroCta,
	isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')),
	--isnull(case when isnull(c.RSocial,'')<>''then c.RSocial else c.ApPat + ' ' + c.ApMat + ' ' + c.Nom end +' - '+mg.Descrip,isnull(c.RSocial,c.ApPat + ' ' + c.ApMat + ' ' + c.Nom)),
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --'
	Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
	Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
	End End,
	v.Prdo,
	v.Ejer,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,'')
	,isnull(c.RSocial,'--')
	--,mg.Descrip			
				

Having
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) <> 0
) as t
group by
t.NDoc,t.Nomaux





/*TOTALES DE INGRESOS - EGRESOS       C     */ --CUTTI



select 
            case(month(@FecFin)) when 1 then ENE 
                                          when 2 then FEB 
                                          when 3 then MAR 
                                          when 4 then ABR 
                                          when 5 then MAY
                                         when 6 then JUN 
                                          when 7 then JUL 
                                          when 8 then AGO 
                                          when 9 then SEP 
                                          when 10 then OCT 
                                          when 11 then NOV 
                                          when 12 then DIC 
                                          else 0 end as totalctas
from(select 
            SUM(TO_ENE1)AS ENE,
            SUM(TO_FEB1)AS FEB,
            SUM(TO_MAR1)AS MAR,
            SUM(TO_ABR1)AS ABR,
            SUM(TO_MAY1)AS MAY,
            SUM(TO_JUN1)AS JUN,
            SUM(TO_JUL1)AS JUL,
            SUM(TO_AGO1)AS AGO,
            SUM(TO_SEP1)AS SEP,
            SUM(TO_OCT1)AS OCT,
            SUM(TO_NOV1)AS NOV,
            SUM(TO_DIC1)AS DIC  
      from (select 
                  sum(ENE1)as TO_ENE1, 
                  sum(FEB1)as TO_FEB1, 
                  sum(MAR1)as TO_MAR1,
                  sum(ABR1)as TO_ABR1,
                  sum(MAY1)as TO_MAY1, 
                  sum(JUN1)as TO_JUN1, 
                  sum(JUL1)as TO_JUL1,
                  sum(AGO1)as TO_AGO1,
                  sum(SEP1)as TO_SEP1,
                  sum(OCT1)as TO_OCT1,
                  sum(NOV1)as TO_NOV1,
                  sum(DIC1) as TO_DIC1 
            from(select 
                        v1.NroCta, v1.NomCta, max(v.RegCtb)as RegCtb, max (v.Cd_TD) as Cd_TD,
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
                  from 
                        voucher as v  
                        left join planctas as p on v.Ejer=p.Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta 
                        left join (
                               select
                                         v.NroCta, p.NomCta, max(v.RegCtb)as RegCtb, max (Cd_TD) as Cd_TD,max(NroSre) as NroSre,max(NroDoc)as NroDoc,max(Cd_clt)as Cd_clt,
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
                                   from 
                                         voucher v left join planctas p on p.ruce=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta 
                                   where 
                                         v.ruce= @RucE and v.Ejer=@Ejer and v.Cd_Fte='RV' and left(v.NroCta,1)='7' 
                                         and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
                                   group by 
                                         v.NroCta, p.NomCta
                              )as v1 on v1.Cd_TD=v.Cd_TD and v1.NroSre=v.NroSre and v1.NroDoc=v.NroDoc and v1.Cd_Clt=v.Cd_Clt
                             where 
                                   v.RucE=@RucE and v.Ejer=@EJER and LEFT(v.RegCtb,2)='TS' and left(p.NroCta,2)='12'
                                   --and  p.IC_IEF='I'   
                                   and v.FecMov between @FecIni and @FecFin
                  group by 
                             v.NroCta, v1.NroCta,v1.NomCta, p.NomCta) as Ingreso
union all
-----  presupuestos  --------
select 
sum(ENE2) * -1 as TO_ENE2 ,sum(FEB2)*-1 as TO_FEB2 , sum(MAR2 )* -1 as TO_MAR2 ,sum(ABR2 )* -1 as TO_ABR2,sum(MAY2 )*-1 as TO_MAY2 , sum(JUN2 )*-1 as TO_JUN2
,sum(JUL2 )*- 1 as TO_JUL2,sum(AGO2)* -1 as TO_AGO2,sum(SEP2)* -1 as TO_SEP2 ,sum(OCT2)* -1 as TO_OCT2,sum(NOV2)* -1 as TO_NOV2,sum(DIC2)* -1 as TO_DIC2 from(
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
 where v.RucE=@RucE and v.Ejer=@EJER and  p.IC_IEF='E'  and LEFT(RegCtb,2)='TS' and pr.NroCta<>v.NroCta 
 --and v.Prdo between @PrdoIni and @PrdoFin --and p.IB_Mdinv=0
and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
group by v.NroCta  , p.NomCta  

union all
--    select de  presupuesto para el union ----

select pr.NroCta, p.NomCta as NomCta, '' as RegCtb, '' as Cd_TD,'' as NroSre,'' as NroDoc,'' as Cd_Prv,
case when Month(@FecIni)<=1 and Month(@FecFin)>=1  then sum (case when @Cd_Mda='01' then (pr.Ene)else pr.Ene_ME end) else 0 end AS ENE2,
case when Month(@FecIni)<=2 and Month(@FecFin)>=2 then sum (case when @Cd_Mda='01' then (pr.Feb)else pr.Feb_ME end) else 0 end AS FEB2,
case when Month(@FecIni)<=3 and Month(@FecFin)>=3 then sum (case when @Cd_Mda='01' then (pr.Mar)else pr.Mar_ME end) else 0 end AS MAR2,
case when Month(@FecIni)<=4 and Month(@FecFin)>=4 then sum (case when @Cd_Mda='01' then (pr.Abr)else pr.Abr_ME end) else 0 end AS ABR2,
case when Month(@FecIni)<=5 and Month(@FecFin)>=5 then sum (case when @Cd_Mda='01' then (pr.May)else pr.May_ME end) else 0 end AS MAY2,
case when Month(@FecIni)<=6 and Month(@FecFin)>=6 then sum (case when @Cd_Mda='01' then (pr.Jun)else pr.Jun_ME end) else 0 end AS JUN2,
case when Month(@FecIni)<=7 and Month(@FecFin)>=7 then sum (case when @Cd_Mda='01' then (pr.Jul)else pr.Jul_ME end) else 0 end AS JUL2,
case when Month(@FecIni)<=8 and Month(@FecFin)>=8 then sum (case when @Cd_Mda='01' then (pr.Ago)else pr.Ago_ME end) else 0 end AS AGO2,
case when Month(@FecIni)<=9 and Month(@FecFin)>=9 then sum (case when @Cd_Mda='01' then (pr.Sep)else pr.Sep_ME end) else 0 end AS SEP2,
case when Month(@FecIni)<=10 and Month(@FecFin)>=10 then sum (case when @Cd_Mda='01' then (pr.Oct)else pr.Oct_ME end) else 0 end AS OCT2,
case when Month(@FecIni)<=11 and Month(@FecFin)>=11 then sum (case when @Cd_Mda='01' then (pr.Nov)else pr.Nov_ME end) else 0 end AS NOV2,
case when Month(@FecIni)<=12 and Month(@FecFin)>=12 then sum (case when @Cd_Mda='01' then (pr.Dic)else pr.Dic_ME end) else 0 end AS DIC2
,1 as IB_Psp
from presupuesto  as pr  left join planctas as p on  pr.RucE=p.RucE and pr.NroCta=p.NroCta 
where pr.RucE=@RucE AND pr.Ejer=@EJER 
--and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
group by pr.NroCta,p.NomCta)as v )as PRESUPUESTO      ) as TOTALES
--ORDER BY v.NroCta
) as fin


/* TOTAL DE CUENTA DE ESTADO */


-------------------------------------------------------*******suma de totales *****------------------------------------------
select 
            SUM(TO_ENE1)AS ENE,
            SUM(TO_FEB1)AS FEB,
            SUM(TO_MAR1)AS MAR,
            SUM(TO_ABR1)AS ABR,
            SUM(TO_MAY1)AS MAY,
            SUM(TO_JUN1)AS JUN,
            SUM(TO_JUL1)AS JUL,
            SUM(TO_AGO1)AS AGO,
            SUM(TO_SEP1)AS SEP,
            SUM(TO_OCT1)AS OCT,
            SUM(TO_NOV1)AS NOV,
            SUM(TO_DIC1)AS DIC  
      from (
      select 
                  sum(ENE1)as TO_ENE1, 
                  sum(FEB1)as TO_FEB1, 
                  sum(MAR1)as TO_MAR1,
                  sum(ABR1)as TO_ABR1,
                  sum(MAY1)as TO_MAY1, 
                  sum(JUN1)as TO_JUN1, 
                  sum(JUL1)as TO_JUL1,
                  sum(AGO1)as TO_AGO1,
                  sum(SEP1)as TO_SEP1,
                  sum(OCT1)as TO_OCT1,
                  sum(NOV1)as TO_NOV1,
                  sum(DIC1) as TO_DIC1 
            from(select 
                        v1.NroCta, v1.NomCta, max(v.RegCtb)as RegCtb, max (v.Cd_TD) as Cd_TD,
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
                  from 
                        voucher as v  
                        left join planctas as p on v.Ejer=p.Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta 
                        left join (
                               select
                                         v.NroCta, p.NomCta, max(v.RegCtb)as RegCtb, max (Cd_TD) as Cd_TD,max(NroSre) as NroSre,max(NroDoc)as NroDoc,max(Cd_clt)as Cd_clt,
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
                                   from 
                                         voucher v left join planctas p on p.ruce=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta 
                                   where 
                                         v.ruce= @RucE and v.Ejer=@Ejer and v.Cd_Fte='RV' and left(v.NroCta,1)='7' 
                                         and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
                                   group by 
                                         v.NroCta, p.NomCta
                              )as v1 on v1.Cd_TD=v.Cd_TD and v1.NroSre=v.NroSre and v1.NroDoc=v.NroDoc and v1.Cd_Clt=v.Cd_Clt
                             where 
                                   v.RucE=@RucE and v.Ejer=@EJER and LEFT(v.RegCtb,2)='TS' and left(p.NroCta,2)='12'
                                   --and  p.IC_IEF='I'   
                                   and v.FecMov between @FecIni and @FecFin
                  group by 
                             v.NroCta, v1.NroCta,v1.NomCta, p.NomCta) as Ingreso
union all
-----  presupuestos  --------
select 
sum(ENE2)* -1  as TO_ENE2 ,sum(FEB2)* -1 as TO_FEB2 , sum(MAR2 )* -1 as TO_MAR2 ,sum(ABR2 )* -1 as TO_ABR2,sum(MAY2 )* -1 as TO_MAY2 , sum(JUN2 )* -1 as TO_JUN2
,sum(JUL2 )* -1 as TO_JUL2,sum(AGO2)* -1 as TO_AGO2,sum(SEP2)* -1 as TO_SEP2 ,sum(OCT2)* -1 as TO_OCT2,sum(NOV2)* -1 as TO_NOV2,sum(DIC2)* -1 as TO_DIC2 from(
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
 where v.RucE=@RucE and v.Ejer=@EJER and  p.IC_IEF='E'  and LEFT(RegCtb,2)='TS' and pr.NroCta<>v.NroCta 
 --and v.Prdo between @PrdoIni and @PrdoFin --and p.IB_Mdinv=0
and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
group by v.NroCta  , p.NomCta  

union all
--    select de  presupuesto para el union ----

select pr.NroCta, p.NomCta as NomCta, '' as RegCtb, '' as Cd_TD,'' as NroSre,'' as NroDoc,'' as Cd_Prv,
case when Month(@FecIni)<=1 and Month(@FecFin)>=1  then sum (case when @Cd_Mda='01' then (pr.Ene)else pr.Ene_ME end) else 0 end AS ENE2,
case when Month(@FecIni)<=2 and Month(@FecFin)>=2 then sum (case when @Cd_Mda='01' then (pr.Feb)else pr.Feb_ME end) else 0 end AS FEB2,
case when Month(@FecIni)<=3 and Month(@FecFin)>=3 then sum (case when @Cd_Mda='01' then (pr.Mar)else pr.Mar_ME end) else 0 end AS MAR2,
case when Month(@FecIni)<=4 and Month(@FecFin)>=4 then sum (case when @Cd_Mda='01' then (pr.Abr)else pr.Abr_ME end) else 0 end AS ABR2,
case when Month(@FecIni)<=5 and Month(@FecFin)>=5 then sum (case when @Cd_Mda='01' then (pr.May)else pr.May_ME end) else 0 end AS MAY2,
case when Month(@FecIni)<=6 and Month(@FecFin)>=6 then sum (case when @Cd_Mda='01' then (pr.Jun)else pr.Jun_ME end) else 0 end AS JUN2,
case when Month(@FecIni)<=7 and Month(@FecFin)>=7 then sum (case when @Cd_Mda='01' then (pr.Jul)else pr.Jul_ME end) else 0 end AS JUL2,
case when Month(@FecIni)<=8 and Month(@FecFin)>=8 then sum (case when @Cd_Mda='01' then (pr.Ago)else pr.Ago_ME end) else 0 end AS AGO2,
case when Month(@FecIni)<=9 and Month(@FecFin)>=9 then sum (case when @Cd_Mda='01' then (pr.Sep)else pr.Sep_ME end) else 0 end AS SEP2,
case when Month(@FecIni)<=10 and Month(@FecFin)>=10 then sum (case when @Cd_Mda='01' then (pr.Oct)else pr.Oct_ME end) else 0 end AS OCT2,
case when Month(@FecIni)<=11 and Month(@FecFin)>=11 then sum (case when @Cd_Mda='01' then (pr.Nov)else pr.Nov_ME end) else 0 end AS NOV2,
case when Month(@FecIni)<=12 and Month(@FecFin)>=12 then sum (case when @Cd_Mda='01' then (pr.Dic)else pr.Dic_ME end) else 0 end AS DIC2
,1 as IB_Psp
from presupuesto  as pr  left join planctas as p on  pr.RucE=p.RucE and pr.NroCta=p.NroCta 
where pr.RucE=@RucE AND pr.Ejer=@EJER 
--and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
group by pr.NroCta,p.NomCta)as v )as PRESUPUESTO   )   as TOTALES
--ORDER BY v.NroCta
----------------------------------------------------------------------------------------------------







select SUM(deuda)as SumCliente,SUM(rr.SumProveedor)as SumProveedor, MAx(rr.RucE) as RucE1 from(
select RucE, NomAux + ' ('+ Left(DateName( month , DateAdd( month , Convert(int,Min(Prdo)) , 0 ) - 1 ),3) + ' a '+ Left(DateName( month , DateAdd( month , Convert(int,MAx(Prdo)) , 0 ) - 1 ),3) + MAx(Right(Ejer,2)) + ')' as Cliente
		,sum(Saldo) as Deuda,case @Cd_Mda  when 01 then 'S/. ' else '$/. ' END as Sim_Mda,case @Cd_Mda when 01 then 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS' END AS Nom_Mda

from(
select
	v.RucE,
	isnull(c.NDoc,'') as NDoc,
	isnull(case when isnull(c.RSocial,'')<>''then c.RSocial else c.ApPat + ' ' + c.ApMat + ' ' + c.Nom end +' - '+mg.Descrip,isnull(c.RSocial,c.ApPat + ' ' + c.ApMat + ' ' + c.Nom))as Nomaux,
	v.Prdo,
	v.Ejer,
	v.NroCta As NroCta,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) Else null End) as FecED,
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) Else null End) as FecVD,
	
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	max(v.Cd_MdRg) as Cd_MdRg,
	Max(Convert(varchar,v.FecMov,103)) As FecMov
 
from Voucher v 
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	left join MantenimientoGN mg on v.RucE = mg.RucE and mg.Codigo = case when isnull(c.CA01,'')<>''then c.CA01 else c.CA02 end
Where v.RucE = @RucE /*Ruc */ and v.Ejer = @Ejer 
--and v.Prdo between  @PrdoIni and @PrdoFin
 and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
and isnull(v.Ib_Anulado,0)=0

	Group by 
	v.RucE,
	v.NroCta,
	isnull(c.NDoc,''),
	isnull(case when isnull(c.RSocial,'')<>''then c.RSocial else c.ApPat + ' ' + c.ApMat + ' ' + c.Nom end +' - '+mg.Descrip,isnull(c.RSocial,c.ApPat + ' ' + c.ApMat + ' ' + c.Nom)),
	v.Prdo,
	v.Ejer,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,'')
	,isnull(c.RSocial,'--')
	,mg.Descrip			
				

Having
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) <> 0
) as t
group by
RucE,t.NDoc,t.Nomaux) as t1

left join (
------ TOTALES DE PROVEEDORES -------------
select SUM(deuda) as SumProveedor, MAX(RucE) as RucE from(
select RucE,NomAux + ' ('+ Left(DateName( month , DateAdd( month , Convert(int,Min(Prdo)) , 0 ) - 1 ),3) + ' a '+ Left(DateName( month , DateAdd( month , Convert(int,MAx(Prdo)) , 0 ) - 1 ),3) + MAx(Right(Ejer,2)) + ')' as Proveedor
		,sum(Saldo) as Deuda ,case @Cd_Mda  when 01 then 'S/. ' else '$/. ' END as Sim_Mda,case @Cd_Mda when 01 then 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS' END AS Nom_Mda

from(
select
	v.RucE,
	--isnull(c.NDoc,'') as NDoc,
	--isnull(case when isnull(c.RSocial,'')<>''then c.RSocial else c.ApPat + ' ' + c.ApMat + ' ' + c.Nom end +' - '+mg.Descrip,isnull(c.RSocial,c.ApPat + ' ' + c.ApMat + ' ' + c.Nom))as Nomaux,
	isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')) As NDoc,
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --'
	Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
	Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
	End End As NomAux,
	v.Prdo,
	v.Ejer,
	v.NroCta As NroCta,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) Else null End) as FecED,
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) Else null End) as FecVD,
	
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	max(v.Cd_MdRg) as Cd_MdRg,
	Max(Convert(varchar,v.FecMov,103)) As FecMov
 
from Voucher v 
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	--left join MantenimientoGN mg on v.RucE = mg.RucE and mg.Codigo = case when isnull(c.CA01,'')<>''then c.CA01 else c.CA02 end
Where v.RucE = @RucE /*Ruc */ and v.Ejer = @Ejer 
--and v.Prdo between  @PrdoIni and @PrdoFin
 and v.FecMov between @FecIni and @FecFin + ' 23:59:29'
and isnull(v.Ib_Anulado,0)=0

	Group by 
	v.RucE,
	v.NroCta,
	isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')),
	--isnull(case when isnull(c.RSocial,'')<>''then c.RSocial else c.ApPat + ' ' + c.ApMat + ' ' + c.Nom end +' - '+mg.Descrip,isnull(c.RSocial,c.ApPat + ' ' + c.ApMat + ' ' + c.Nom)),
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --'
	Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
	Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
	End End,
	v.Prdo,
	v.Ejer,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,'')
	,isnull(c.RSocial,'--')
	--,mg.Descrip			
				

Having
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) <> 0
) as t
group by
RucE,t.NDoc,t.Nomaux)as t
) as rr on rr.RucE = t1.RucE


declare 
@Mes int ,
@Anio int,
@dia int

set @FecFin='31/01/2011'
set @Mes=MONTH(@FecIni)-1
set @Anio=year(@FecIni)


 
 if (@Mes= 0 ) 
 begin 
  set @Anio = @Anio -1
  set @Mes= 12
  set @dia=31
   set @FecIni ='31/'+convert (varchar ,@Mes)+'/'+ convert (varchar,@Anio)

 end 
 else 

 
 
 print 'no hay mes '
 print convert(nvarchar,@FecIni ,103)

 
print month(@FecIni)
 select 

                        convert(nvarchar,@FecIni ,103)as fecha_ant,
                        isnull(sum(case when  v.Prdo=month(@FecIni)   then case when @Cd_Mda ='01'then isnull(v.MtoH,0.00) else isnull(v.MtoH_ME,0.00) end else 0  END),.0) AS saldo_ant
                        
                       
                  from 
                        voucher as v  
                        left join planctas as p on v.Ejer=p.Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta 
                        left join (
                               select
                                         v.NroCta, p.NomCta, max(v.RegCtb)as RegCtb, max (Cd_TD) as Cd_TD,max(NroSre) as NroSre,max(NroDoc)as NroDoc,max(Cd_clt)as Cd_clt,
                                         sum(case when  v.Prdo=month(@FecIni)   then CASE when @Cd_Mda='01' then isnull( v.Mtoh,0)else isnull(v.MtoH_ME,0) end   else 0  END )AS ENE1
                         
                                   from 
                                         voucher v left join planctas p on p.ruce=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta 
                                   where 
                                         v.ruce= @RucE and v.Ejer=@Ejer and v.Cd_Fte='RV' and left(v.NroCta,1)='7' 
                                         and v.FecMov=convert(nvarchar,@FecIni ,103)  
                                   group by 
                                         v.NroCta, p.NomCta
                              )as v1 on v1.Cd_TD=v.Cd_TD and v1.NroSre=v.NroSre and v1.NroDoc=v.NroDoc and v1.Cd_Clt=v.Cd_Clt
                             where 
                                   v.RucE=@RucE and v.Ejer=@EJER and LEFT(v.RegCtb,2)='TS' and left(p.NroCta,2)='12'
                                   --and  p.IC_IEF='I'   
                                   and v.FecMov = convert(nvarchar,@FecIni ,103) 
        




--Creado<16/01/2012>
--JA: Modifique los periodos por Fecha,
--prueba exec Rpt_LiquidacionInrepco2 '20252619926','2011','01','31/01/2011','31/12/2011'
GO
