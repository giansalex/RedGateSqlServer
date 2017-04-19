SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Ctb_PrdoCrea]
@RucE nvarchar(11),
@Ejer nvarchar(4),
/*
@P00 bit,
@P01 bit,
@P02 bit,
@P03 bit,
@P04 bit,
@P05 bit,
@P06 bit,
@P07 bit,
@P08 bit,
@P09 bit,
@P10 bit,
@P11 bit,
@P12 bit,
@P13 bit,
@P14 bit,
*/
@msj varchar(100) output
as
if not exists (select * from Empresa where Ruc=@RucE)
	set @msj = 'Empresa no existe'
else if exists (select * from Periodo where RucE=@RucE and Ejer=@Ejer)
	set @msj = 'Ya existe Ejercicio'
else
begin
	Insert into Periodo(RucE,Ejer,P00,P01,P02,P03,P04,P05,P06,P07,P08,P09,P10,P11,P12,P13,P14)
	             Values(@RucE,@Ejer,'1','0','0','0','0','0','0','0','0','0','0','0','0','0','0')
	
	if @@rowcount <= 0
	   set @msj = 'Ejercicio no pudo ser creado'
	else
	--Agregamos Cta General
		insert into PlanCtas(RucE,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,IC_ASM,IB_GCB,IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MDPrs,IB_MdInv,Cd_Blc,Cd_EGPN,Cd_EGPF,IB_CtasXCbr,IB_CtasXPag,Estado,Cd_Mda,IC_IEF,IC_IEN,Ejer)
		values(@RucE,'9999999999','GENERAL',4,0,0,0,'c','s',0,0,0,1,1,1,1,1,1,null,null,null,1,1,1,null,null,null,@Ejer)
		
		insert into PlanCtasDef(RucE,IGV,ISC,QCtg,RCons,Perc,Det,Ret,LCm,DC_MN,DC_ME,DP_MN,DP_ME,DCPer,DCGan,IN_DigCls,Ejer,Rejer)
		values(@RucE,'9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999',6,@Ejer,'9999999999')
	
end
print @msj
GO
