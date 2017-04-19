SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgCampoElim]
@RucE nvarchar(11),
@Id_CTb int,
@msj varchar(100) output
as
begin
begin transaction
if exists (select * from CfgCampos where Id_CTb=@Id_CTb and RucE=@RucE)
	begin
	delete from CfgCampos where Id_CTb=@Id_CTb and RucE=@RucE
		if @@rowcount <= 0
		begin
			set @msj = 'Error al eliminar configuración del campo'
			rollback transaction
			return
		end
	end
commit transaction
end
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado


GO
