SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasCrea8]
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
@IB_MdVta bit,
@IB_MdCom bit,
@IB_MdCtb bit,
@IB_MdTsr bit,
@IB_MdPrs bit,
@IB_MdInv bit,
@Cd_Blc nvarchar(4),
@Cd_EGPN nvarchar(4),
@Cd_EGPF nvarchar(4),
@IB_CtasXCbr bit,
@IB_CtasXPag bit,
------------------------------------
@Cd_Mda nvarchar(2),
@IC_IEN varchar(2),
@IC_IEF varchar(2),
@NroCtaH1 varchar(15),
@NomCtaH1 varchar(150),
@NroCtaH2 varchar(15),
@NomCtaH2 varchar(150),
@IB_PFC bit,
--@Estado bit,
@AplicarCambios bit,

@IB_NDoc bit,

@msj varchar(100) output
as
if exists (select * from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)
	set @msj = 'Cuenta ya existe'
else
begin
	insert into PlanCtas(RucE,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,
			     IC_ASM,IB_GCB,IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,Cd_Blc,Cd_EGPN,Cd_EGPF, IB_CtasXCbr,IB_CtasXPag,Estado,Cd_Mda,IC_IEN,IC_IEF,NroCtaH1,NomCtaH1,NroCtaH2,NomCtaH2,Ejer,IB_PFC,IB_NDoc)
		      values(@RucE,@NroCta,@NomCta,@Nivel,@IB_Aux,@IB_CC,@IB_DifC,@IC_ACV,
			    @IC_ASM,@IB_GCB,@IB_Psp,@IB_CtaD,@IB_MdVta,@IB_MdCom,@IB_MdCtb,@IB_MdTsr,@IB_MdPrs,@IB_MdInv,@Cd_Blc,@Cd_EGPN,@Cd_EGPF,@IB_CtasXCbr,@IB_CtasXPag,1,@Cd_Mda,@IC_IEN,@IC_IEF,@NroCtaH1,@NomCtaH1,@NroCtaH2,@NomCtaH2,@Ejer,@IB_PFC,@IB_NDoc)


	if @@rowcount <= 0
	   set @msj = 'Cuenta no pudo ser registrado'

--FL: INICIO	
if(@AplicarCambios=1)
begin
Update PlanCtas
	Set IC_IEN=@IC_IEN, IC_IEF=@IC_IEF, Cd_EGPN=@Cd_EGPN, Cd_EGPF=@Cd_EGPF, Cd_Blc=@Cd_Blc
	where 
	RucE=@RucE 
	and Ejer=@Ejer and 
	(NroCta like @NroCta+'%')
/*CODIGO ANTERIOR
	Update PlanCtas
	Set IC_IEN=@IC_IEN, IC_IEF=@IC_IEF, Cd_EGPN=@Cd_EGPN, Cd_EGPF=@Cd_EGPF, Cd_Blc=@Cd_Blc
	where 
	RucE=@RucE 
	and Ejer=@Ejer and 
	(NroCta=@NroCta 
	or (
	   (Left(NroCta,6) = Left(@NroCta,6) and Len(NroCta)=6)
	or (Left(NroCta,4) = Left(@NroCta,4)  and Len(NroCta)=4)
	or (Left(NroCta,2) = Left(@NroCta,2)  and Len(NroCta)=2)
	)) 
*/
end
--FL: FIN
	
end
print @msj
----------------------LEYENDA----------------------
--FL: 15/06/2011 <creacion del sp con la nueva funcionalidad que pidio Juan>


GO
