SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_PresupCptoMdf]
@RucE nvarchar(11),
@Cd_CPr nvarchar(10),
@Nombre varchar(50),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from PresupCpto where RucE=@Ruce and Cd_Cpr=@Cd_CPr)
	Set @msj = 'Concepto no existe'
else
begin
	update PresupCpto set Nombre=@Nombre, Estado=@Estado
	where RucE=@RucE and Cd_CPr=@Cd_CPr

	if @@rowcount <= 0
		Set @msj = 'Concepto no pudo ser modificado'
end
print @msj
GO
