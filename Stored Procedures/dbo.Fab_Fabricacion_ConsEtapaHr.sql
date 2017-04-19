SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[Fab_Fabricacion_ConsEtapaHr]
@RucE nvarchar(11),
@Cd_Fab char(10),
@msj varchar(100) output
as
if not exists (select @Cd_Fab from FabFabricacion where RucE=@RucE and Cd_Fab=@Cd_Fab)
	set @msj = 'Flujo no existe'
else
	select sum(HorasTrab)as HorasTrab from FabEtapa where ruce=@RucE and Cd_Fab=@Cd_Fab
GO
