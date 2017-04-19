SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_ResultadoModf]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,
@ID_Rest int,
@Cd_Prod char(7),
@ID_UMP int,
@Cant numeric(15,7),

@msj varchar(100) output

as
if not exists (select Cd_Flujo from FabResultado where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc and ID_Rest = @ID_Rest)
	set @msj = 'Resultado no existe'
else
begin
	update FabResultado set Cd_Prod = @Cd_Prod, ID_UMP = @ID_UMP, Cant = @Cant
	where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc and ID_Rest = @ID_Rest
	if @@rowcount <= 0
		set @msj = 'Resultado no pudo ser modificado'
end
GO
