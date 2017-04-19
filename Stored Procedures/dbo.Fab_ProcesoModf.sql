SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ProcesoModf]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,
@Nombre varchar(25),
@Descrip varchar(150),
@TipPrc char(1),
@Actividades varchar(1000),
@Cd_Alm varchar(20),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(300),
@CA10 varchar(300),

@msj varchar(100) output
as
if not exists (select Cd_Flujo from FabProceso where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc)
	set @msj = 'Proceso no existe'
else
begin
	update FabProceso set RucE = @RucE, Cd_Flujo = @Cd_Flujo, ID_Prc = @ID_Prc, Nombre = @Nombre, 
	Descrip = @Descrip, TipPrc = @TipPrc, Actividades = @Actividades, Cd_Alm = @Cd_Alm, 
	CA01 = @CA01, CA02 = @CA02, CA03 = @CA03, CA04 = @CA04, CA05 = @CA05, 
	CA06 = @CA06, CA07 = @CA07, CA08 = @CA08, CA09 = @CA09, CA10 = @CA10
	where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc
	if @@rowcount <= 0
		set @msj = 'Proceso no pudo ser modificado'
end
GO
