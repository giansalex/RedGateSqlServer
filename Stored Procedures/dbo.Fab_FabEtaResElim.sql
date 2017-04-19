SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Fab_FabEtaResElim]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,
@ID_EtaRes int,
@Cd_Fab char(10),
@ID_Eta int,
@msj varchar(100) output
as
if not exists (select ID_EtaRes from FabEtaRes where RucE = @RucE and Cd_Fab=@Cd_Fab and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc and ID_EtaRes = @ID_EtaRes and ID_Eta=@ID_Eta)
	set @msj = 'Resultado de la Etapa no existe'
else
begin
	delete FabEtaRes where RucE = @RucE and Cd_Fab=@Cd_Fab and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc and ID_EtaRes = @ID_EtaRes and ID_Eta=@ID_Eta
	
	if @@rowcount <= 0
		set @msj = 'Resultado de la Etapa no pudo ser eliminado'
end
GO
