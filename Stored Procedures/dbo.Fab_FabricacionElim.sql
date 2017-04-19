SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_FabricacionElim]

@RucE nvarchar(11),
@Cd_Fab char(10),
@Cd_Flujo char(10),
@msj varchar(100) output
as
if not exists (select Cd_Fab from FabFabricacion where RucE=@RucE and Cd_Flujo=@Cd_Flujo and Cd_Fab=@Cd_Fab)
	set @msj = 'Fabricacion no existe'
else
begin

	begin transaction
	
	delete FabEtaIns where RucE=@RucE and Cd_Fab=@Cd_Fab and Cd_Flujo=@Cd_Flujo
	delete FabEtaRes where RucE=@RucE and Cd_Fab=@Cd_Fab and Cd_Flujo=@Cd_Flujo
	delete FabEtapa where RucE=@RucE and Cd_Fab=@Cd_Fab and Cd_Flujo=@Cd_Flujo
	delete FabFabricacion where RucE=@RucE and Cd_Fab=@Cd_Fab and Cd_Flujo=@Cd_Flujo
	if @@rowcount <= 0
		set @msj = 'Fabricacion no pudo ser eliminado'
	commit transaction
	
	
end
print @msj
GO
