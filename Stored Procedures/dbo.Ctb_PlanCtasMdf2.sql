SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasMdf2]
@RucE nvarchar(11),
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
@IB_MdVta bit,
@IB_MdCom bit,
@IB_MdCtb bit,
@IB_MdTsr bit,
@IB_MdPrs bit,
@IB_MdInv bit,
@Cd_Blc nvarchar(4),
@Cd_EGPN nvarchar(4),
@Cd_EGPF nvarchar(4),
@Estado bit,
@IB_CtasXCbr bit,
@IB_CtasXPag bit,
@msj varchar(100) output
as


set @msj = 'Para modificar cuenta, debe actualizar el sistema'

/*
if not exists (select * from PlanCtas where RucE=@RucE and NroCta=@NroCta)
	set @msj = 'Cuenta no existe'
else
begin
	update PlanCtas set NomCta=@NomCta, Nivel=@Nivel, IB_Aux=@IB_Aux, IB_CC=@IB_CC, IB_DifC=@IB_DifC, 
                            IC_ACV=@IC_ACV, IC_ASM=@IC_ASM, IB_GCB=@IB_GCB, IB_Psp=@IB_Psp, 
                            IB_CtaD=@IB_CtaD,IB_MdVta=@IB_MdVta, IB_MdCom=@IB_MdCom, IB_MdCtb=@IB_MdCtb, IB_MdTsr=@IB_MdTsr, IB_MdPrs=@IB_MdPrs, IB_MdInv=@IB_MdInv, Cd_Blc=@Cd_Blc, Cd_EGPN=@Cd_EGPN, Cd_EGPF=@Cd_EGPF, IB_CtasXCbr=@IB_CtasXCbr,IB_CtasXPag=@IB_CtasXPag,Estado=@Estado
	where RucE=@RucE and NroCta=@NroCta

	if @@rowcount <= 0
	   set @msj = 'Cuenta no pudo ser modificado'
end
--JD: 27-03-09 agregue campos
--PV: 14/04/2010  Mdf: se agrego msj actualizar sistema
*/
print @msj
GO
