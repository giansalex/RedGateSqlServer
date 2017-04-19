SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdPedidoElim]
@RucE nvarchar(11),
@Cd_OP char(10),

@msj varchar(100) output
as
if not exists (select * from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP)
	set @msj = 'Orden de Pedido no existe'
else
begin
if exists (select *from inventario where Cd_OP=@Cd_OP and RucE=@RucE)
	set @msj='Orden de Pedido Tiene Inventario Relacionado'
else
begin
begin transaction
	delete from AutOP where RucE = @RucE and Cd_OP = @Cd_OP
	delete from OrdPedidoDet where RucE=@RucE and Cd_OP=@Cd_OP 
	delete from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP
	if @@rowcount <= 0
	begin	   set @msj = 'Orden de Pedido no pudo ser eliminado'
	   rollback transaction
	end
commit transaction
end
end
--print @msj

-- Leyenda --
-- JJ :  2010-08-06 : <Creacion del procedimiento almacenado>
-- JJ :  2010-08-06 : <Modificacion del Procedimiento Almacenado>
GO
