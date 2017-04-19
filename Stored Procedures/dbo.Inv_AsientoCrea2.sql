SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_AsientoCrea2] --<Procedimiento que registra los asientos contables>
@RucE nvarchar(11),
@Ejer varchar(4), 
@Cd_MIS char(3),
@Item int,
@Cta char(10),
@IC_CaAb char(1),
@Cd_IV char(3),
@Porc numeric(5,2),
@Fmla varchar(200),
@FmlaUsu varchar(200),
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
@CtaME char(10),
@Cd_IA char(1),
@msj varchar(100) output

as
if exists (select * from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item)
	set @msj = 'Ya existe el asiento'
else
begin
	set @Item = user123.Item(@RucE,@Cd_MIS,@Ejer)
	insert into Asiento(RucE,Cd_MIS,Item,Cta,IC_JDCtaPA,IC_CaAb,IN_TipoCta,Cd_IV,Porc,Fmla,FmlaUsu,IC_PFI,Glosa,GlosaUsu,IC_VFG,Cd_CC,Cd_SC,Cd_SS,
		IC_JDCC,IB_Aux,IB_EsDes, IB_JalaAmr,Ejer,CtaME,Cd_IA)
	values(@RucE,@Cd_MIS,@Item,@Cta,@IC_JDCtaPA,@IC_CaAb,@IN_TipoCta,@Cd_IV,@Porc,@Fmla,@FmlaUsu,@IC_PFI,@Glosa,@GlosaUsu,@IC_VFG,@Cd_CC,@Cd_SC,@Cd_SS,
		@IC_JDCC,@IB_Aux,@IB_EsDes,@IB_JalaAmr,@Ejer,@CtaME,@Cd_IA)	
	
	if @@rowcount <= 0
	set @msj = 'Asiento no pudo ser registrado'	
end
------------
--J : -14-04-2010 - <Creacion del procedimiento almacenado>
--FL: -05-08-2010 - <Modificacion del sp con nuevos campos
--MM 19-11-2010 - <Modificacion del procedimiento almacenado por agregacion de campos>
--PV 25-01-2011 - Mdf: Se agrego @Ejer -- falta en la dao 
--FL: 26-01-2011 - Se cambio el sp para recibir ejer y CtaME




GO
