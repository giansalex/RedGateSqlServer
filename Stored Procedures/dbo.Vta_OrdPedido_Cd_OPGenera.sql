SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdPedido_Cd_OPGenera]
@RucE nvarchar(11),
@Cd_OP char(10) output,
@msj varchar(100) output

as

select @Cd_OP = dbo.Cd_OP(@RucE)
print @Cd_OP
-- Leyenda --
-- JU : 2010-08-06 : <Creacion del procedimiento almacenado>
GO
