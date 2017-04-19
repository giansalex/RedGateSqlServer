SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdCompra_Nro_OPGenera]
@RucE nvarchar(11),
@NroOP char(10) output,
@msj varchar(100) output
as
set @NroOP = dbo.Nro_OP(@RucE)
print dbo.Nro_OP(@RucE)
GO
