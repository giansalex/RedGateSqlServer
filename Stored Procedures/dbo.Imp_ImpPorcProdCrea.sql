SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImpPorcProdCrea]

@RucE	nvarchar(11),
@Cd_IP	char(7),
@Item int,
@ItemIC int,
@CstAsig numeric (13,4),
@CstAsig_ME numeric (13,4),
@PorcAsig numeric (7,4),
@msj varchar(100) output
as

insert into ImpPorcProd (RucE,Cd_IP,Item,ItemIC,CstAsig,CstAsig_ME,PorcAsig)
values (@RucE,@Cd_IP,@Item,@ItemIC,@CstAsig,@CstAsig_ME,@PorcAsig)
if @@rowcount <= 0
	set @msj = 'la Asignacion del porcentaje no pudo ser registrado'	
GO
