SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_InsumoModf]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,
@ID_Ins int,
@Cd_Prod char(7),
@ID_UMP int,
@Cant numeric(15,7),
@Merma numeric(15,7),

@msj varchar(100) output

as
if not exists (select Cd_Flujo from FabInsumo where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc and ID_Ins = @ID_Ins)
	set @msj = 'Insumo no existe'
else
begin
	update FabInsumo set Cd_Prod = @Cd_Prod, ID_UMP = @ID_UMP, Cant = @Cant, Merma = @Merma
	where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc and ID_Ins = @ID_Ins
	if @@rowcount <= 0
		set @msj = 'Insumo no pudo ser modificado'
end
GO
