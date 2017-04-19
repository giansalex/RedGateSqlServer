SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Fab_ObsConsUn]

@RucE nvarchar(11),
@ID_Obs int,
@ID_Eta int,
@Cd_Fab char(10),
@msj varchar(100) output
as
if not exists (select ID_Obs from FabObs where RucE=@RucE and Cd_Fab=@Cd_Fab and ID_Eta=@ID_Eta and ID_Obs=@ID_Obs)
	set @msj = 'Observación no existe'
else
	select * from FabObs where RucE=@RucE and Cd_Fab=@Cd_Fab and ID_Eta=@ID_Eta and ID_Obs = @ID_Obs 


GO
