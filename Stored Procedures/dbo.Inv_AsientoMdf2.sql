SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AsientoMdf2] --<Procedimiento que modifica los asientos>
@RucE nvarchar(11),
@Cd_MIS char(3),
@Item int,
@Cta char(10),
@IC_CaAb char(1),
@Cd_IV char(3),
@Porc numeric(5,2),
@Fmla varchar(200),
@FmlaUsu varchar(300),
@IC_PFI char(1),
@Glosa varchar(200),
@GlosaUsu varchar(200),
@IC_VFG char(1),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@IC_JDCC char(1),
@IB_Aux bit,
@IC_JDCtaPA char(1),
@IN_TipoCta int,
@IB_EsDes bit,
@IB_JalaAmr bit,
@Ejer varchar(4),
@CtaME char(10),
@Cd_IA char(1),
@msj varchar(100) output
as
if not exists(select * from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item and Ejer=@Ejer)
	set @msj = 'Asiento no existe'
else
begin
	update Asiento set Cta=@Cta, IC_JDCtaPA = @IC_JDCtaPA, IN_TipoCta=@IN_TipoCta, IC_CaAB=@IC_CaAB,Cd_IV=@Cd_IV,Porc=@Porc,Fmla=@Fmla,FmlaUsu=@FmlaUsu,
				IC_PFI=@IC_PFI,Glosa=@Glosa,GlosaUsu=@GlosaUsu,IC_VFG=@IC_VFG,Cd_CC=@Cd_CC,
				Cd_SC=@Cd_SC,Cd_SS=@Cd_SS,IC_JDCC=@IC_JDCC,IB_Aux=@IB_Aux, IB_EsDes=@IB_EsDes, IB_JalaAmr=@IB_JalaAmr, Ejer=@Ejer, CtaME=@CtaME,
				Cd_IA=@Cd_IA			
	where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item and Ejer=@Ejer

	if @@rowcount <= 0
	set @msj = 'Asiento no pudo ser modificado'	
end
------------
--JJ : 17-02-2011 - <Creacion del procedimiento almacenado>
GO
