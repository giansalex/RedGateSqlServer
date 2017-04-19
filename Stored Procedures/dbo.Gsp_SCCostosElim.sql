SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosElim]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@msj varchar(100) output
as
if not exists (select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	set @msj = 'Sub Centro de Costos no existe'
else
begin
	delete from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC
	delete from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC

	if @@rowcount <= 0
	   set @msj = 'Sub Centro de Costos no pudo ser eliminado'
end
print @msj
GO
