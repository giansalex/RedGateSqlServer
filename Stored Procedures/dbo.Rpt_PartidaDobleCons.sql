SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_PartidaDobleCons]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@msj varchar(100) output
as
/*
select RucE,RegCtb,Prdo,
       --Case(Cd_MdRg) when '01' then 'S/.' else 'US$' end MdaReg,
       Sum(MtoD) as DebeS,Sum(MtoH) as HaberS,Sum(MtoD-MtoH) as SaldoS,Sum(MtoD_ME) as DebeD,Sum(MtoH_ME) as HaberD,Sum(MtoD_ME-MtoH_ME) as SaldoD 
from Voucher 
where RucE=@RucE and Ejer=@Ejer and Prdo between @PrdoD and @PrdoH
Group by RucE,RegCtb,Prdo
Having Sum(MtoD-MtoH) != 0 or Sum(MtoD_ME-MtoH_ME) != 0
Order by RegCtb,Prdo

select RucE,'TOTAL >>>>>>>>>>' as RegCtb,'>>>' as Prdo,Sum(MtoD) as DebeS,Sum(MtoH) as HaberS,Sum(MtoD-MtoH) as SaldoS,Sum(MtoD_ME) as DebeD,Sum(MtoH_ME) as HaberD,Sum(MtoD_ME-MtoH_ME) as SaldoD 
from Voucher 
where RucE=@RucE and Ejer=@Ejer and Prdo between @PrdoD and @PrdoH
Group by RucE
Having Sum(MtoD-MtoH) != 0 or Sum(MtoD_ME-MtoH_ME) != 0
*/


/*
si(dd=dh)
{	si(dd<>base)
	{	if(cant dd > 0)
		{	Base <> destino	  }
		else
		{	if(d<>h)
			{	Asiento descuadrado	 }
			else
			{	ok	}
		}
	}
	else
	{	if(d<>h)
		{	Asiento descuadrado   }
		else
		{	ok   }
	}
}
else
{	Destinos son diferentes   }
*/

Select r.RucE,r.RegCtb,r.Prdo
	,DebeS,HaberS,SaldoS
	,DebeD,HaberD,SaldoD
	,Case When r.ObsSoles=r.ObsDolares 
		  Then 'S/. '+r.ObsSoles+' y US$. '+r.ObsDolares
		  Else Case When r.ObsSoles<>''
				    Then 'S/. '+r.ObsSoles
					Else 'US$. '+r.ObsDolares
					End
		  End As Obs
From
(
select 
	v.RucE,v.RegCtb,v.Prdo,

    Sum(v.MtoD) as DebeS,
    Sum(v.MtoH) as HaberS,
    Sum(v.MtoD-v.MtoH) as SaldoS
    
    ,Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD-v.MtoH Else 0 End)=0
		  Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD Else 0 End)<>Sum(Case When a.NroCta=v.NroCta and isnull(IB_esDes,0)<>1 Then v.MtoD+v.MtoH Else 0 End)
			    Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then 1 Else 0 End)>0
						  Then 'Base <> Destino'--2
							  Else Case When Sum(Case When isnull(p.IB_CtaD,0)=1 Then 1 Else 0 End)>=1
										Then 'No se pudo analizar, falta destino' --3
										Else Case When Sum(v.MtoD_ME-v.MtoH_ME)<>0 
											 Then 'Asiento Descuadrado'--4
											 Else ''--0 
											 End
										End
						  End
			    Else Case When Sum(v.MtoD-v.MtoH)<>0 
						  Then 'Asiento Descuadrado'--3 
						  Else ''--0 
						  End 
				End
		  Else 'Destinos descuadrados'--1 
		  End As ObsSoles,
       
    Sum(v.MtoD_ME) as DebeD,
    Sum(v.MtoH_ME) as HaberD,
    Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD 
	  
	,Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD_ME-v.MtoH_ME Else 0 End)=0
		  Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD_ME Else 0 End)<>Sum(Case When a.NroCta=v.NroCta and isnull(IB_esDes,0)<>1 Then v.MtoD_ME+v.MtoH_ME Else 0 End)
				    Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then 1 Else 0 End)>0
							  Then 'Base <> Destino'--2
							  Else Case When Sum(Case When isnull(p.IB_CtaD,0)=1 Then 1 Else 0 End)>=1
										Then 'No se pudo analizar, falta destino' --3
										Else Case When Sum(v.MtoD_ME-v.MtoH_ME)<>0 
											 Then 'Asiento Descuadrado'--4 
											 Else ''--0 
											 End
										End
							  End
				    Else Case When Sum(v.MtoD_ME-v.MtoH_ME)<>0 
							  Then 'Asiento Descuadrado'--4 
							  Else ''--0 
							  End 
					End
		  Else 'Destinos descuadrados'--1 
		  End As ObsDolares
    
    -- Leyenda
    -- 0 = Asiento Ok
    -- 1 = Diferencia en Destinos / Destinos descuadrados
    -- 2 = Base Diferente a Destinos / Base <> Destino
    -- 3 = No se pudo analizar, falta destino
    -- 4 = Asiento Descuadrado
    
	--,v.NroCta
	--,p.NroCta
	--,a.NroCta
	--,v.IB_EsDes
from 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	--Left Join AmarreCta a On a.RucE=v.RucE and a.Ejer=v.Ejer and a.NroCta=v.NroCta
	Left Join (Select a.RucE,a.Ejer,a.NroCta From AmarreCta a Where a.RucE=@RucE and Ejer=@Ejer Group by a.RucE,a.Ejer,a.NroCta) a On a.RucE=v.RucE and a.Ejer=v.Ejer and a.NroCta=v.NroCta
