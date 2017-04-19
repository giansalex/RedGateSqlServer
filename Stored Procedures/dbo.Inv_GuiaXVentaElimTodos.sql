SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXVentaElimTodos]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
if not exists (select * from GuiaXVenta where RucE=@RucE and Cd_GR=@Cd_GR)
	set @msj = 'No existe una factura asociada a esa Guía de Remisión'
else
begin
	delete GuiaXVenta where RucE=@RucE and Cd_GR=@Cd_GR
	if @@rowcount <= 0
		set @msj = 'Factura asociada a la Guía de Remisión no pudo ser eliminada'
end
print @msj
-- Leyenda --
-- FL : 2010-12-21: <Creacion del procedimiento almacenado>
GO
