SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXVentaCrea]
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
if not exists(select * from GuiaXVenta where RucE = @RucE and Cd_GR = @Cd_GR and Cd_Vta = @Cd_Vta)
begin
	insert into GuiaXVenta(RucE,Cd_GR,Cd_Vta)
	   values(@RucE,@Cd_GR,@Cd_Vta)
	if @@rowcount <= 0
	   set @msj = 'Factura Venta no pudo ser registrada'	
end			
print @msj
-- Leyenda --
-- PP : 2010-04-10 12:26:06.897	: <Creacion del procedimiento almacenado>

GO
