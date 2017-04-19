SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--delete planctas where RucE='20494350026' and Ejer='2012' and NroCta not in('9999999999')
--select *from planctas where RucE='20494350026' and Ejer='2012' and NroCta not in('9999999999')
CREATE procedure [user321].[Cfg_JalaPlanCtas_Crea]
@RucBase nvarchar(11),
@EjerBase varchar(4),
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as

/*
declare @RucE nvarchar(11)
declare @Ejer varchar(4)
set @RucE='10424794819'
set @Ejer='2010'
*/


insert into PlanCtas(RucE,Ejer,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,IC_ASM,IB_GCB,IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,
		IB_MdInv,Cd_Blc,Cd_EGPN,Cd_EGPF,IB_CtasXCbr,IB_CtasXPag,Estado,Cd_Mda,IC_IEF,IC_IEN,NroCtaH1,NomCtaH1,NroCtaH2,NomCtaH2,IB_PFC,IB_NDoc) 
			select 	@RucE,@Ejer,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,IC_ASM,IB_GCB,IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,
		IB_MdInv,Cd_Blc,Cd_EGPN,Cd_EGPF,IB_CtasXCbr,IB_CtasXPag,Estado,Cd_Mda,IC_IEF,IC_IEN,NroCtaH1,NomCtaH1,NroCtaH2,NomCtaH2,IB_PFC,IB_NDoc
from 	PlanCtas Where RucE=@RucBase and ejer=@EjerBase and NroCta NOT IN ('9999999999')

	if @@rowcount <= 0
	set @msj = 'Plan de Ctas no pudo ser Copiado'
--select *from empresa
--10424794819

-- Leyenda --
--JJ 11/02/2011: <Creacion del Procedimiento almacenado>

GO
