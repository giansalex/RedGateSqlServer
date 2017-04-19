SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--select *from Voucher where RucE='11111111111' and Ejer='2011' and Prdo='13'
--[dbo].[Ctb_ProcCierreCtbAutomatico2] '11111111111','2011','CTGN_LD01-00001','0001','00001','00001','00000',2.654,2.655,'13','jvega',null
CREATE proc [dbo].[Ctb_ProcCierreCtbAutomatico2]
@RucE varchar(11),
@Ejer varchar(4),
@RegCtb varchar(15),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@Cd_Area varchar(6),
@TCCom decimal(6,3),
@TCVta decimal(6,3),
@Prdo Varchar(2),
@UsuCrea varchar(20),
@msj varchar(100) output
as
set @msj=''
if exists (select *from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo)
	set @msj='El asiento de cierre ya existe'
	
	
	
declare @Consulta varchar(8000)
if(@Prdo='14') 
begin
	set @Consulta='select 1 id,
		v.RucE, v.Ejer, ''14'' as Prdo, '''+@RegCtb+''' as RegCtb, ''LD'' as Cd_Fte, min(FecMov) as FecMov, min(FecCbr) as FecCbr, 
		v.NroCta, null as Cd_Aux, Cd_TD, NroSre, NroDoc, min(FecED) as FecED, min(FecVD) as FecVD,  ''CIERRE DE RESULTADOS'' as Glosa, .0 MtoOr,
		case when sum(v.MtoD-v.MtoH)<0 then -sum(v.MtoD-v.MtoH) else 0 end MtoD, 
		case when sum(v.MtoD-v.MtoH)>0 then sum(v.MtoD-v.MtoH) else 0 end MtoH, 
		case when sum(v.MtoD_ME-v.MtoH_ME)<0 then -sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoD_ME, 
		case when sum(v.MtoD_ME-v.MtoH_ME)>0 then sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoH_ME, 
		null as Cd_MdOr,
		isnull(max(p.Cd_Mda),''01'') as Cd_MdRg, case when sum(v.MtoD_ME-v.MtoH_ME) != 0 then sum(v.MtoD-v.MtoH)/sum(v.MtoD_ME-v.MtoH_ME) else 2.5 end as CamMda,
		'''+@Cd_CC+''' as Cd_CC, '''+@Cd_SC+''' as Cd_SC, '''+@Cd_SS+''' as Cd_SS, '''+@Cd_Area+''' as Cd_Area, ''03'' as Cd_MR, ''01'' Cd_TG, ''A'' as IC_CtrMd, null as IC_TipAfec,
		null as TipOper, null NroChke, null as Grdo, null as IB_Cndo, null as IB_Conc, null as IB_EsProv, 0 as IB_Anulado, null as DR_CdVou, null as DR_FecED, null as DR_CdTD, null as DR_NSre,
		null as DR_NDoc, null as IC_Gen, null as FecConc, null as IB_EsDes, null as DR_NCND, null as DR_NroDet, null as DR_FecDet, min(Cd_Clt) as Cd_Clt, min(Cd_Prv) as Cd_Prv, null as IB_Imdo,
		null as CA01, null as CA02	, '''+@UsuCrea+''' as UsuCrea	, null msj
	from 
		Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and p.Cd_Blc is not null
	where 
		v.RucE='''+@RucE+''' 	and v.Ejer='''+@Ejer+''' and v.IB_Anulado = 0
	Group by v.RucE,v.Ejer, v.NroCta, Cd_TD, NroSre, NroDoc
	having sum(v.MtoD_ME-v.MtoH_ME) + sum(v.MtoD-v.MtoH) != 0
	union all
	select 2,
		v.RucE, v.Ejer, ''14'' as Prdo, '''+@RegCtb+''' as RegCtb, ''LD'' as Cd_Fte, ''31/12/'+@Ejer+''' as FecMov, ''31/12/'+@Ejer+''' as FecCbr, 
		(select min(REjer) from PlanCtasDef where RucE='''+@RucE+''' 	and Ejer='''+@Ejer+''') as NroCta, 
		null as Cd_Aux, null as Cd_TD, null as NroSre, null as NroDoc, null as FecED, null as FecVD,  ''CIERRE DE RESULTADOS'' as Glosa, .0 MtoOr,
		case when sum(v.MtoD-v.MtoH)>0 then sum(v.MtoD-v.MtoH) else 0 end MtoD, 
		case when sum(v.MtoD-v.MtoH)<0 then -sum(v.MtoD-v.MtoH) else 0 end MtoH, 
		case when sum(v.MtoD_ME-v.MtoH_ME)>0 then sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoD_ME, 
		case when sum(v.MtoD_ME-v.MtoH_ME)<0 then -sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoH_ME, 
		null as Cd_MdOr,
		isnull(max(p.Cd_Mda),''01'') as Cd_MdRg, sum(v.MtoD-v.MtoH)/sum(v.MtoD_ME-v.MtoH_ME) as CamMda,
		'''+@Cd_CC+''' as Cd_CC, '''+@Cd_SC+''' as Cd_SC, '''+@Cd_SS+''' as Cd_SS, '''+@Cd_Area+''' as Cd_Area, ''03'' as Cd_MR, ''01'' Cd_TG, ''A'' as IC_CtrMd, null as IC_TipAfec,
		null as TipOper, null NroChke, null as Grdo, null as IB_Cndo, null as IB_Conc, null as IB_EsProv, 0 as IB_Anulado, null as DR_CdVou, null as DR_FecED, null as DR_CdTD, null as DR_NSre,
		null as DR_NDoc, null as IC_Gen, null as FecConc, null as IB_EsDes, null as DR_NCND, null as DR_NroDet, null as DR_FecDet, null as Cd_Clt, null as Cd_Prv, null as IB_Imdo,
		null as CA01, null as CA02	, '''+@UsuCrea+''' as UsuCrea	, null msj
	from 
		Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and p.Cd_Blc is not null
	where
		v.RucE='''+@RucE+''' 	and v.Ejer='''+@Ejer+'''  and v.IB_Anulado = 0
	Group by v.RucE,v.Ejer 
	having sum(v.MtoD_ME-v.MtoH_ME) + sum(v.MtoD-v.MtoH) != 0 order by id, v.RucE,v.Ejer, v.NroCta'	
