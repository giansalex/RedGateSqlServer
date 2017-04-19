SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CajaModf]
@RucE nvarchar(11),
@Cd_Caja nvarchar(20),
@Nombre varchar(50),
@Numero nvarchar(100),
@Cd_Area nvarchar(12),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Caja where RucE=@RucE and Cd_Caja=@Cd_Caja)
	set @msj = 'Caja no existe'
else
begin
	update Caja set Nombre=@Nombre, Numero=@Numero, Cd_Area=@Cd_Area, Estado=@Estado
		where RucE=@RucE and Cd_Caja=@Cd_Caja
	if @@rowcount <= 0
		set @msj = 'Caja no pudo ser modificado'
end
print @msj

--MP : 03/02/2012 : <Creacion del Procedimiento Almacenado>
GO
