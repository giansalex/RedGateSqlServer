SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Fab_FabEtaResCrea]

@RucE nvarchar(11),
@Cd_Fab char(10),
@ID_Eta int,
@Cd_Flujo char(10),
@ID_Prc int,
@fec datetime,
@Cd_Prod char(7),
@ID_UMP int,
@ID_Res int output,
@Cant numeric(15,7),
@Costo numeric(15,7),
@Costo_ME numeric(15,7),
@msj varchar(100) output
as
declare @ID_EtaRes int
set @ID_EtaRes = dbo.ID_EtaRes(@RucE ,@Cd_Fab ,@Cd_Flujo , @ID_Eta)

insert into FabEtaRes(RucE, Cd_Fab, ID_Eta, ID_EtaRes, Cd_Flujo, ID_Prc, fec,ID_Res, Cd_Prod, ID_UMP, Cant, Costo, Costo_ME)
	  values(@RucE, @Cd_Fab, @ID_Eta, @ID_EtaRes, @Cd_Flujo, @ID_Prc, @fec, @ID_Res, @Cd_Prod, @ID_UMP, @Cant, @Costo, @Costo_ME)

if @@rowcount <= 0
	set @msj = 'Resultado para Etapa no pudo ser ingresado'
GO
