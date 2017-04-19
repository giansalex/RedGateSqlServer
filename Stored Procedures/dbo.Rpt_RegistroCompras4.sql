SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RegistroCompras4]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2), --Servira para intercambio de moneda
@msj varchar(100) output
as
--Declare @Data nvarchar(150)  -- Jesus
if not exists(select * from voucher where RucE=@RucE and Cd_Fte='RC' and Ejer =@Ejer and Prdo between @Rprdo1 and @Rprdo2)
begin
	select 
		@RucE as RucE
		,(select RSocial from Empresa Where Ruc=@RucE) as RSocial
		,'-----------' as RegCtb 
		,@Ejer as Ejer 
		,@RPrdo1 as Prdo1
		,@RPrdo2 as Prdo2
		,'--' as Cd_Fte 
		,Convert(nvarchar,getdate(),103) as FecMov
		,'--' as Cd_TD
		,'-----' as NroSre
		,'-----' as NroDoc
		,'--' as Cd_TDI
		,'--' as NDoc
		, '*** SIN OPERACIONES ***'  as NomAux
		,Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda
		,'--'  as FecR,'--'  as TDR
		,'--'  as NSreR,'--'  as NDocR
		,'--' as DR_NCND,'--' as DR_NroDet, '--' as DR_FecDet
	    ,0.00 as BIM_ME,0.00 CamMda,0.00 BIM1_S
	    ,0.00 BIM2_E,0.00 BIM3_C,0.00 BIM4_N, '0' as IC_TipAfec
		,0.00 as IGV, 0.00 as Otros,0.00 as Total

End
else 
begin
select 
	t1.RucE
	,t1.RSocial
	,t1.RegCtb
	,t1.Ejer
	,t1.Prdo1
	,t1.Prdo2
	,t1.Cd_Fte
	,t1.FecMov
	,t1.Cd_TD
	,t1.NroSre
	,t1.NroDoc
	,t1.Cd_TDI
	,t1.NDoc
	,t1.NomAux
	,t1.NomMoneda
	,t1.FecR
	,t1.TDR
	,t1.NSreR
	,t1.NDocR
	,t1.DR_NCND
	,t1.DR_NroDet
	,t1.DR_FecDet
	,t2.BIM_ME
	,t2.CamMda
	,t2.BIM1_S
	,t2.BIM2_E
	,t2.BIM3_C
	,t2.BIM4_N
	,t2.IC_TipAfec
	,t3.IGV
	,t3.Otros
	,t3.Total
