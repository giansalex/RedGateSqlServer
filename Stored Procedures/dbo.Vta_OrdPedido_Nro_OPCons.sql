SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdPedido_Nro_OPCons]
@RucE nvarchar(11),
@NroOP char(50),
@msj varchar(100) output
as
if exists (select * from OrdPedido where RucE=@RucE and NroOP=@NroOP)
set @msj = 'Ya existe un registro con el mismo Nro de Orden de Pedido.'
print @Msj
-- Leyenda --
-- JJ : 2010-08-06 : <Creacion del procedimiento almacenado>
GO
