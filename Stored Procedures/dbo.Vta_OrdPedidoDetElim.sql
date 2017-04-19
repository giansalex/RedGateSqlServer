SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_OrdPedidoDetElim]
@RucE nvarchar (11),
@Cd_OP char (10),
@msj varchar(100) output
as
begin
begin transaction
	delete from OrdPedidoDet where RucE =@RucE and Cd_OP = @Cd_OP
	if @@rowcount  <= 0
	begin 
	set @msj = 'Error al eliminar Orden de Pedido Detalle'
	rollback transaction
	return
	end 
commit transaction
end
-- Leyenda --
-- JJ : 2010-08-09 : <Creacion del procedimiento almacenado>
GO
