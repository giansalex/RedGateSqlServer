SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--[dbo].[Rpt_RegistroVentas6] '11111111111','2012','01','01','01','Asc',0,null
CREATE procedure [dbo].[Rpt_RegistroVentas6]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2),
@Orden varchar(4),
@OrdernarPor int,
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
print (@Consulta1)
exec(@Consulta1)
end
else
begin
declare @Consulta2 varchar(max)
declare @Consulta3 varchar(max)
declare @Consulta4 varchar(max)

set @Consulta2='
Select 
	t.*
	, t1.CamMda
	, t1.VAL
	, t1.BIM
	, t1.EXO
	, t1.IGV
	, t1.INA
	, t1.Total
	, t1.BIM_ME
From
( select Max(Case When Isnull(v.IB_EsProv,0)=1 Then Isnull(v.FecCbr,Isnull(v.FecVD,'''')) End) As FecVdCbr
	, v.RucE, e.RSocial, v.RegCtb, v.Ejer, '''+Convert(varchar,Isnull(@Rprdo1,''))+''' As Prdo1, '''+Convert(varchar,Isnull(@Rprdo2,''))+''' As Prdo2
	, v.Cd_Fte, Min(Convert(varchar,v.FecED,103)) As FecMov
	, Max(v.Cd_TD) Cd_TD, Max(v.NroSre) NroSre, Max(v.NroDoc) NroDoc, Max(c2.Cd_TDI) Cd_TDI
	, Case(v.IB_Anulado) When 1 Then ''(ANULADO) - '' Else '''' + Case When Isnull(Max(c2.NDoc),'''')='''' Then ''*** No Registrado ***'' Else Max(c2.NDoc) End End As NDoc
	, Case(v.IB_Anulado) When 1 Then ''(ANULADO) - '' Else '''' End + Case(Isnull(Len(Max(v.Cd_Clt)),0)) When 0 Then ''*** No Registrado ***'' Else Isnull(Max(c2.RSocial),Isnull(Max(Isnull(c2.ApPat,'''')+'' ''+Isnull(c2.ApMat,'''')+'' ''+Isnull(c2.Nom,'''')),''*** No Existe en Data ***'')) End As NomAux
	, Case('''+Convert(Varchar,Isnull(@Cd_Mda,''))+''') when ''01''  Then ''Nuevos Soles'' Else ''Dolares Americanos'' End As NomMoneda
	, Case(v.IB_Anulado) when 0 then Max(convert(varchar,v.DR_FecED,103)) else '''' end as FecR, Case(v.IB_Anulado) when 0 then Max(v.DR_CdTD) else '''' end as TDR, Case(v.IB_Anulado) when 0 then Max(v.DR_NSre) else '''' end as NSreR
	, Case(v.IB_Anulado) when 0 then Max(v.DR_NDoc) else '''' end as NDocR
from 
	voucher v inner join Empresa e On e.Ruc=v.RucE left join Cliente2 c2 on c2.RucE=v.RucE and c2.Cd_Clt=v.Cd_Clt
Where
	v.RucE='''+Convert(Varchar,@RucE)+''' and v.Ejer='''+Convert(Varchar,@Eje)+''' and v.Cd_Fte=''RV''
Group By v.RucE,e.RSocial, v.Ejer, v.RegCtb,v.Cd_Fte,v.IB_Anulado
) As t 
'

set @Consulta3='
left join (
select 
	v.RucE
	, v.RegCtb
	, Convert(Varchar,Case(v.IB_Anulado) When 0 Then v.CamMda Else 0 End) CamMda
	, Sum(Case(v.IB_Anulado) When 0 Then Case(v.IC_TipAfec) When ''V'' Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME end else 0 End Else 0 End) VAL
	, Sum(Case(v.IB_Anulado) When 0 Then Case(v.IC_TipAfec) When ''S'' Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME end else 0 End Else 0 End) BIM
	, Sum(Case(v.IB_Anulado) When 0 Then Case(v.IC_TipAfec) When ''E'' Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME end else 0 End Else 0 End) EXO
	, SUM(Case(v.IB_Anulado) When 0 Then Case(Isnull(p.IB_IGV,0)) When 1 Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' Then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME End Else 0 End Else 0 End) As IGV
	, Sum(Case(v.IB_Anulado) When 0 Then Case(v.IC_TipAfec) When ''N'' Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end when ''I'' then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' then v.MtoH-v.MtoD else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) INA
	, Sum(Case(v.IB_Anulado) When 0 Then (Case(v.IC_TipAfec) When ''S'' Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' Then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME End When ''V'' Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' Then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME End When ''E'' Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' Then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME End Else 0 End)
	+ Case(v.IB_Anulado) When 0 Then Case(Isnull(p.IB_IGV,0)) When 1 Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' Then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME End Else 0 End Else 0 End 
	+ (Case(v.IC_TipAfec) When ''N'' Then Case When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' Then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME End When ''I'' Then Case  When '''+Convert(Varchar,@Cd_Mda)+'''=''01'' Then v.MtoH-v.MtoD Else v.MtoH_ME-v.MtoD_ME End Else 0 End) Else 0 End) As Total
	, Sum(Case(v.IB_Anulado) when 0 then Case(v.IC_TipAfec) When ''S'' Then Case(v.Cd_MdRg) when ''01'' then 0.00 else v.MtoH_ME-v.MtoD_ME end else 0 end else 0 end) BIM_ME
from 
	Voucher v
	inner join Empresa e on v.RucE=e.Ruc
	left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta --and isnull(p.IB_IGV,0)<>0
where v.RucE='''+Convert(Varchar,@RucE)+''' and v.Ejer='''+Convert(Varchar,@Eje)+''' and v.Prdo between '''+Convert(Varchar,@Rprdo1)+''' and '''+Convert(Varchar,@Rprdo2)+'''
	and v.Cd_Fte=''RV''
Group by 
	v.RucE,v.RegCtb,v.CamMda,v.IB_Anulado
) As t1 on t1.RucE=t.RucE and t1.RegCtb=t.RegCtb
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
