SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[prueba]()
returns nvarchar(2000) AS
begin 
     declare @cons nvarchar(2000)
	set @cons='select RucE,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,
	 IC_ASM,IB_GCB,IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,
	 IB_MdTsr,IB_MdPrs,IB_MdInv,Cd_Blc,Cd_EGPN,Cd_EGPF,IB_CtasXCbr,
	 IB_CtasXPag,Estado,Cd_Mda,IC_IEF,IC_IEN,NroCtaH1,NomCtaH1,NroCtaH2,
	 NomCtaH2 from dbo.PlanCtas where RucE=''20266194324'''
     return @cons
end

GO
