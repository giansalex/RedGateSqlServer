SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--select *from empresa where rsocial like '%estrella%'

--select *from voucher where RucE='20108866277' and ejer='2011' and Cd_Fte='RV'
--[dbo].[Rpt_RegistroVentas2] '20108866277','2011','06','06','01',null
CREATE procedure [dbo].[Rpt_RegistroVentas4]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2),
@msj varchar(100) output
As

if not exists (select * from Voucher where RucE=@RucE and Ejer=@Eje and Prdo between @RPrdo1 and @RPrdo2 and Cd_Fte='RV')
begin
	select 
		t.*,t1.VAL,t1.BIM,t1.EXO,t1.IGV,t1.INA,t1.Total,t1.BIM_ME
	from(
	select 
		@RucE as RucE,e.RSocial,'R0' as RegCtb,
		@Eje as Ejer,@Rprdo1 as Prdo1,@Rprdo2 as Prdo2,
		'RV' as Cd_Fte,'--/--/----' as FecMov,
		'--' Cd_TD,
		'--' as NroSre,'--' as NroDoc,
		'--' as Cd_TDI,'--' as NDoc,
		'*** SIN OPERACIONES ***' as NomAux,
		Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda
		,'' as FecR,'' as TDR,'' as NSreR,'' as NDocR
	from Empresa e where e.Ruc=@RucE
	) as t
	left join (
	select 
		@RucE as RucE,
		'R0' as RegCtb,
		0.000 as CamMda,
		0.00 as VAL,
		0.00 as BIM,
		0.00 as EXO,
		0.00 as IGV,
		0.00 as INA,
		0.00 as Total,
		0.00 as BIM_ME
	) as t1 on t1.RucE=t.RucE and t1.RegCtb=t.RegCtb
end
else
begin
		select 
			t.*
			,t1.CamMda
			,t1.VAL
			,t1.BIM
			,t1.EXO
			,t1.IGV
			,t1.INA
			,t1.Total
			,t1.BIM_ME
		from(
		select 
			v.RucE,e.RSocial,v.RegCtb,
			v.Ejer,@Rprdo1 as Prdo1,@Rprdo2 as Prdo2,
			v.Cd_Fte,Min(convert(varchar,v.FecED,103)) FecMov,--convert(varchar,v.FecMov,103) FecMov,
			Max(v.Cd_TD) as Cd_TD,
			Max(v.NroSre) as NroSre,Max(v.NroDoc) as NroDoc,
			Max(a.Cd_TDI) as Cd_TDI,Max(a.NDoc) as NDoc,
			Case(v.IB_Anulado) when 1 then '( ANULADO ) - ' else '' end + Case(isnull(len(Max(v.Cd_Clt)),'0')) when '0' then '*** No Registrado ***' else isnull(Max(a.RSocial),(isnull(Max(isnull(a.ApPat,''))+' '+Max(isnull(a.ApMat,''))+' '+Max(isnull(a.Nom,'')),'*** No Existe en Data ***'))) end NomAux,
			Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda
			,Case(v.IB_Anulado) when 0 then Max(convert(varchar,v.DR_FecED,103)) else '' end as FecR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_CdTD) else '' end as TDR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NSre) else '' end as NSreR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NDoc) else '' end as NDocR
		from Voucher v
		inner join Empresa e on v.RucE=e.Ruc
		left join Cliente2 a on v.RucE=a.RucE and v.Cd_Clt=a.Cd_Clt
		where v.RucE=@RucE and v.Ejer=@Eje and v.Prdo between @Rprdo1 and @Rprdo2 and v.Cd_Fte='RV'
		Group by v.RucE,e.RSocial,v.Ejer,v.RegCtb,v.Cd_Fte,v.IB_Anulado
		)as t
		left join (
		select 
			v.RucE,
			v.RegCtb,
			Convert(varchar,Case(v.IB_Anulado) when 0 then v.CamMda else 0 end) CamMda,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'V' then Case when @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) VAL,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'S' then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) BIM,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'E' then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) EXO,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.NroCta) when p.IGV then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) IGV,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'N' then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when 'I' then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) INA,
			Sum(Case(v.IB_Anulado) when 0 then (Case(v.IC_TipAfec) when 'S' then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when 'V' then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when 'E' then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end)+(Case(v.NroCta) when p.IGV then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME End else 0 end)+(Case(v.IC_TipAfec) when 'N' then Case When @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when 'I' then Case  when @Cd_Mda='01' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end) else 0 end) Total,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'S' then Case(v.Cd_MdRg) when '01' then 0.00 else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) BIM_ME
		from Voucher v
		inner join Empresa e on v.RucE=e.Ruc
		left join PlanCtasDef p on v.RucE=p.RucE and p.Ejer=v.Ejer
		where v.RucE=@RucE and v.Ejer=@Eje and v.Prdo between @Rprdo1 and @Rprdo2 and v.Cd_Fte='RV'
		Group by v.RucE,v.RegCtb,v.CamMda,v.IB_Anulado
		) as t1 on t1.RucE=t.RucE and t1.RegCtb=t.RegCtb
		Order by t.RegCtb,month(t.FecMov) asc,day(t.FecMov) asc --,
		--Order by 2
	
end	
-- 07/09/2009 MODIFICACION gragar calumnas a la consulta

--MP: LUN 20-09-2010 Mod: Se quito las referencias a la tabla Auxiliar y se enlazo con Cliente2
--CodModf: RA01
--JA: <06/10/2011>: Se modifico el Texto cuando no tiene informacion a "SIN OPERACIONES"
GO
