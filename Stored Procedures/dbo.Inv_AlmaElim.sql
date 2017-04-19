SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AlmaElim]
@RucE nvarchar(11),
@Cd_alm varchar(20),
@msj varchar(100) output
as
if not exists (select * from Almacen where RucE= @RucE  and Cd_Alm= @Cd_alm)
	set @msj = 'Almacen no existe'
else
begin
	delete from Almacen where RucE= @RucE  and  Cd_Alm like @Cd_alm+'%'
	
	if @@rowcount <= 0
	set @msj = 'Almacen no pudo ser eliminado'	
end
print @msj
-- Leyenda --
-- PP : 2010-02-12 : <Creacion del procedimiento almacenado>
GO
