SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Se agrega procedimiento almacenado para consulta de direcciones para el cliente en facturacion
create proc [dbo].[Vta_DirFacturacionCliente_Cons]
(
	@RucE nvarchar(11),
	@Cd_Clt char(10)
)
AS
Select * from (
Select NULLIF(Direc,'') As DireccionFacturacion, 0 As Seleccionado From Cliente2 Where RucE = @RucE AND Cd_Clt = @Cd_Clt
UNION
Select NULLIF(Direc,'') As DireccionFacturacion, ISNULL(PorDefecto,0) As Seleccionado from DirecEnt Where RucE = @RucE AND Cd_Clt = @Cd_Clt
) as X Where X.DireccionFacturacion IS NOT NULL Order By Seleccionado desc
print('Se creó sp para consulta de direcciones de cliente')
GO
