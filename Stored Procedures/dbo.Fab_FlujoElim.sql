SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_FlujoElim]

@RucE nvarchar(11),
@Cd_Flujo char(10),

@msj varchar(100) output
as
if not exists (select Cd_Flujo from FabFlujo where RucE=@RucE and Cd_Flujo=@Cd_Flujo)
	set @msj = 'Flujo no existe'
else
begin

	begin transaction
	
	delete FabInsumo where RucE=@RucE and Cd_Flujo=@Cd_Flujo
	delete FabResultado where RucE=@RucE and Cd_Flujo=@Cd_Flujo
	delete FabProcRel where RucE=@RucE and Cd_Flujo=@Cd_Flujo
	delete FabProceso where RucE=@RucE and Cd_Flujo=@Cd_Flujo
	delete FabFlujo where RucE=@RucE and Cd_Flujo=@Cd_Flujo
	if @@rowcount <= 0
		set @msj = 'Flujo no pudo ser eliminado'
	commit transaction
	
	
end
print @msj
GO
