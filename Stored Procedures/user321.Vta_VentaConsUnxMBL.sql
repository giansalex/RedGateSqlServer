SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Vta_VentaConsUnxMBL]
@RucE nvarchar(11),
@MBL varchar(100),
@msj varchar(100) output
as

if not exists (select top 1 *from Venta where RucE = @RucE and CA01 = @MBL)
	set @msj='No se encontro Clientes'
else
begin
	select * from Venta where RucE = @RucE and CA01 = @MBL
	
	--select * from Compra where RucE = @RucE and CA01 = @MBL and CA16 = 'Agente'
end

-- Leyenda --
-- MP : 2011-04-29 : <Creacion del procedimiento almacenado>


GO
