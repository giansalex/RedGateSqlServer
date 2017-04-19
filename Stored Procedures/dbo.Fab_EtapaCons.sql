SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_EtapaCons]
@RucE nvarchar(11),
@Cd_Fab char(10),
@msj varchar(100) output
as
begin
	
		select e.*, p.nombre as NombrePrc from FabEtapa as e inner join FabProceso as p 
		on e.RucE = p.RucE and e.Cd_Flujo = p.Cd_Flujo and e.ID_Prc = p.ID_Prc
		where e.RucE=@RucE and e.Cd_Fab=@Cd_Fab

end
GO
