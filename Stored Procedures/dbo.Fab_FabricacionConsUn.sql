SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_FabricacionConsUn]
@RucE nvarchar(11),
@Cd_Fab char(10),
@msj varchar(100) output
as
if not exists (select * from FabFabricacion where Cd_Fab=@Cd_Fab and RucE = @RucE)
	set @msj = 'La Fabricación no existe'
else	
	select * from FabFabricacion
	where Cd_Fab=@Cd_Fab and RucE = @RucE
	
print @msj

--LEYENDA--
--CE: 11/01/2013 <Creacion del procedimiento almacenado>
GO
