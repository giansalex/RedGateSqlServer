SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosElim]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@msj varchar(100) output
as
if not exists (select * from CCostos where RucE=@RucE and Cd_CC=@Cd_CC)
	set @msj = 'Centro de Costos no existe'
else
begin
	delete from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC
	delete from CCSub where RucE=@RucE and Cd_CC=@Cd_CC
	delete from CCostos where RucE=@RucE and Cd_CC=@Cd_CC

	if @@rowcount <= 0
	begin
	   set @msj = 'Centro de Costos no pudo ser eliminado'
	   return
	end

	
end
print @msj
GO
