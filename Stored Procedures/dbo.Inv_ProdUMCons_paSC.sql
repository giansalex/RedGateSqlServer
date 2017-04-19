SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMCons_paSC]
--<Procedimiento almacenado que consulta los productos para Solicitud de Compra>--
@RucE nvarchar(11),
@msj varchar(100) output
as

/*declare @check bit
set @check=0*/

select /*@check as Sel,*/prd.Cd_Prod as CodProd,prd.Nombre1 as NomProd,um.Nombre as NomUM,ump.ID_UMP as UMP,ump.DescripAlt
from Prod_UM ump
Left join Producto2 prd on prd.RucE = ump.RucE and prd.Cd_Prod = ump.Cd_Prod
Left join UnidadMedida um on um.Cd_UM=ump.Cd_UM
Where ump.RucE = @RucE and prd.Estado=1 order by 2

-- Leyenda --
--J : 11/05/2010 <Creacion del procedimiento almacenado>
GO
