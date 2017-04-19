SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_FlujoConsUn]

@RucE nvarchar(11),
@Cd_Flujo char(10),

@msj varchar(100) output
as
if not exists (select Cd_Flujo from FabFlujo where RucE=@RucE and Cd_Flujo=@Cd_Flujo)
	set @msj = 'Flujo no existe'
else
	select * from FabFlujo where RucE=@RucE and Cd_Flujo=@Cd_Flujo


GO
