SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraDetElim]
@RucE nvarchar (11),
@Cd_OC char (10),
@msj varchar(100) output
as
begin
begin transaction
	delete from OrdCompraDet where RucE =@RucE and Cd_OC = @Cd_OC
	if @@rowcount  <= 0
	begin 
	set @msj = 'Error al eliminar Orden de Compra Detalle'
	rollback transaction
	return
	end 
commit transaction
end
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>

GO
