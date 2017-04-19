SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_InventarioCons_Prod]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as

	set @msj = 'Debe actualizar el sistema.'
/*
select P.RucE,UMP.ID_UMP, c.Cd_ProdC as Cd_Prod,(select r.Nombre1 from Producto2 r where r.RucE = @RucE and r.Cd_Prod = c.Cd_ProdC)
as Nombre1, c.Cant
from Producto2 P
left join ProdCombo c on c.RucE = p.RucE and c.Cd_ProdB = p.Cd_Prod
left join Prod_UM as UMP on UMP.RucE = P.RucE and UMP.Cd_Prod = c.Cd_ProdC and UMP.ID_UMP = c.ID_UMP
where P.RucE = @RucE and c.Cd_ProdB = @Cd_Prod
*/
-- Leyenda
-- CAM 23/02/2011 <Creacion del SP>

-- Pruebas
-- exec Inv_InventarioCons_Prod '11111111111','PD00078',''



GO
