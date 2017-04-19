SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_RegistroCompras]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2), --Servira para intercambio de moneda
@msj varchar(100) output
as

-------------------------------------------------------------------------------------------------
--CONSULTANDO CABECERA Y DETALLE DE AUXILIARES
-------------------------------------------------------------------------------------------------
select 
	v.RucE,e.RSocial,v.RegCtb,
	v.Ejer,@RPrdo1 as Prdo1,@RPrdo2 as Prdo2,
	v.Cd_Fte,convert(varchar,v.FecMov,103) FecMov,
	v.Cd_TD,
	v.NroSre,v.NroDoc,
	a.Cd_TDI,a.NDoc,Case(v.Cd_Aux) when '' then '' else isnull(a.RSocial, a.ApPat+' '+a.ApMat+' '+a.Nom) end NomAux
from Voucher v
inner join Empresa e on v.RucE=e.Ruc
left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (left(v.NroCta,2) in ('42','46') /*and v.MtoD<=0*/)
Group by v.RucE,e.RSocial,v.Ejer,v.RegCtb,v.Cd_Fte,v.FecMov,v.RegCtb,v.Cd_TD,v.NroSre,v.NroDoc,a.Cd_TDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_Aux
Order by 3
-------------------------------------------------------------------------------------------------
--CONSULTANDO LAS BASES IMPONIBLES
-------------------------------------------------------------------------------------------------
select  
	v.RucE,
	v.RegCtb,
	Sum(Case(v.Cd_MdRg) when '02' then Case( left(v.NroCta,6))when '40.1.1' then 0 else v.MtoD_ME end  else 0 end) BIM_ME,
	Max(v.CamMda) CamMda,
	--BIM--------------------
	Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) BIM1_S,
	Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end) BIM2_E,
	Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) BIM3_C,
	Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME else 0 end) BIM4_N,
	--v.IC_TipAfec
	Convert(varchar,Sum(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end)) IC_TipAfec
from Voucher v
inner join Empresa e on v.RucE=e.Ruc
where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0 or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))
Group by v.RucE,v.RegCtb/*,v.CamMda*/,v.Cd_MdRg--,v.IC_TipAfec
Order by 2
-------------------------------------------------------------------------------------------------
--CONSULTANDO EL IGV Y EL TOTAL
-------------------------------------------------------------------------------------------------
select  
	v.RucE,
	v.RegCtb,
	Sum(Case(left(v.NroCta,4)) when '40.1' then v.MtoD_ME-v.MtoH_ME else 0 end) IGV,
	Sum(v.MtoD_ME)+Sum(v.MtoH_ME) as Total
from Voucher v
where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01') or len(v.IC_TipAfec)>0)
Group by v.RucE,v.RegCtb
Order by 2
------CODIGO DE MODIFICACION--------
--CM=MG01
GO
