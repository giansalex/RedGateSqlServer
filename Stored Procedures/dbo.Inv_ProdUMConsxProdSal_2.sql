SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_ProdUMConsxProdSal_2]
@RucE nvarchar(11),
@Cd_Prod char(7),
@FecMov datetime,
@msj varchar(100) output
as
declare @sel bit
set @sel = 0

select @sel as Sel, ID_UMP,UM.Cd_UM,descripAlt,Factor,Nombre,NCorto,Estado, isnull(dbo.CostSal3(@RucE,PUM.Cd_Prod,PUM.ID_UMP,@FecMov, '01'), .0000000) as Cost, isnull(dbo.CostSal3(@RucE,PUM.Cd_Prod,PUM.ID_UMP,@FecMov, '02'), .0000000) as Cost_ME,
isnull((select Sum(Cant_Ing) from Inventario as I where I.RucE = @RucE and I.Cd_Prod = PUM.Cd_Prod  and I.Id_UMP=PUM.Id_UMP), .000) as Stock,
PUM.PesoKg as PesoKg
from Prod_UM as PUM inner join UnidadMedida as UM on PUM.Cd_UM = UM.Cd_UM and UM.Estado= 1 and Cd_Prod=@Cd_Prod and RucE=@RucE
print @msj
-- Leyenda --
-- PP : 2010-07-20 10:44:55.667	 : <Creacion del procedimiento almacenado>
-- cam 30/06/2012 cambio de version de las funciones de costo promedio para los 7 decimales.
--exec Inv_ProdUMConsxProdSal '11111111111','PD00001','19/11/2011',''
GO
