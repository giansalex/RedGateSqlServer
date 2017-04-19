SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXCompraConsCom]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
	select * from GuiaxCompra where RucE = @RucE and Cd_GR = @Cd_GR
print @msj

-- Leyenda --
-- CAM : 2011-01-06 : <Creacion del procedimiento almacenado>




GO
