SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasMdf3]
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
@Cd_Mda nvarchar(2),
@IC_IEN varchar(2),
@IC_IEF varchar(2),
@msj varchar(100) output
as
if not exists (select * from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)
	set @msj = 'Cuenta no existe'
else
begin

/*
	if (select NomCta from PlanCtas where RucE=@RucE and NroCta=@NroCta) <> @NomCta
	begin 
		set @msj = 'Restricción: No es posible modificar el nombre de la cuenta'
		return
	end
*/

	update PlanCtas set NomCta=@NomCta, Nivel=@Nivel, IB_Aux=@IB_Aux, IB_CC=@IB_CC, IB_DifC=@IB_DifC, 
                            IC_ACV=@IC_ACV, IC_ASM=@IC_ASM, IB_GCB=@IB_GCB, IB_Psp=@IB_Psp, 
                            IB_CtaD=@IB_CtaD,IB_MdVta=@IB_MdVta, IB_MdCom=@IB_MdCom, IB_MdCtb=@IB_MdCtb, IB_MdTsr=@IB_MdTsr, IB_MdPrs=@IB_MdPrs, IB_MdInv=@IB_MdInv, Cd_Blc=@Cd_Blc, Cd_EGPN=@Cd_EGPN, Cd_EGPF=@Cd_EGPF, 
			IB_CtasXCbr=@IB_CtasXCbr,IB_CtasXPag=@IB_CtasXPag,Estado=@Estado,Cd_Mda=@Cd_Mda, IC_IEN=@IC_IEN, IC_IEF=@IC_IEF
	where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer

	if @@rowcount <= 0
	   set @msj = 'Cuenta no pudo ser modificado'
end
--JD: 27-03-09 agregue campos
--J : 15-12-09 se agrego el campo Codigo de moneda
--PV : 14/04/2010 se restringio la modificacion de nombre cuenta
print @msj
GO
