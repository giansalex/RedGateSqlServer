SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_PresupCptoElim]
@RucE nvarchar(11),@Cd_CPr nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from PresupCpto where RucE=@Ruce and Cd_Cpr=@Cd_CPr)
	Set @msj = 'Concepto no existe'
else
begin
	delete from PresupCpto where RucE=@RucE and Cd_CPr=@Cd_CPr

	if @@rowcount <= 0
		Set @msj = 'Concepto no pudo ser eliminado'
end
print @msj
GO
