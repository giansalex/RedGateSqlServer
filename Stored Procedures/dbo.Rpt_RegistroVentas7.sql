SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--[dbo].[Rpt_RegistroVentas7] '20536657135','2013','02','02','01','Asc',0,01,1,null
-- exec [dbo].[Rpt_RegistroVentas7] '20160000001','2016','10','10','01','Asc',0,01,1,null




CREATE procedure [dbo].[Rpt_RegistroVentas7]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2),
@Orden varchar(4),
@OrdernarPor int,
@Cd_Td nvarchar(400),
@grupo nchar(1),
@msj varchar(100) output
As

if not exists (select top 1 * from Voucher where RucE=@RucE and Ejer=@Eje and Cd_Fte='RV' and Prdo between @RPrdo1 and @RPrdo2)
begin
declare @Consulta1 varchar(max)
set @Consulta1='
	select 
		t.*,t1.VAL,t1.BIM,t1.EXO,t1.IGV,t1.INA,t1.Total,t1.BIM_ME
	from(
	select 
		'''+Convert(varchar,@RucE)+''' as RucE,e.RSocial,''R0'' as RegCtb,
		'''+Convert(varchar,@Eje)+''' as Ejer,'''+Convert(varchar,@Rprdo1)+''' as Prdo1,'''+Convert(varchar,@Rprdo2)+''' as Prdo2,
		''RV'' as Cd_Fte,''--/--/----'' as FecMov,
		''--'' Cd_TD,
		''--'' as NroSre,''--'' as NroDoc,
		''--'' as Cd_TDI,''--'' as NDoc,
		''*** SIN OPERACIONES ***'' as NomAux,
		Case('''+Convert(varchar,@Cd_Mda)+''') when ''01'' then ''Nuevos Soles'' else ''Dolares Americanos'' end as NomMoneda
		,'''' as FecR,'''' as TDR,'''' as NSreR,'''' as NDocR
	from Empresa e where e.Ruc='''+Convert(varchar,@RucE)+'''
	) as t
	left join (
	select 
		'''+Convert(varchar,@RucE)+''' as RucE,
		''R0'' as RegCtb,
		0.000 as CamMda,
		0.00 as VAL,
		0.00 as BIM,
		0.00 as EXO,
		0.00 as IGV,
		0.00 as INA,
		0.00 as Total,
		0.00 as BIM_ME
	) as t1 on t1.RucE=t.RucE and t1.RegCtb=t.RegCtb
'
print @Consulta1
exec(@Consulta1)
end
else
begin
declare @Consulta2 varchar(max)
declare @Consulta3 varchar(max)
declare @Consulta4 varchar(max)

