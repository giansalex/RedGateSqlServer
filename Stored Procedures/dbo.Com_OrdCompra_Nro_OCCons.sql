SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_Nro_OCCons]
@RucE nvarchar(11),
@NroOC char(50),
@msj varchar(100) output
as
if exists (select * from OrdCompra where RucE=@RucE and NroOC=@NroOC)
set @msj = 'Ya existe un registro con el mismo Nro de Orden de Compra'
print @Msj
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>

GO
