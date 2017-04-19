SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_FlujoModf]

@RucE nvarchar(11),
@Cd_Flujo char(10) output,
@Nombre varchar(25),
@Descrip varchar(150),
@Cd_Prod char(7),
@ID_UMP int,
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
if not exists (select Cd_Flujo from FabFlujo where RucE=@RucE and Cd_Flujo=@Cd_Flujo)
	set @msj = 'Flujo no existe'
else
begin
	update FabFlujo set Nombre = @Nombre, Descrip = @Descrip, Cd_Prod = @Cd_Prod, ID_UMP = @ID_UMP, 
		CA01 = @CA01, CA02 = @CA02, CA03 = @CA03, CA04 = @CA04, CA05 = @CA05, 
		CA06 = @CA06, CA07 = @CA07, CA08 = @CA08, CA09 = @CA09, CA10 = @CA10
	where RucE = @RucE and Cd_Flujo = @Cd_Flujo
	if @@rowcount <= 0
		set @msj = 'Flujo no pudo ser modificado'
end
GO