set @Consulta2='
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
			,t1.OTROS
			,isnull(t1.IB_Anulado,0) as IB_Anulado
			,'''+@grupo+''' as grupo
		from(
		select 
			MAx(case when isnull(v.IB_EsProv,0)=1 then isnull(v.FecCbr,isnull(v.FecVD,'''')) end) as FecVdCbr,
			v.RucE,e.RSocial,v.RegCtb,
			v.Ejer,'''+Convert(varchar,@Rprdo1)+''' as Prdo1,'''+Convert(varchar,@Rprdo2)+''' as Prdo2,
			v.Cd_Fte,Min(convert(varchar,v.FecED,103)) FecMov,
			Max(v.Cd_TD) as Cd_TD,
			Max(v.NroSre) as NroSre,Max(v.NroDoc) as NroDoc,
			Max(a.Cd_TDI) as Cd_TDI,Case(v.IB_Anulado) when 1 then ''( ANULADO ) - '' else '''' +
			Case when Isnull(Max(a.NDoc),'''')='''' then ''*** No Registrado ***'' else Max(a.NDoc) end end as NDoc,			
			Case(v.IB_Anulado) when 1 then ''( ANULADO ) - '' else '''' end + Case(isnull(len(Max(v.Cd_Clt)),''0'')) when ''0'' then ''*** No Registrado ***'' else isnull(Max(a.RSocial),(isnull(Max(isnull(a.ApPat,''''))+'' ''+Max(isnull(a.ApMat,''''))+'' ''+Max(isnull(a.Nom,'''')),''*** No Existe en Data ***''))) end NomAux,
			
			Case(v.IB_Anulado) when 1 then Max(a.NDoc) else '''' +
			Case when Isnull(Max(a.NDoc),'''')='''' then '''' else Max(a.NDoc) end end as NDocLE,
			Case(v.IB_Anulado) when 1 then '''' else '''' end + Case(isnull(len(Max(v.Cd_Clt)),''0'')) when ''0'' then ''*** No Registrado ***'' else isnull(Max(a.RSocial),(isnull(Max(isnull(a.ApPat,''''))+'' ''+Max(isnull(a.ApMat,''''))+'' ''+Max(isnull(a.Nom,'''')),''*** No Existe en Data ***''))) end NomAuxLE,

			Case('''+Convert(varchar,@Cd_Mda)+''') when ''01'' then ''Nuevos Soles'' else ''Dolares Americanos'' end as NomMoneda
			,Case(v.IB_Anulado) when 0 then Max(convert(varchar,v.DR_FecED,103)) else '''' end as FecR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_CdTD) else '''' end as TDR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NSre) else '''' end as NSreR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NDoc) else '''' end as NDocR
		from Voucher v
		inner join Empresa e on v.RucE=e.Ruc
		left join Cliente2 a on v.RucE=a.RucE and v.Cd_Clt=a.Cd_Clt
		where v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Eje)+''' and v.Prdo between '''+Convert(varchar,@Rprdo1)+''' and '''+Convert(varchar,@Rprdo2)+''' and v.Cd_Fte=''RV'' and v.Cd_TD in ('+@Cd_TD+')
		Group by v.RucE,e.RSocial,v.Ejer,v.RegCtb,v.Cd_Fte,v.IB_Anulado
		)as t'
set @Consulta3='
		left join (
		select 
			v.RucE,
			v.RegCtb,
			v.IB_Anulado,
			Convert(varchar,Case(v.IB_Anulado) when 0 then v.CamMda else 0 end) CamMda,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when ''V'' then Case when '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) VAL,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when ''S'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) BIM,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when ''E'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) EXO,
			--Sum(Case(v.IB_Anulado) when 0 then Case(v.NroCta) when p.IGV then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) IGV,
			Sum(Case(v.IB_Anulado) when 0 then Case(isnull(pc.IB_IGV,0)) when 1 then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) IGV,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when ''N'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when ''I'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) INA,
			--Sum(Case(v.IB_Anulado) when 0 then (Case(v.IC_TipAfec) when ''S'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when ''V'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when ''E'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end)+(Case(v.NroCta) when p.IGV then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME End else 0 end)+(Case(v.IC_TipAfec) when ''N'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when ''I'' then Case  when '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end) else 0 end) Total,
			Sum(Case(v.IB_Anulado) when 0 then (Case(v.IC_TipAfec) when ''S'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when ''V'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when ''E'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end)+(Case(isnull(pc.IB_IGV,0)) when 1 then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME End else 0 end)+(Case(v.IC_TipAfec) when ''N'' then Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when ''I'' then Case  when '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end) else 0 end) Total,
			Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) when ''S'' then Case(v.Cd_MdRg) when ''01'' then 0.00 else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) BIM_ME,
			sum(Case(v.IB_Anulado) when 0 then Case when ('''+@RucE+''' = ''20511437360'' and v.NroCta = ''41.9.1.10'') then Case when '''+Convert(varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) as OTROS
		from Voucher v
		inner join Empresa e on v.RucE=e.Ruc
		left join PlanCtasDef p on v.RucE=p.RucE and p.Ejer=v.Ejer
		inner join PlanCtas pc on pc.RucE = v.RucE and pc.Ejer = v.Ejer and pc.NroCta= v.NroCta
		where v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Eje)+''' and v.Prdo between '''+Convert(varchar,@Rprdo1)+''' and '''+Convert(varchar,@Rprdo2)+''' and v.Cd_Fte=''RV'' 
		Group by v.RucE,v.RegCtb,v.CamMda,v.IB_Anulado
		) as t1 on t1.RucE=t.RucE and t1.RegCtb=t.RegCtb
		Order By
		'
if(@OrdernarPor=0) set @Consulta4=' t.RegCtb '
else if(@OrdernarPor=1) set @Consulta4= ' Convert(varchar,t.FecMov,103) '
else if(@OrdernarPor=2) set @Consulta4= ' t.Cd_TD, t.NroSre, t.NroDoc '

set @Consulta4=@Consulta4+@Orden

print @Consulta2
print @Consulta3
print @Consulta4

exec(@Consulta2+@Consulta3+@Consulta4)

		--Order by t.RegCtb,month(t.FecMov) asc,day(t.FecMov) asc --,
		--Order by 2
	
end	
-- 07/09/2009 MODIFICACION gragar calumnas a la consulta

--MP: LUN 20-09-2010 Mod: Se quito las referencias a la tabla Auxiliar y se enlazo con Cliente2
--CodModf: RA01
--JA: <06/10/2011>: Se modifico el Texto cuando no tiene informacion a "SIN OPERACIONES"
--Modificacion
--JA: <22/05/2012>: Le agrege el Campo FecVdCbr en el primer Select.
GO
