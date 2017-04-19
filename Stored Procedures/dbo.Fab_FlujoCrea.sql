SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_FlujoCrea]

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

set @Cd_Flujo = dbo.Cd_Flujo(@RucE)

insert into FabFlujo(RucE, Cd_Flujo, Nombre, Descrip, Cd_Prod, ID_UMP, CA01, CA02, CA03, CA04, CA05, CA06, CA07, CA08, CA09, CA10)
	  values(@RucE, @Cd_Flujo, @Nombre, @Descrip, @Cd_Prod, @ID_UMP, @CA01, @CA02, @CA03, @CA04, @CA05, @CA06, @CA07, @CA08, @CA09, @CA10)

if @@rowcount <= 0
	set @msj = 'Flujo no pudo ser ingresado'
GO
