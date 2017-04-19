SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gen_OrdenCompra_Inventario]
@RucE nvarchar(11),
@Cd_OC nvarchar(10),
@msj varchar(100) output
--with encryption
as
if exists(select * from Inventario where RucE=@RucE and Cd_OC = @Cd_OC)
begin
	set @msj = 'La Orden de Compra esta en Inventario'
	print @msj
end

-- LEYENDA
-- CAM 06/11/2012 Creacion
-- exec Gen_OrdenCompra_Inventario '11111111111','OC00000386',''
GO
