SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_SCxProvElim]
@RucE nvarchar(11),
@Cd_SCoEnv int,
@msj varchar(100) output
as

begin
begin transaction
	if exists (select * from SCxProv where RucE =@RucE and Cd_SCoEnv = @Cd_SCoEnv)
	begin

		delete from SCxProv where RucE =@RucE and Cd_SCoEnv = @Cd_SCoEnv
		if @@rowcount  <= 0
		begin 
			set @msj = 'Error al eliminar Solicitud de Compra por Proveedor'
			rollback transaction
			return
		end 

	end
commit transaction
end
-- Leyenda --
-- MP : 2010-12-15 : <Creacion del procedimiento almacenado>
-- exec Com_SCxProvElim '11111111111', 1, null

GO
