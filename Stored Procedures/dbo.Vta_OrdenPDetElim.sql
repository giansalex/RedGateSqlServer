SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdenPDetElim]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@msj nvarchar(100) output
as

if not exists (select * from OrdenPDet where RucE=@RucE and Cd_OP=@Cd_OP)
	set @msj = '(*)Orden de Pedido no existe'
else
begin
	delete from OrdenPDet where RucE=@RucE and Cd_OP=@Cd_OP
	
	if @@rowcount <= 0
		set @msj = '(*)Orden de Pedido no puso ser eliminado' 		
end
Print @msj
GO
