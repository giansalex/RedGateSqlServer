SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_PresupCptocrea]
@RucE nvarchar(11),
@Cd_CPr nvarchar(10),
@Nombre varchar(50),
@Estado bit,
@msj varchar(100) output
as
if exists (select * from PresupCpto where RucE=@Ruce and Cd_Cpr=@Cd_CPr)
	Set @msj = 'Ya existe concepto con codigo : '+@Cd_CPr
else if exists (select * from PresupCpto where RucE=@Ruce and Nombre=@Nombre)
	Set @msj = 'Ya existe concepto con el nombre : '+@Nombre
else
begin
	Insert into PresupCpto(RucE,Cd_CPr,Nombre,Estado)
	Values(@RucE,@Cd_CPr,@Nombre,@Estado)

	if @@rowcount <= 0
		Set @msj = 'Concepto no pudo ser registrado'
end
print @msj
GO
