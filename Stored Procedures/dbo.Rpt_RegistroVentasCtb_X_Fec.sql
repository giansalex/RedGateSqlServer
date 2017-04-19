SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RegistroVentasCtb_X_Fec]
--Reporte de registro de ventas x contabilidad ordenado x fecha
@RucE nvarchar(11),
@Eje nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2), --Servira para intercambio de moneda
@msj varchar(100) output

as
if not exists (select * from Voucher where RucE=@RucE and Ejer=@Eje and Prdo between @RPrdo1 and @RPrdo2 and Cd_Fte='RV')
begin
	select 
		@RucE as RucE,e.RSocial,'R0' as RegCtb,
		@Eje as Ejer,@Rprdo1 as Prdo1,@Rprdo2 as Prdo2,
		'RV' as Cd_Fte,'--/--/----' as FecMov,
		'--' Cd_TD,
		'--' as NroSre,'--' as NroDoc,
		'--' as Cd_TDI,'--' as NDoc,
		'*** No contiene información ***' as NomAux,
		Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda
		,'' as FecR,'' as TDR,'' as NSreR,'' as NDocR
	from Empresa e where e.Ruc=@RucE

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
end
else
begin

	IF (@Cd_Mda = '01')
	Begin
		select 
			v.RucE,e.RSocial,v.RegCtb,
			v.Ejer,@Rprdo1 as Prdo1,@Rprdo2 as Prdo2,
			v.Cd_Fte,Min(convert(varchar,v.FecED,103)) FecMov,--convert(varchar,v.FecMov,103) FecMov,
			Max(v.Cd_TD) as Cd_TD,
			Max(v.NroSre) as NroSre,Max(v.NroDoc) as NroDoc,
			Max(a.Cd_TDI) as Cd_TDI,Max(a.NDoc) as NDoc,
			Case(v.IB_Anulado) when 1 then '( ANULADO ) - ' else '' end + Case(isnull(len(Max(v.Cd_Clt/*v.Cd_Aux*/)),'0')) when '0' then '*** No Registrado ***' else isnull(Max(a.RSocial),(isnull(Max(isnull(a.ApPat,''))+' '+Max(isnull(a.ApMat,''))+' '+Max(isnull(a.Nom,'')),'*** No Existe en Data ***'))) end NomAux,
			convert(varchar,v.FecMov,103) as Grupo,
			Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda
			,Case(v.IB_Anulado) when 0 then Max(convert(varchar,v.DR_FecED,103)) else '' end as FecR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_CdTD) else '' end as TDR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NSre) else '' end as NSreR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NDoc) else '' end as NDocR
			--,convert(varchar,v.DR_FecED,103) as FecR,v.DR_CdTD as TDR,v.DR_NSre as NSreR,v.DR_NDoc as NDocR
		from Voucher v
		inner join Empresa e on v.RucE=e.Ruc
		--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join Cliente2 a on v.RucE=a.RucE and v.Cd_Clt=a.Cd_Clt
		where v.RucE=@RucE and v.Ejer=@Eje and v.Prdo between @Rprdo1 and @Rprdo2 and v.Cd_Fte='RV' --and left(v.NroCta,2) in ('12','14','16')
		Group by v.RucE,e.RSocial,v.FecED,v.Ejer,v.RegCtb,v.Cd_Fte,v.IB_Anulado,v.FecMov--,v.DR_FecED,v.DR_CdTD,v.DR_NSre,v.DR_NDoc--,v.FecMov,v.Cd_TD,v.NroSre,v.NroDoc--,a.Cd_TDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.IB_Anulado
		Order by v.FecED
	
		select 
			v.RucE,
			v.RegCtb,
			Convert(varchar,Case(v.IB_Anulado) when 0 then v.CamMda else 0 end) CamMda,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'V' then v.MtoH-v.MtoD else 0 end else 0 end) VAL,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'S' then v.MtoH-v.MtoD else 0 end else 0 end) BIM,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'E' then v.MtoH-v.MtoD else 0 end else 0 end) EXO,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.NroCta) when p.IGV then v.MtoH-v.MtoD else 0 end else 0 end) IGV,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'N' then v.MtoH-v.MtoD when 'I' then v.MtoH-v.MtoD else 0 end else 0 end) INA,
			Sum(Case(v.IB_Anulado) when 0 then (Case(v.IC_TipAfec) when 'S' then v.MtoH-v.MtoD when 'V' then v.MtoH-v.MtoD when 'E' then v.MtoH-v.MtoD else 0 end)+(Case(v.NroCta) when p.IGV then v.MtoH-v.MtoD else 0 end)+(Case(v.IC_TipAfec) when 'N' then v.MtoH-v.MtoD when 'I' then v.MtoH-v.MtoD else 0 end) else 0 end) Total,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'S' then Case(v.Cd_MdRg) when '01' then 0.00 else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) BIM_ME
		from Voucher v
		inner join Empresa e on v.RucE=e.Ruc
		--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join Cliente2 a on v.RucE=a.RucE and v.Cd_Clt=a.Cd_Clt
		left join PlanCtasDef p on v.RucE=p.RucE
		where v.RucE=@RucE and v.Ejer=@Eje and v.Prdo between @Rprdo1 and @Rprdo2 and v.Cd_Fte='RV' --and left(v.NroCta,2) in ('12','14','16','40','99')
		Group by v.RucE,e.RSocial,v.FecED,v.RegCtb,v.CamMda,v.IB_Anulado
		Order by v.FecED
	End
	Else
	Begin
		select 
			v.RucE,e.RSocial,v.RegCtb,
			v.Ejer,@Rprdo1 as Prdo1,@Rprdo2 as Prdo2,
			v.Cd_Fte,Min(convert(varchar,v.FecED,103)) FecMov,--convert(varchar,v.FecMov,103) FecMov,
			Max(v.Cd_TD) as Cd_TD,
			Max(v.NroSre) as NroSre,Max(v.NroDoc) as NroDoc,
			Max(a.Cd_TDI) as Cd_TDI,Max(a.NDoc) as NDoc,
			Case(v.IB_Anulado) when 1 then '( ANULADO ) - ' else '' end + Case(isnull(len(Max(v.Cd_Clt/*v.Cd_Aux*/)),'0')) when '0' then '*** No Registrado ***' else isnull(Max(a.RSocial),(isnull(Max(isnull(a.ApPat,''))+' '+Max(isnull(a.ApMat,''))+' '+Max(isnull(a.Nom,'')),'*** No Existe en Data ***'))) end NomAux,
			convert(varchar,v.FecMov,103) as Grupo,
			Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda
			,Case(v.IB_Anulado) when 0 then Max(convert(varchar,v.DR_FecED,103)) else '' end as FecR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_CdTD) else '' end as TDR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NSre) else '' end as NSreR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NDoc) else '' end as NDocR
			--,convert(varchar,v.DR_FecED,103) as FecR,v.DR_CdTD as TDR,v.DR_NSre as NSreR,v.DR_NDoc as NDocR
		from Voucher v
		inner join Empresa e on v.RucE=e.Ruc
		--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join Cliente2 a on v.RucE=a.RucE and v.Cd_Clt=a.Cd_Clt
		where v.RucE=@RucE and v.Ejer=@Eje and v.Prdo between @Rprdo1 and @Rprdo2 and v.Cd_Fte='RV' --and left(v.NroCta,2) in ('12','14','16')
		Group by v.RucE,e.RSocial,v.FecMov,v.FecED,v.Ejer,v.RegCtb,v.Cd_Fte,v.IB_Anulado--,v.DR_FecED,v.DR_CdTD,v.DR_NSre,v.DR_NDoc--,v.FecMov,v.Cd_TD,v.NroSre,v.NroDoc--,a.Cd_TDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.IB_Anulado
		Order by v.FecED
		
		select 
			v.RucE,
			v.RegCtb,
			Convert(varchar,Case(v.IB_Anulado) when 0 then v.CamMda else 0 end) CamMda,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'V' then v.MtoH_ME-v.MtoD_ME else 0 end else 0 end) VAL,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'S' then v.MtoH_ME-v.MtoD_ME else 0 end else 0 end) BIM,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'E' then v.MtoH_ME-v.MtoD_ME else 0 end else 0 end) EXO,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.NroCta) when p.IGV then v.MtoH_ME-v.MtoD_ME else 0 end else 0 end) IGV,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'N' then v.MtoH_ME-v.MtoD_ME when 'I' then v.MtoH_ME-v.MtoD_ME else 0 end else 0 end) INA,
			Sum(Case(v.IB_Anulado) when 0 then (Case(v.IC_TipAfec) when 'S' then v.MtoH_ME-v.MtoD_ME when 'V' then v.MtoH_ME-v.MtoD_ME when 'E' then v.MtoH_ME-v.MtoD_ME else 0 end)+(Case(v.NroCta) when p.IGV then v.MtoH_ME-v.MtoD_ME else 0 end)+(Case(v.IC_TipAfec) when 'N' then v.MtoH_ME-v.MtoD_ME when 'I' then v.MtoH_ME-v.MtoD_ME else 0 end) else 0 end) Total,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when 'S' then Case(v.Cd_MdRg) when '01' then 0.00 else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) BIM_ME
		from Voucher v
		inner join Empresa e on v.RucE=e.Ruc
		--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join Cliente2 a on v.RucE=a.RucE and v.Cd_Clt=a.Cd_Clt
		left join PlanCtasDef p on v.RucE=p.RucE
		where v.RucE=@RucE and v.Ejer=@Eje and v.Prdo between @Rprdo1 and @Rprdo2 and v.Cd_Fte='RV' --and left(v.NroCta,2) in ('12','14','16','40','99')
		Group by v.RucE,e.RSocial,v.FecED,v.RegCtb,v.CamMda,v.IB_Anulado
		Order by v.FecED
	End


end	
-- 07/09/2009 MODIFICACION agregar columnas a la consulta
-- J : 18-07-2010 -> Creado : Ordenado x Fecha
/* Ejemplo
exec dbo.Rpt_RegistroVentasCtb_X_Fec '11111111111','2010','01','04','01',null
*/

--MP: LUN 20-09-2010 Modf: Se quito las referencias a la tabla Auxiliar y se enlazo con Cliente2
--CM: RA01
GO
