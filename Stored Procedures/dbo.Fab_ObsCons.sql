SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_ObsCons]

@RucE nvarchar(11),
@Cd_Fab char(10),
@ID_Etapa int,
@msj varchar(100) output
as

begin
	if(@ID_Etapa != 0)
	
		select * from FabObs where RucE = @RucE and Cd_Fab = @Cd_Fab and ID_Eta = @ID_Etapa
		
	else 
		select * from FabObs where RucE = @RucE and Cd_Fab = @Cd_Fab --and ID_Eta = @ID_Etapa
end
print @msj
GO
