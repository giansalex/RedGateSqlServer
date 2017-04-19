SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImpCompCrea_2]

@RucE	nvarchar(11),
@Cd_IP	char(7),
@ItemIC int output,
--@Cd_Com char(10),
@Cd_Mda char(2),
@CamMda numeric (6,3),
@RegCtb nvarchar(15),
@NroCta nvarchar(10),
@CstAsig numeric (13,2),
@CstAsig_ME numeric (13,2),
@PorcAsig numeric (7,2),
@Cd_TipDist char(2),
@TipGasto char(1),
@TipInconterms char(3),
@msj varchar(100) output
as
set @ItemIC = dbo.ItemIC(@RucE, @Cd_IP)
insert into ImpComp (RucE,Cd_IP,ItemIC,RegCtb,NroCta,Cd_Mda,CamMda,CstAsig,CstAsig_ME,PorcAsig,Cd_TipDist,TipGasto,TipInconterms)
values (@RucE,@Cd_IP,@ItemIC,@RegCtb,@NroCta,@Cd_Mda,@CamMda,@CstAsig,@CstAsig_ME,@PorcAsig,@Cd_TipDist,@TipGasto,@TipInconterms)
if @@rowcount <= 0
	set @msj = 'El comprabante no pudo ser registrado'	

GO
