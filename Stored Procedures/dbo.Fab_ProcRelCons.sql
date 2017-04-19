SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ProcRelCons]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@msj varchar(100) output
as

begin
		select RucE, Cd_Flujo, ID_PrcPre, ID_PrcPos
		from FabProcRel 
		where RucE = @RucE and Cd_Flujo = @Cd_Flujo
end
print @msj
GO
