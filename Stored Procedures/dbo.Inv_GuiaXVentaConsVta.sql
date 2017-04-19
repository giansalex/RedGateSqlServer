SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXVentaConsVta] 
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
	select * from GuiaxVenta where RucE = @RucE and Cd_GR = @Cd_GR
print @msj

-- Leyenda --
-- CAM : 2010-24-23 : <Creacion del procedimiento almacenado>


GO
