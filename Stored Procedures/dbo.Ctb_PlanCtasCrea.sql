SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasCrea]
@RucE nvarchar(11),
@Ejer varchar(4),
@NroCta nvarchar(10),
@NomCta varchar(50),
@Nivel int,
@IB_Aux bit,
@IB_CC bit,
@IB_DifC bit,
@IC_ACV varchar(1),
@IC_ASM varchar(1),
@IB_GCB bit,
@IB_Psp bit,
@IB_CtaD bit,
-------------------------------------
--@IB_MdVta bit,
--@IB_MdCom bit,
--@IB_MdCtb bit,
--@IB_MdTsr bit,
--@IB_MdPrs bit,
--@IB_MdInv bit,
--@Cd_Blc nvarchar(4),
--@Cd_EGPN nvarchar(4),
--@Cd_EGPF nvarchar(4),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)
	set @msj = 'Cuenta ya existe'
else
begin
	insert into PlanCtas(RucE,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,
			     IC_ASM,IB_GCB,IB_Psp,IB_CtaD,Estado,Ejer)--IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,Cd_Blc,Cd_EGPN,Cd_EGPF,Estado)
		      values(@RucE,@NroCta,@NomCta,@Nivel,@IB_Aux,@IB_CC,@IB_DifC,@IC_ACV,
			     @IC_ASM,@IB_GCB,@IB_Psp,@IB_CtaD,1,@Ejer)--@IB_MdVta,@IB_MdCom,@IB_MdCtb,@IB_MdTsr,@IB_MdPrs,@IB_MdInv,@Cd_Blc,@Cd_EGPN,@Cd_EGPF,1)

	if @@rowcount <= 0
	   set @msj = 'Cuenta no pudo ser registrado'
end
--JD: 27-03-09 agregue campos en este sp
print @msj
GO
