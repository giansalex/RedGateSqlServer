SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_CompraDetElim]
@RucE nvarchar (11),
@Cd_Com char (10),
@msj varchar(100) output
as
begin
begin transaction
	if exists (select * from CompraDet where RucE =@RucE and Cd_Com = @Cd_Com)
	begin

		delete from CompraDet where RucE =@RucE and Cd_Com = @Cd_Com
		if @@rowcount  <= 0
		begin 
			set @msj = 'Error al eliminar Compra Detalle'
			rollback transaction
			return
		end 

	end
commit transaction
end
-- Leyenda --
-- JJ : 2010-08-23 : <Creacion del procedimiento almacenado>
-- MP : 2010-11-25 : <Modificacion del procedimiento almacenado> 



GO
