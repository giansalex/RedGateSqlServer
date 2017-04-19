SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdenPElim]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from OrdenP where RucE=@RucE and Cd_OP=@Cd_OP)
	set @msj = 'No existe Orden de Pedido'
else
begin
	delete from OrdenP where RucE=@RucE and Cd_OP=@Cd_OP

	if @@rowcount <= 0
		set @msj = 'Orden de pedido no pudo ser eliminado'
end
print @msj

GO
