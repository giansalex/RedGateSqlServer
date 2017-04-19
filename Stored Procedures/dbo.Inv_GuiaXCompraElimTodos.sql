SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXCompraElimTodos]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
if not exists (select * from GuiaXCompra where RucE=@RucE and Cd_GR=@Cd_GR)
	set @msj = 'No existe una factura asociada a esa Guia de Remision'
else
begin
	delete GuiaXCompra where RucE=@RucE and Cd_GR=@Cd_GR
	if @@rowcount <= 0
		set @msj = 'Compra asociada a la Guia de Remision no pudo ser eliminada'
end
print @msj
-- Leyenda --
-- FL : 2011-01-06: <Creacion del procedimiento almacenado>


GO
