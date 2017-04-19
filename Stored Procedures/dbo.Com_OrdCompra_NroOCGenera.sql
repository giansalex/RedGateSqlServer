SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_NroOCGenera]
@RucE nvarchar(11),
@Nro_OC nvarchar(50) output,
@msj varchar(100) output

as

set @Nro_OC = user123.Nro_OC(@RucE)--Funcion que genera el numero de la orden de compra

select @Nro_OC as NroOC
-- Leyenda --
-- CAM : 02/09/2011 <Creacion del procedimiento>
--Ejemplo--
/*
Declare @NroOC nvarchar(50)
exec Com_OrdCompra_NroOCGenera '11111111111',@NroOC out,null
print @NroOC
*/

--select * from OrdCOmpra
GO
