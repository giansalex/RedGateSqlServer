SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_OrdPedidoValida_ND]

@RucE nvarchar(11),
@NroOP varchar(50),
@msj varchar(100) output,
@Cd_OP char(10) output

as
select @Cd_OP = Cd_OP from OrdPedido where RucE = @RucE and NroOP = @NroOP
if (isnull(len(@Cd_OP),0) <= 0)
	set @msj = 'Nro Documento no pertenece a ninguna Orden de Compra'
print @msj

-- Leyenda --
-- PP : 2010-09-03 16:53:52.073	: <Creacion del procedimiento almacenado>

GO
