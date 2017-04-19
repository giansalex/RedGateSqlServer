SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[TablaElim]
@Cd_Tab char(4),
@msj varchar(100) output
as
begin
begin transaction
if exists (select * from Tabla where Cd_Tab=@Cd_Tab)
	begin
	delete from Tabla where Cd_Tab=@Cd_Tab
		if @@rowcount <= 0
		begin
			set @msj = 'Error al eliminar tabla'
			rollback transaction
			return
		end
	end
commit transaction
end
-- Leyenda --
-- MP : 2010-12-31 : <Creacion del procedimiento almacenado>

GO
