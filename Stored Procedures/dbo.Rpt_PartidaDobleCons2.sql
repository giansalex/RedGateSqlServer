SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_PartidaDobleCons2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@msj varchar(100) output

as

select 
	v.RucE,v.RegCtb,v.Prdo,

    Sum(v.MtoD) as DebeS,
    Sum(v.MtoH) as HaberS,
    Sum(v.MtoD-v.MtoH) as SaldoS
    
    ,Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD-v.MtoH Else 0 End)=0
	  Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD Else 0 End)<>Sum(Case When a.NroCta=v.NroCta Then v.MtoD+v.MtoH Else 0 End)
			    Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then 1 Else 0 End)>0
						  Then 'Base <> Destino'--2
						  Else Case When Sum(v.MtoD-v.MtoH)<>0 
								    Then 'Asiento Descuadrado'--3 
									Else ''--0 
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
		  Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then v.MtoD_ME Else 0 End)<>Sum(Case When a.NroCta=v.NroCta Then v.MtoD_ME+v.MtoH_ME Else 0 End)
				    Then Case When Sum(Case When isnull(v.IB_EsDes,0)=1 Then 1 Else 0 End)>0
							  Then 'Base <> Destino'--2
							  Else Case When Sum(v.MtoD_ME-v.MtoH_ME)<>0 
									    Then 'Asiento Descuadrado'--3 
										Else ''--0 
										End
							  End
				    Else Case When Sum(v.MtoD_ME-v.MtoH_ME)<>0 
							  Then 'Asiento Descuadrado'--3 
							  Else ''--0 
							  End 
					End
		  Else 'Destinos descuadrados'--1 
		  End As ObsDolares
    
    -- Leyenda
    -- 0 = Asiento Ok
    -- 1 = Diferencia en Destinos / Destinos descuadrados
    -- 2 = Base Diferente a Destinos / Base <> Destino
    -- 3 = Asiento Descuadrado
from 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Left Join AmarreCta a On a.RucE=v.RucE and a.Ejer=v.Ejer and a.NroCta=v.NroCta
where 
	v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @PrdoD and @PrdoH and isnull(v.IB_Anulado,0)=0
Group by 
	v.RucE,v.RegCtb,v.Prdo
Having 
	Sum(v.MtoD-v.MtoH) != 0 or Sum(v.MtoD_ME-v.MtoH_ME) != 0
Order by v.Prdo,v.RegCtb--,v.Prdo


select RucE,'TOTAL >>>>>>>>>>' as RegCtb,'>>>' as Prdo,Sum(MtoD) as DebeS,Sum(MtoH) as HaberS,Sum(MtoD-MtoH) as SaldoS, '' As ObsSoles,Sum(MtoD_ME) as DebeD,Sum(MtoH_ME) as HaberD,Sum(MtoD_ME-MtoH_ME) as SaldoD, '' AS ObsDolares
from Voucher 
where RucE=@RucE and Ejer=@Ejer and Prdo between @PrdoD and @PrdoH
Group by RucE
Having Sum(MtoD-MtoH) != 0 or Sum(MtoD_ME-MtoH_ME) != 0

-- Leyenda
-- DI: 24/10/2011 <Creacion del procedimiento almacenado>

GO
