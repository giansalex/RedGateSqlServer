SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CampoTablaElim]
@Id_CTb int,
@msj varchar(100) output
as
begin
begin transaction
if exists (select * from CampoTabla where Id_CTb=@Id_CTb)
	begin
	delete from CampoTabla where Id_CTb=@Id_CTb
		if @@rowcount <= 0
		begin
			set @msj = 'Error al eliminar campo'
			rollback transaction
			return
		end
	end
commit transaction
end
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado

GO
