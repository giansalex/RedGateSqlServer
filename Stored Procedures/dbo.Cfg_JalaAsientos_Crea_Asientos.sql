SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Cfg_JalaAsientos_Crea_Asientos]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@Ejer varchar(4),
@EjerBase varchar(4),
@Cd_MIS  char(3)
As

declare @Item int


declare @Cta char(10)
declare @CtaME char(10)
declare @IC_JDCtaPA char(1)
declare @IC_CaAb char(1)
declare @IN_TipoCta int
declare @Cd_IV char(3)
declare @Porc numeric(5,2)
declare @Fmla varchar(200)
declare @FmlaUsu varchar(300)
declare @IC_PFI char(1)
declare @Glosa varchar(200)
declare @GlosaUsu varchar(200)
declare @IC_VFG char(1)
declare @Cd_CC nvarchar(8)
declare @Cd_SC nvarchar(8)
declare @Cd_SS nvarchar(8)
declare @IC_JDCC char(1)
declare @IB_Aux bit
declare @IB_EsDes bit
declare @IB_JalaAmr bit
declare @Cd_IA char(1)
declare @IC_ES char(1)
declare @Cd_TM char(2) --Tipo Movimiento


declare _Curs Cursor for
 	select	Cta,CtaME,IC_JDCtaPA,IC_CaAb,IN_TipoCta,Cd_IV,Porc,Fmla,FmlaUsu,IC_PFI,Glosa,
	GlosaUsu,IC_VFG,Cd_CC,Cd_SC,Cd_SS,IC_JDCC,IB_Aux,IB_EsDes,IB_JalaAmr,Cd_IA,IC_ES,Cd_TM
	from asiento where	ruce=@RucEBase and Ejer=@EjerBase and Cd_MIS=@Cd_MIS

Open _Curs
Fetch Next From _Curs Into @Cta,@CtaME,@IC_JDCtaPA,@IC_CaAb,@IN_TipoCta,@Cd_IV,@Porc,@Fmla,@FmlaUsu,@IC_PFI,@Glosa,
							@GlosaUsu,@IC_VFG,@Cd_CC,@Cd_SC,@Cd_SS,@IC_JDCC,@IB_Aux,@IB_EsDes,@IB_JalaAmr,@Cd_IA,@IC_ES,@Cd_TM
while @@fetch_status=0
Begin



	set @Item=[User123].[Item](@RucE,@Cd_MIS,@Ejer)

	insert into asiento (RucE,Cd_MIS,Ejer,Item,Cta,CtaME,IC_JDCtaPA,IC_CaAb,IN_TipoCta,Cd_IV,Porc,Fmla,FmlaUsu,IC_PFI,Glosa,
		GlosaUsu,IC_VFG,Cd_CC,Cd_SC,Cd_SS,IC_JDCC,IB_Aux,IB_EsDes,IB_JalaAmr,Cd_IA,IC_ES,Cd_TM)
				  values(@RucE,@Cd_MIS,@Ejer,@Item,@Cta,@CtaME,@IC_JDCtaPA,@IC_CaAb,@IN_TipoCta,@Cd_IV,@Porc,@Fmla,@FmlaUsu,@IC_PFI,@Glosa,
			@GlosaUsu,@IC_VFG,@Cd_CC,@Cd_SC,@Cd_SS,@IC_JDCC,@IB_Aux,@IB_EsDes,@IB_JalaAmr,@Cd_IA,@IC_ES,@Cd_TM)
	
	Fetch Next From _Curs Into @Cta,@CtaME,@IC_JDCtaPA,@IC_CaAb,@IN_TipoCta,@Cd_IV,@Porc,@Fmla,@FmlaUsu,@IC_PFI,@Glosa,
							@GlosaUsu,@IC_VFG,@Cd_CC,@Cd_SC,@Cd_SS,@IC_JDCC,@IB_Aux,@IB_EsDes,@IB_JalaAmr,@Cd_IA,@IC_ES,@Cd_TM
End

Close _Curs
Deallocate _Curs


--PV: 17-02-2017: Se agrego campos @IC_ES,@Cd_TM ya que no los estaba copiando
GO
