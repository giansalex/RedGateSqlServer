SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Inv_InventarioCons_SaldoxAlm]

@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Alm varchar(10),
@Id_UMP int,
@msj varchar(100) output
as

SELECT SUM(Cant) AS CantAlm
FROM         dbo.Inventario 
where RucE = @RucE and Cd_Prod = @Cd_Prod and Cd_Alm = @Cd_Alm and Id_UMP = @Id_UMP
GROUP BY ID_UMP

-- Leyenda
-- CAM <Creacion del SP><Fecha desconocida>
-- Inv_InventarioCons_SaldoxAlm '11111111111','PD00001','A00',12,''
GO
