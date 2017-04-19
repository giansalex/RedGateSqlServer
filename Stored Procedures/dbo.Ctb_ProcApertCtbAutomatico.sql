SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ctb_ProcApertCtbAutomatico]
@RucE varchar(11),
@Ejer varchar(4),
@RegCtb varchar(15),
@UsuCrea varchar(20),
@msj varchar(100) output
as


declare @EjerAnt char(4)
set @EjerAnt=convert(varchar,  Convert(int,@Ejer) - 1)


declare @Consulta varchar(8000)

	set @Consulta='select 1 id,
		v.RucE, '''+@Ejer+''' as Ejer, ''00'' as Prdo, '''+@RegCtb+''' as RegCtb, ''LD'' as Cd_Fte, ''01/01/'+@Ejer+''' as FecMov, min(FecCbr) as FecCbr, 
		v.NroCta, null as Cd_Aux, Cd_TD, NroSre, NroDoc, min(FecED) as FecED, min(FecVD) as FecVD,  ''***ASIENTO DE APERTURA***'' as Glosa, .0 MtoOr,
		case when sum(v.MtoD-v.MtoH)>0 then sum(v.MtoD-v.MtoH) else 0 end MtoD, 
		case when sum(v.MtoD-v.MtoH)<0 then -sum(v.MtoD-v.MtoH) else 0 end MtoH, 
		case when sum(v.MtoD_ME-v.MtoH_ME)>0 then sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoD_ME, 
		case when sum(v.MtoD_ME-v.MtoH_ME)<0 then -sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoH_ME, 
		null as Cd_MdOr,
		isnull(max(p.Cd_Mda),''01'') as Cd_MdRg, case when sum(v.MtoD_ME-v.MtoH_ME) != 0 then sum(v.MtoD-v.MtoH)/sum(v.MtoD_ME-v.MtoH_ME) else 2.5 end as CamMda,
		Cd_CC, Cd_SC, Cd_SS, ''010101'' as Cd_Area, ''03'' as Cd_MR, ''01'' Cd_TG, ''A'' as IC_CtrMd, null as IC_TipAfec,
		null as TipOper, null NroChke, null as Grdo, null as IB_Cndo, null as IB_Conc, null as IB_EsProv, 0 as IB_Anulado, null as DR_CdVou, null as DR_FecED, null as DR_CdTD, null as DR_NSre,
		null as DR_NDoc, null as IC_Gen, null as FecConc, null as IB_EsDes, null as DR_NCND, null as DR_NroDet, null as DR_FecDet, Cd_Clt, Cd_Prv, null as IB_Imdo,
		null as CA01, null as CA02	, '''+@UsuCrea+''' as UsuCrea	, null msj
	from 
		Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and p.Cd_Blc is not null
	where 
		v.RucE='''+@RucE+''' 	and v.Ejer='''+@EjerAnt+''' and v.IB_Anulado = 0  and v.Prdo != ''14''
	Group by v.RucE, v.NroCta, Cd_TD, NroSre, NroDoc, Cd_Clt, Cd_Prv, Cd_CC, Cd_SC, Cd_SS
	having sum(v.MtoD_ME-v.MtoH_ME) + sum(v.MtoD-v.MtoH) != 0
	union all
	select 2,
		v.RucE, '''+@Ejer+''' as Ejer, ''00'' as Prdo, '''+@RegCtb+''' as RegCtb, ''LD'' as Cd_Fte, ''01/01/'+@Ejer+''' as FecMov, ''01/01/'+@Ejer+''' as FecCbr, 
		(select min(REjer) from PlanCtasDef where RucE='''+@RucE+''' 	and Ejer='''+@EjerAnt+''') as NroCta, 
		null as Cd_Aux, null as Cd_TD, null as NroSre, null as NroDoc, null as FecED, null as FecVD,  ''***ASIENTO DE APERTURA***'' as Glosa, .0 MtoOr,
		case when sum(v.MtoD-v.MtoH)<0 then -sum(v.MtoD-v.MtoH) else 0 end MtoD, 
		case when sum(v.MtoD-v.MtoH)>0 then sum(v.MtoD-v.MtoH) else 0 end MtoH, 
		case when sum(v.MtoD_ME-v.MtoH_ME)<0 then -sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoD_ME, 
		case when sum(v.MtoD_ME-v.MtoH_ME)>0 then sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoH_ME, 
		null as Cd_MdOr,
		isnull(max(p.Cd_Mda),''01'') as Cd_MdRg, sum(v.MtoD-v.MtoH)/sum(v.MtoD_ME-v.MtoH_ME) as CamMda,
		''01010101'' as Cd_CC, ''01010101'' as Cd_SC, ''01010101'' as Cd_SS, ''010101'' as Cd_Area, ''03'' as Cd_MR, ''01'' Cd_TG, ''A'' as IC_CtrMd, null as IC_TipAfec,
		null as TipOper, null NroChke, null as Grdo, null as IB_Cndo, null as IB_Conc, null as IB_EsProv, 0 as IB_Anulado, null as DR_CdVou, null as DR_FecED, null as DR_CdTD, null as DR_NSre,
		null as DR_NDoc, null as IC_Gen, null as FecConc, null as IB_EsDes, null as DR_NCND, null as DR_NroDet, null as DR_FecDet, null as Cd_Clt, null as Cd_Prv, null as IB_Imdo,
		null as CA01, null as CA02	, '''+@UsuCrea+''' as UsuCrea	, null msj
	from 
		Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and p.Cd_Blc is not null
	where
		v.RucE='''+@RucE+''' 	and v.Ejer='''+@EjerAnt+'''  and v.IB_Anulado = 0  and v.Prdo != ''14''
	Group by v.RucE 
	having sum(v.MtoD_ME-v.MtoH_ME) + sum(v.MtoD-v.MtoH) != 0 order by id, v.RucE, v.NroCta'	
	print @Consulta
	exec (@Consulta)
