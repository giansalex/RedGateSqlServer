SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_FabEtaInsCrea]

@RucE nvarchar(11),
@Cd_Fab char(10),
@ID_Eta int,
@Cd_Flujo char(10),
@ID_Prc int,
@fec datetime,
@Cd_Prod char(7),
@ID_UMP int,
@ID_Ins int output,
@Cant numeric(15,7),
@Costo numeric(15,7),
@Costo_ME numeric(15,7),
@CantInsTotal decimal(13,7),
@msj varchar(100) output
as
declare @ID_EtaIns int
set @ID_EtaIns = dbo.ID_EtaIns(@RucE ,@Cd_Fab ,@Cd_Flujo , @ID_Eta)

insert into FabEtaIns(RucE, Cd_Fab, ID_Eta, ID_EtaIns, Cd_Flujo, ID_Prc, fec,ID_Ins, Cd_Prod, ID_UMP, Cant, Costo, Costo_ME, CantInsTotal)
	  values(@RucE, @Cd_Fab, @ID_Eta, @ID_EtaIns, @Cd_Flujo, @ID_Prc, @fec, @ID_Ins, @Cd_Prod, @ID_UMP, @Cant, @Costo, @Costo_ME,@CantInsTotal)

if @@rowcount <= 0
	set @msj = 'Insumo para Etapa no pudo ser ingresado'
GO
