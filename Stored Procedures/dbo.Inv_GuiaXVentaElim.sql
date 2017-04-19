SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXVentaElim]
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from GuiaXVenta where RucE=@RucE and Cd_GR=@Cd_GR and Cd_Vta=@Cd_Vta)
	set @msj = 'Guia por Venta no existe'
else
begin
	delete GuiaXVenta where RucE=@RucE and Cd_GR=@Cd_GR and Cd_Vta=@Cd_Vta
	if @@rowcount <= 0
		set @msj = 'Linea no pudo ser eliminado'
	else
		delete GuiaRemisionDet where RucE=@RucE and Cd_GR=@Cd_GR and Cd_Vta=@Cd_Vta
end
print @msj

GO
