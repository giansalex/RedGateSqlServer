SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ProcesoElim]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,

@msj varchar(100) output
as
if not exists (select Cd_Flujo from FabProceso where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc)
	set @msj = 'Proceso no existe'
else if exists (select ID_Prc from fabetapa where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc)
	set @msj = 'El proceso esta en uso, no se puede eliminar'
else
begin

	begin transaction
	
	delete FabInsumo where RucE=@RucE and RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc
	delete FabResultado where RucE=@RucE and RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc
	delete FabProcRel where RucE=@RucE and RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_PrcPre = @ID_Prc
	delete FabProcRel where RucE=@RucE and RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_PrcPos = @ID_Prc
	delete FabProceso where RucE=@RucE and RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc
	
	if @@rowcount <= 0
		set @msj = 'Proceso no pudo ser eliminado'
	commit transaction
end

-- exec Fab_ProcesoElim '11111111111','FL00000011',4,null

select * from fabetapa
GO
