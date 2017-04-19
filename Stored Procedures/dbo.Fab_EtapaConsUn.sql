SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Fab_EtapaConsUn]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Eta int,
@Cd_Fab char(10),
@msj varchar(100) output
as
if not exists (select @ID_Eta from fabetapa where RucE=@RucE and Cd_Fab=@Cd_Fab  and Cd_Flujo=@Cd_Flujo)
	set @msj = 'Flujo no existe'
else
	select * from fabetapa where RucE=@RucE and Cd_Flujo=@Cd_Flujo and Cd_Fab=@Cd_Fab and ID_Eta = @ID_Eta 


GO