from(
		select 
			v.RucE,e.RSocial,v.RegCtb,
			v.Ejer,@RPrdo1 as Prdo1,@RPrdo2 as Prdo2,
			v.Cd_Fte,Max(convert(varchar,v.FecED,103)) as FecMov,
			Max(v.Cd_TD) as Cd_TD,
			Max(v.NroSre) as NroSre,MAx(v.NroDoc) as NroDoc,
			isnull(Max(a.Cd_TDI),Max(b.Cd_TDI)) as Cd_TDI,isnull(Max(a.NDoc),Max(b.NDoc)) as NDoc,
			Case When isnull(len(Max(v.Cd_Prv)),'0')='0' Then Case When isnull(len(Max(v.Cd_Clt)),'0')='0' Then '*** No Registrado ***' Else isnull(Max(b.RSocial),(isnull(Max(isnull(b.ApPat,''))+' '+Max(isnull(b.ApMat,''))+' '+Max(isnull(b.Nom,'')),'*** No Existe en Data ***'))) end
            Else isnull(Max(a.RSocial),(isnull(Max(isnull(a.ApPat,''))+' '+Max(isnull(a.ApMat,''))+' '+Max(isnull(a.Nom,'')),'*** No Existe en Data ***'))) end As NomAux,
			Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda
			,Case(v.IB_Anulado) when 0 then Max(convert(varchar,v.DR_FecED,103)) else '' end as FecR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_CdTD) else '' end as TDR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NSre) else '' end as NSreR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NDoc) else '' end as NDocR,
			Max(v.DR_NCND) as DR_NCND,Max(v.DR_NroDet) as DR_NroDet,Max(v.DR_FecDet) as DR_FecDet
		from Voucher v
		left join Empresa e on v.RucE=e.Ruc
		left join Proveedor2 a on v.RucE=a.RucE and v.Cd_Prv=a.Cd_Prv
		left join Cliente2 b on v.RucE=b.RucE and v.Cd_Clt=b.Cd_Clt
		where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC'
		Group by v.RucE,e.RSocial,v.Ejer,v.RegCtb,v.Cd_Fte,v.IB_Anulado
	) as t1
	left join(
	-------------------------------------------------------------------------------------------------
	--CONSULTANDO LAS BASES IMPONIBLES
	-------------------------------------------------------------------------------------------------
	select  
		v.RucE,
		v.Ejer,
		v.RegCtb,
		Sum(Case(v.Cd_MdRg) when '02' then Case( left(v.NroCta,6))when '40.1.1 ' then 0 else v.MtoD_ME-v.MtoH_ME end  else 0 end) BIM_ME,
		Max(v.CamMda) CamMda,
		Sum(Case(v.IC_TipAfec) when 'S' then Case(@Cd_Mda) When '01' Then v.MtoD-v.MtoH else v.MtoD_ME - v.MtoH_ME end else 0 end) BIM1_S,
		Sum(Case(v.IC_TipAfec) when 'E' then Case(@Cd_Mda) When '01' Then v.MtoD-v.MtoH else v.MtoD_ME - v.MtoH_ME end else 0 end) BIM2_E,
		Sum(Case(v.IC_TipAfec) when 'C' then Case(@Cd_Mda) When '01' Then v.MtoD-v.MtoH else v.MtoD_ME - v.MtoH_ME end else 0 end) BIM3_C,
		Sum(Case(v.IC_TipAfec) when 'N' then Case(@Cd_Mda) When '01' Then v.MtoD-v.MtoH else v.MtoD_ME - v.MtoH_ME end when 'F' then case(@Cd_Mda) When '01' Then v.MtoD-v.MtoH else v.MtoD_ME - v.MtoH_ME end else 0 end) BIM4_N,
		Convert(varchar,Sum(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) / Case(Count(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) + Sum(Case(v.IC_TipAfec) when 'n' then -1 else 0 end)) when 0 then 1 else Count(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) + Sum(Case(v.IC_TipAfec) when 'n' then -1 else 0 end) end) as IC_TipAfec
	from Voucher v
	left join Empresa e on v.RucE=e.Ruc
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0)-- or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	Group by v.RucE,v.Ejer,v.RegCtb
	) as t2 on t2.RucE=t1.RucE and t2.Ejer=t1.Ejer and t2.RegCtb=t1.RegCtb
	left join (
	select  
		v.RucE,
		V.Ejer,
		v.RegCtb,
		Sum(
			Case(left(v.NroCta,6)) 
				when '40.1.0' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				else 0 end + 
			Case(v.NroCta)         
				when '40.1.1.01' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				when '40.1.1.10' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				when '40.1.1.50' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				when '40.1.7.20' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				else 0 end + 
			Case(left(v.NroCta,10))  
				when '40.1.1.11'  then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				when '2002.01.01' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				when '2002.01.00' Then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				else 0 end +
			Case When v.NroCta in ('92.4.1.10','94.4.1.10') and @RucE='20528206931'
				Then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
				else 0 end
		) IGV,
		Sum(Case(v.NroCta) when p.QCtg then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
		when '40.1.2.01' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
		when '40.1.7.02' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
		when '40.1.7.20'  then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end
		when '40.1.1.30' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end else 0 end) as Otros,
		sum(Case(v.NroCta) when '40.1.0.02' then case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end else 0 end) Total
	from 
		Voucher v left join PlanCtasDef p on v.RucE=p.RucE and p.Ejer=v.Ejer
	where 
		v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' 
	Group by 
		v.RucE,v.Ejer,v.RegCtb
	) As t3 on t3.RucE=t1.RucE and t3.Ejer=t1.Ejer and t3.RegCtb=t1.RegCtb
	Order by 3,8,9,10
End

-- LEYENDA --
--JJ <Creado - 21/11/2011>
--exec Rpt_RegistroCompras4 '20503620350','2011','04','04','01',null



GO
