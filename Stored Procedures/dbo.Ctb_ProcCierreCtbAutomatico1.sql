SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--select *from Voucher where RucE='11111111111' and Ejer='2011' and Prdo='13'
--[dbo].[Ctb_ProcCierreCtbAutomatico1] '11111111111','2011','CTGN_LD01-000001','0001','00001','00001','00000',2.654,'13','jvega',null
CREATE proc [dbo].[Ctb_ProcCierreCtbAutomatico1]
@RucE varchar(11),
@Ejer varchar(4),
@RegCtb varchar(15),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@Cd_Area varchar(6),
@CamMda decimal(6,3),
@Prdo Varchar(2),
@UsuCrea varchar(20),
@msj varchar(100) output
as

set @msj=''
if exists (select *from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo)
	set @msj='El asiento de cierre ya existe'
if(@Prdo='13')
begin
--Cierre de balance Globalizado
Select
	Cons.RucE, Cons.Ejer, Cons.Prdo, @RegCtb As RegCtb, 'LD' As Cd_Fte
	, '2012-12-31 00:00:00' As FecMov, '2012-12-31 00:00:00' As FecCbr
	, Cons.NroCta, Null As Cd_Aux, Null As Cd_TD, Null As NroSre
	, Null As NroDoc, '2012-12-31 00:00:00' As FecED, Null As FecVD
	, 'CIERRE DE BALANCE' As Glosa, .0 MtoOr
	--, p.NomCta, Cons.MtoD, Cons.MtoH, Cons.Saldo
	, Case When Cons.Saldo < 0 Then Cons.Saldo*-1 Else .0 End As MtoD
	, Case When Cons.Saldo >= 0 Then Cons.Saldo Else .0 End As MtoH
	--, Cons.MtoD_ME, Cons.MtoH_ME, Cons.Saldo_ME
	, case when Saldo_ME < 0 then Saldo_ME*-1 else .0 end as MtoD_ME
	, case when Saldo_ME >=0 then Saldo_ME else .0 end as MtoH_ME
	, null As Cd_MdOr
	, isnull(p.Cd_Mda,'01') As Cd_MdRg
	, @CamMda As CamMda
	, @Cd_CC As Cd_CC, @Cd_SC As Cd_SC, @Cd_SS As Cd_SS, @Cd_Area As Cd_Area
	, '03' As Cd_MR, '01' Cd_TG, 'A' As IC_CtrMd, Null As IC_TipAfec
	, Null As TipOper, Null NroChke, Null As Grdo, Null As IB_Cndo, Null As IB_Conc
	, Null As IB_EsProv, 0 As IB_Anulado, Null As DR_CdVou, Null As DR_FecED, Null As DR_CdTD, Null As DR_NSre
	, Null As DR_NDoc, Null As IC_Gen, Null As FecConc, Null As IB_EsDes, Null As DR_NCND, Null As DR_NroDet
	, Null As DR_FecDet, Null As Cd_Clt, Null As Cd_Prv, Null As IB_Imdo
	, Null As CA01, Null As CA02
	, @UsuCrea as UsuCrea
	, isnull(@msj,'') msj
from (
	select
		v.RucE, v.Ejer, '13' as Prdo
		, v.NroCta
		, SUM(v.MtoD) MtoD
		, SUM(v.MtoH) MtoH
		, SUM(v.MtoD - MtoH) Saldo
		, SUM(v.MtoD_ME) MtoD_ME
		, SUM(v.MtoH_ME) MtoH_ME
		, SUM(v.MtoD_ME - MtoH_ME) Saldo_ME
	from 
		Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		and isnull(p.Cd_Blc,'')<>''
	where 
		v.RucE=@RucE 
		and v.Ejer=@Ejer
	Group by v.RucE,v.Ejer, v.NroCta
) as cons inner join PlanCtas p on p.RucE=cons.RucE and p.Ejer=cons.Ejer and p.NroCta=cons.NroCta
End
else if(@Prdo='14')
--Cierre de resultados
Begin

	select 
		v.RucE, v.Ejer, v.Prdo, @RegCtb As RegCtb, 'LD' As Cd_Fte
		, '2012-12-31 00:00:00' As FecMov, '2012-12-31 00:00:00' As FecCbr
		, v.NroCta, Null As Cd_Aux, Null As Cd_TD, Null As NroSre
		, Null As NroDoc, '2012-12-31 00:00:00' As FecED, Null As FecVD
		, 'CIERRE DE RESULTADOS' As Glosa, .0 MtoOr
		--Revisar
		, Case When v.Saldo < 0 Then v.Saldo*-1 Else .0 End As MtoD
		, Case When v.Saldo >= 0 Then v.Saldo Else .0 End As MtoH
		--Revisar
		, case when Saldo_ME < 0 then Saldo_ME*-1 else .0 end as MtoD_ME
		, case when Saldo_ME >=0 then Saldo_ME else .0 end as MtoH_ME
		, null As Cd_MdOr
		, isnull(p.Cd_Mda,'01') As Cd_MdRg
		, @CamMda As CamMda
		, @Cd_CC As Cd_CC, @Cd_SC As Cd_SC, @Cd_SS As Cd_SS, @Cd_Area As Cd_Area
		, '03' As Cd_MR, '01' Cd_TG, 'A' As IC_CtrMd, Null As IC_TipAfec
		, Null As TipOper, Null NroChke, Null As Grdo, Null As IB_Cndo, Null As IB_Conc
		, Null As IB_EsProv, 0 As IB_Anulado, Null As DR_CdVou, Null As DR_FecED, Null As DR_CdTD, Null As DR_NSre
		, Null As DR_NDoc, Null As IC_Gen, Null As FecConc, Null As IB_EsDes, Null As DR_NCND, Null As DR_NroDet
		, Null As DR_FecDet, Null As Cd_Clt, Null As Cd_Prv, Null As IB_Imdo
		, Null As CA01, Null As CA02
		, @UsuCrea as UsuCrea
		, isnull(@msj,'') msj
	from (
		select
			v.RucE, v.Ejer, '14' as Prdo
			, v.NroCta
			, SUM(v.MtoD) MtoD
			, SUM(v.MtoH) MtoH
			, SUM(v.MtoD - MtoH) Saldo
			, SUM(v.MtoD_ME) MtoD_ME
			, SUM(v.MtoH_ME) MtoH_ME
			, SUM(v.MtoD_ME - MtoH_ME) Saldo_ME
		from 
			Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
			and (isnull(Cd_EGPN,'')<>'' or ISNULL(Cd_EGPF,'')<>'')
			and isnull(p.Cd_Blc,'')=''
		where 
			v.RucE=@RucE 
			and v.Ejer=@Ejer
		Group by v.RucE,v.Ejer, v.NroCta	
	) as v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
End
GO