where 
	v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @PrdoD and @PrdoH and isnull(v.IB_Anulado,0)=0
	--and v.RegCtb='CTGN_RC01-00008'
Group by 
	v.RucE,v.RegCtb,v.Prdo
	--,v.NroCta
	--,p.NroCta
	--,a.NroCta
	--,v.IB_EsDes
--Having 
	--Sum(v.MtoD-v.MtoH) != 0 or Sum(v.MtoD_ME-v.MtoH_ME) != 0 
) r
--Where r.SaldoS+r.SaldoD <> 0 and (r.ObsSoles<>'' or r.ObsDolares<>'')
Where (r.SaldoS+r.SaldoD<>0 and isnull(r.ObsSoles,'')+isnull(r.ObsDolares,'')<>'') or (r.ObsSoles<>'' or r.ObsDolares<>'')
Order by r.Prdo,r.RegCtb


Select r.RucE,'TOTAL >>>>>>>>>>' as RegCtb,'>>>' as Prdo
	,Sum(DebeS) As DebeS,Sum(HaberS) As HaberS,Sum(SaldoS) As SaldoS
	,Sum(DebeD) As DebeD,Sum(HaberD) As HaberD,Sum(SaldoD) As SaldoD
	,'' Obs
From
(
select 
	v.RucE,v.RegCtb,v.Prdo,

    Sum(v.MtoD) as DebeS,
    Sum(v.MtoH) as HaberS,
    Sum(v.MtoD-v.MtoH) as SaldoS
    
    ,Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD-v.MtoH Else 0 End)=0
		  Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD Else 0 End)<>Sum(Case When a.NroCta=v.NroCta and isnull(IB_esDes,0)<>1 Then v.MtoD+v.MtoH Else 0 End)
			    Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then 1 Else 0 End)>0
						  Then 'Base <> Destino'--2
							  Else Case When Sum(Case When isnull(p.IB_CtaD,0)=1 Then 1 Else 0 End)>=1
										Then 'No se pudo analizar, falta destino' --3
										Else Case When Sum(v.MtoD_ME-v.MtoH_ME)<>0 
											 Then 'Asiento Descuadrado'--4
											 Else ''--0 
											 End
										End
						  End
			    Else Case When Sum(v.MtoD-v.MtoH)<>0 
						  Then 'Asiento Descuadrado'--3 
						  Else ''--0 
						  End 
				End
		  Else 'Destinos descuadrados'--1 
		  End As ObsSoles,
       
    Sum(v.MtoD_ME) as DebeD,
    Sum(v.MtoH_ME) as HaberD,
    Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD 
	  
	,Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD_ME-v.MtoH_ME Else 0 End)=0
		  Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD_ME Else 0 End)<>Sum(Case When a.NroCta=v.NroCta and isnull(IB_esDes,0)<>1 Then v.MtoD_ME+v.MtoH_ME Else 0 End)
				    Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then 1 Else 0 End)>0
							  Then 'Base <> Destino'--2
							  Else Case When Sum(Case When isnull(p.IB_CtaD,0)=1 Then 1 Else 0 End)>=1
										Then 'No se pudo analizar, falta destino' --3
										Else Case When Sum(v.MtoD_ME-v.MtoH_ME)<>0 
											 Then 'Asiento Descuadrado'--4 
											 Else ''--0 
											 End
										End
							  End
				    Else Case When Sum(v.MtoD_ME-v.MtoH_ME)<>0 
							  Then 'Asiento Descuadrado'--4 
							  Else ''--0 
							  End 
					End
		  Else 'Destinos descuadrados'--1 
		  End As ObsDolares
    
    -- Leyenda
    -- 0 = Asiento Ok
    -- 1 = Diferencia en Destinos / Destinos descuadrados
    -- 2 = Base Diferente a Destinos / Base <> Destino
    -- 3 = No se pudo analizar, falta destino
    -- 4 = Asiento Descuadrado
    
	--,v.NroCta
	--,p.NroCta
	--,a.NroCta
	--,v.IB_EsDes
from 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	--Left Join AmarreCta a On a.RucE=v.RucE and a.Ejer=v.Ejer and a.NroCta=v.NroCta
	Left Join (Select a.RucE,a.Ejer,a.NroCta From AmarreCta a Where a.RucE=@RucE and Ejer=@Ejer Group by a.RucE,a.Ejer,a.NroCta) a On a.RucE=v.RucE and a.Ejer=v.Ejer and a.NroCta=v.NroCta
where 
	v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @PrdoD and @PrdoH and isnull(v.IB_Anulado,0)=0
	--and v.RegCtb='CTGN_RC01-00008'
Group by 
	v.RucE,v.RegCtb,v.Prdo
	--,v.NroCta
	--,p.NroCta
	--,a.NroCta
	--,v.IB_EsDes
--Having 
	--Sum(v.MtoD-v.MtoH) != 0 or Sum(v.MtoD_ME-v.MtoH_ME) != 0 
) r
--Where r.SaldoS+r.SaldoD <> 0 and (r.ObsSoles<>'' or r.ObsDolares<>'')
Where (r.SaldoS+r.SaldoD<>0 and isnull(r.ObsSoles,'')+isnull(r.ObsDolares,'')<>'') or (r.ObsSoles<>'' or r.ObsDolares<>'')
Group by r.RucE

-- Leyenda --
-- DI : 03/11/2011 <Modificacion de la estructura>
-- DI : 18/11/2011 <Se Agrego simbolo "=" a la condicion si existe destino>
GO
