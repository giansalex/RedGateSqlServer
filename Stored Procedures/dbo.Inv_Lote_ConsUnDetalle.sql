SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Lote_ConsUnDetalle]
@RucE nvarchar(11),
@Cd_Lote char(10),
@msj varchar(100) output
as
--select * from ProductoxLote where RucE = @RucE and Cd_Lote = @Cd_Lote

select l.Id_ProductoxLote,l.RucE,l.RegCtbInv,l.Cd_Lote,l.Cd_Prod,l.Cant,l.Ejer,
	p.CodCo1_ as CodCom ,p.Nombre1 as NombreProd
from ProductoxLote l 
left join Producto2 p on p.RucE = l.RucE and p.Cd_Prod = l.Cd_Prod
where l.RucE = @RucE and l.Cd_Lote = @Cd_Lote

-- LEYENDA
-- CAM 29/11/2012 creacion
-- exec Inv_Lote_ConsUnDetalle '11111111111','LT00000011',''
GO
