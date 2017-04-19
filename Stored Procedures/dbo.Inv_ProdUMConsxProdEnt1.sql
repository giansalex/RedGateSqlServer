SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMConsxProdEnt1]
@RucE nvarchar(11),
@Cd_Prod char(7),
@FecMov datetime,
@msj varchar(100) output
as
select CAST(0 as bit) as Sel, ID_UMP,UM.Cd_UM,descripAlt,Factor,Nombre,NCorto,Estado, 
 [dbo].[CostEnt2](@RucE ,@Cd_Prod , ID_UMP , @FecMov , '01' ) as Cost, [dbo].[CostEnt2](@RucE ,@Cd_Prod , ID_UMP , @FecMov , '02' ) as Cost_ME,
isnull((select Sum(Cant_Ing) from Inventario as I where I.RucE = @RucE and I.Cd_Prod = PUM.Cd_Prod  and I.Id_UMP=PUM.Id_UMP), .000) as Stock,
PUM.PesoKg as PesoKg
from Prod_UM as PUM inner join UnidadMedida as UM on PUM.Cd_UM = UM.Cd_UM and UM.Estado= 1 and Cd_Prod=@Cd_Prod and RucE=@RucE
print @msj
-- Leyenda --
-- PP : 2010-07-20 10:37:18.180	 : <Creacion del procedimiento almacenado>
-- CAM: 2011-11-22 12:00:00.000 coloque el CAST para la grilla de devexpress
GO
