SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_InsumoElim]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,
@ID_Ins int,

@msj varchar(100) output
as
if not exists (select Cd_Flujo from FabInsumo where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc and ID_Ins = @ID_Ins)
	set @msj = 'Insumo no existe'
else
begin
	delete FabInsumo where RucE=@RucE and RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc and ID_Ins = @ID_Ins
	
	if @@rowcount <= 0
		set @msj = 'Insumo no pudo ser eliminado'
end
GO