/*
--Declarando un BIT para mostrar o no el asiento inicial
declare @ArmaCons bit

if not exists (Select top 1 * from voucher Where RucE=@RucE and Ejer=Convert(varchar,@EjerAnt) and Prdo='13')
Begin
	set @msj='No se encontro el cierre de resultados del ejercicio anterior'
	set @ArmaCons=0
End else if not exists(Select top 1 * from voucher Where RucE=@RucE and Ejer=Convert(varchar,@EjerAnt) and Prdo='14')
Begin
	set @msj='No se encontro el cierre de balance del ejercicio anterior'
	set @ArmaCons=0
End else if exists (select top 1 *from voucher where RucE=@RucE and Ejer=@Ejer and Prdo='00')
Begin
	set @msj='Ya existe un asiento de apertura'
	set @ArmaCons=1
End else set @ArmaCons=1


if(ISNULL(@ArmaCons,0)=1)
BEGIN
	print Convert(varchar,@EjerAnt)
	declare @Consulta varchar(8000)
	declare @Inter varchar(300)
	declare @Cond varchar(4000)
	declare @Glosa varchar(100)
	set @Glosa='Asiento Inicial'

	select 
	v.RucE, @Ejer Ejer, '00' As Prdo, @RegCtb As RegCtb, 'LD' As Cd_Fte
	, '2012-01-01 00:00:00' As FecMov, '2012-01-01 00:00:00' As FecCbr
	, v.NroCta, null As Cd_Aux, null As Cd_TD, null As NroSre
	, null As NroDoc, '2012-01-01 00:00:00' As FecED, Null As FecVD
	, 'ASIENTO INICIAL' As Glosa, .0 MtoOr, v.MtoH as MtoD, v.MtoD As MtoH
	, v.MtoH_ME As MtoD_ME, v.MtoD_ME As MtoH_ME, v.Cd_MdOr
	, v.Cd_MdRg, v.CamMda, v.Cd_CC, v.Cd_SC, v.Cd_SS, v.Cd_Area
	, v.Cd_MR, v.Cd_TG, v.IC_CtrMd, v.IC_TipAfec, v.TipOper, v.NroChke
	, v.Grdo, v.IB_Conc, v.IB_EsProv, v.IB_Anulado, null As DR_CdVou, null As DR_FecED
	, null As DR_CdTD, null As DR_NSre, null As DR_NDoc, null As IC_Gen, null As FecConc
	, null As IB_EsDes, null As DR_NCND, null As DRNroDet, null As DR_FecDet, null As Cd_Clt
	, null As Cd_Prv, null As IB_Imdo, null As CA01, null As CA02, @UsuCrea As UsuCrea
from 
	voucher v 
Where 
	v.RucE=@RucE and v.Ejer=Convert(varchar,@EjerAnt) and v.Prdo='14'-- in('13','14')
END
*/

--PRUEBAS:
--[Ctb_ProcApertCtbAutomatico] '11111111111','2013','CTGE_LD00-00001','seric',null
GO
