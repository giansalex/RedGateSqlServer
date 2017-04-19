SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ProcesoCrea]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int output,
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

set @ID_Prc = dbo.ID_Prc(@RucE, @Cd_Flujo)

insert into FabProceso(RucE, Cd_Flujo, ID_Prc, Nombre, Descrip, TipPrc, Actividades, Cd_Alm, CA01, CA02, CA03, CA04, CA05, CA06, CA07, CA08, CA09, CA10)
	  values(@RucE, @Cd_Flujo, @ID_Prc, @Nombre, @Descrip, @TipPrc, @Actividades, @Cd_Alm, @CA01, @CA02, @CA03, @CA04, @CA05, @CA06, @CA07, @CA08, @CA09, @CA10)

if @@rowcount <= 0
	set @msj = 'Proceso no pudo ser ingresado'
GO
