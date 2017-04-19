SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ProcRelCrea]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_PrcPre int,
@ID_PrcPos int,

@msj varchar(100) output
as

begin
	insert into FabProcRel(RucE, Cd_Flujo, ID_PrcPre, ID_PrcPos)
	values(@RucE, @Cd_Flujo, @ID_PrcPre, @ID_PrcPos)
end
print @msj
GO