end
else if(@Prdo='13')
begin
	set @Consulta='select 1 id,
		v.RucE, v.Ejer, ''13'' as Prdo, '''+@RegCtb+''' as RegCtb, ''LD'' as Cd_Fte, ''31/12/'+@Ejer+''' as FecMov, ''31/12/'+@Ejer+''' as FecCbr, 
		v.NroCta, null as Cd_Aux, null as Cd_TD, null as NroSre, null as NroDoc, ''31/12/'+@Ejer+''' as FecED, ''31/12/'+@Ejer+''' as FecVD,  ''CIERRE DE BALANCE'' as Glosa, .0 MtoOr,
		case when sum(v.MtoD-v.MtoH)<0 then -sum(v.MtoD-v.MtoH) else 0 end MtoD, 
		case when sum(v.MtoD-v.MtoH)>0 then sum(v.MtoD-v.MtoH) else 0 end MtoH, 
		case when sum(v.MtoD_ME-v.MtoH_ME)<0 then -sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoD_ME, 
		case when sum(v.MtoD_ME-v.MtoH_ME)>0 then sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoH_ME, 
		null as Cd_MdOr,
		isnull(max(p.Cd_Mda),''01'') as Cd_MdRg, case when sum(v.MtoD_ME-v.MtoH_ME) != 0 then sum(v.MtoD-v.MtoH)/sum(v.MtoD_ME-v.MtoH_ME) else 2.5 end as CamMda,
		'''+@Cd_CC+''' as Cd_CC, '''+@Cd_SC+''' as Cd_SC, '''+@Cd_SS+''' as Cd_SS, '''+@Cd_Area+''' as Cd_Area, ''03'' as Cd_MR, ''01'' Cd_TG, ''A'' as IC_CtrMd, null as IC_TipAfec,
		null as TipOper, null NroChke, null as Grdo, null as IB_Cndo, null as IB_Conc, null as IB_EsProv, 0 as IB_Anulado, null as DR_CdVou, null as DR_FecED, null as DR_CdTD, null as DR_NSre,
		null as DR_NDoc, null as IC_Gen, null as FecConc, null as IB_EsDes, null as DR_NCND, null as DR_NroDet, null as DR_FecDet, min(Cd_Clt) as Cd_Clt, min(Cd_Prv) as Cd_Prv, null as IB_Imdo,
		null as CA01, null as CA02	, '''+@UsuCrea+''' as UsuCrea	, null msj
	from 
		Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and (Cd_EGPN is not null or Cd_EGPF is not null) and p.Cd_Blc is null
	where 
		v.RucE='''+@RucE+''' 	and v.Ejer='''+@Ejer+''' and v.IB_Anulado = 0
	Group by v.RucE,v.Ejer, v.NroCta
	having sum(v.MtoD_ME-v.MtoH_ME) + sum(v.MtoD-v.MtoH) != 0
	union all
	select 2,
		v.RucE, v.Ejer, ''13'' as Prdo, '''+@RegCtb+''' as RegCtb, ''LD'' as Cd_Fte, ''31/12/'+@Ejer+''' as FecMov, ''31/12/'+@Ejer+''' as FecCbr, 
		(select min(REjer) from PlanCtasDef where RucE='''+@RucE+''' 	and Ejer='''+@Ejer+''') as NroCta, 
		null as Cd_Aux, null as Cd_TD, null as NroSre, null as NroDoc, null as FecED, null as FecVD,  ''CIERRE DE BALANCE'' as Glosa, .0 MtoOr,
		case when sum(v.MtoD-v.MtoH)>0 then sum(v.MtoD-v.MtoH) else 0 end MtoD, 
		case when sum(v.MtoD-v.MtoH)<0 then -sum(v.MtoD-v.MtoH) else 0 end MtoH,  
		case when sum(v.MtoD_ME-v.MtoH_ME)>0 then sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoD_ME, 
		case when sum(v.MtoD_ME-v.MtoH_ME)<0 then -sum(v.MtoD_ME-v.MtoH_ME) else 0 end MtoH_ME, 
		null as Cd_MdOr,
		isnull(max(p.Cd_Mda),''01'') as Cd_MdRg, sum(v.MtoD-v.MtoH)/sum(v.MtoD_ME-v.MtoH_ME) as CamMda,
		'''+@Cd_CC+''' as Cd_CC, '''+@Cd_SC+''' as Cd_SC, '''+@Cd_SS+''' as Cd_SS, '''+@Cd_Area+''' as Cd_Area, ''03'' as Cd_MR, ''01'' Cd_TG, ''A'' as IC_CtrMd, null as IC_TipAfec,
		null as TipOper, null NroChke, null as Grdo, null as IB_Cndo, null as IB_Conc, null as IB_EsProv, 0 as IB_Anulado, null as DR_CdVou, null as DR_FecED, null as DR_CdTD, null as DR_NSre,
		null as DR_NDoc, null as IC_Gen, null as FecConc, null as IB_EsDes, null as DR_NCND, null as DR_NroDet, null as DR_FecDet, null as Cd_Clt, null as Cd_Prv, null as IB_Imdo,
		null as CA01, null as CA02	, '''+@UsuCrea+''' as UsuCrea	, null msj
	from 
		Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and (Cd_EGPN is not null or Cd_EGPF is not null) and p.Cd_Blc is null
	where
		v.RucE='''+@RucE+''' 	and v.Ejer='''+@Ejer+'''  and v.IB_Anulado = 0
	Group by v.RucE,v.Ejer 
	having sum(v.MtoD_ME-v.MtoH_ME) + sum(v.MtoD-v.MtoH) != 0 order by id, v.RucE,v.Ejer, v.NroCta'
		
end
Print 'Consulta '
print @consulta

exec (@Consulta)

--[dbo].[Ctb_ProcCierreCtbAutomatico2] '11111111111','2011','CTGN_LD14-00001','0001','00001','00001','00000',2.654,2.655,'14','jvega',null


--exec [dbo].[Ctb_ProcCierreCtbAutomatico2] '11111111111','2012','CTGE_LD14-00001','01010101','01010101','01010101','0001',2.549,2.551,'14','g.brian',null

GO
