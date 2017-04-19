SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ProcesoCons]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@msj varchar(100) output
as

begin
		select RucE, Cd_Flujo, ID_Prc, Nombre, Descrip, TipPrc, Actividades, Cd_Alm, CA01, CA02, CA03, CA04, CA05, CA06, CA07, CA08, CA09, CA10
		from FabProceso where RucE = @RucE and Cd_Flujo = @Cd_Flujo
end
print @msj
GO
