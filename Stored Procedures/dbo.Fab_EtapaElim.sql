SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_EtapaElim]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Eta int,
@ID_Prc int,
@msj varchar(100) output
as
if not exists (select ID_Eta from FabEtapa where RucE=@RucE and Cd_Flujo=@Cd_Flujo and ID_Eta=@ID_Eta and ID_Prc=@ID_Prc)
	set @msj = 'Etapa no existe'
else
begin

	begin transaction
	delete FabEtaRes where RucE=@RucE and Cd_Flujo=@Cd_Flujo and ID_Eta=@ID_Eta and ID_Prc=@ID_Prc
	delete FabEtains where RucE=@RucE and Cd_Flujo=@Cd_Flujo and ID_Eta=@ID_Eta and ID_Prc=@ID_Prc
	delete FabEtapa where RucE=@RucE and Cd_Flujo=@Cd_Flujo and ID_Eta=@ID_Eta and ID_Prc=@ID_Prc
	if @@rowcount <= 0
		set @msj = 'Etapa no pudo ser eliminado'
	commit transaction
	
end
print @msj
GO
