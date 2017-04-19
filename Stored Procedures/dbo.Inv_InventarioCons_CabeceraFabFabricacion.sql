SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_CabeceraFabFabricacion]
@RucE nvarchar(11),
@Cd_FA char(10),
@msj varchar(100) output
as
if not exists (select * from FabFabricacion where RucE = @RucE and Cd_Fab = @Cd_FA )
		set @msj = 'No existe la Fabricacion'
else
begin
	select ord.RucE, ord.Cd_Fab,'1' as Item,ord.Cd_Prod,ord.Id_UMP,
	ord.Cant as Cant_Ing,P.CodCo1_ as CodCom,P.Nombre1 as NomProd, UMP.DescripAlt as NomPUM, null as Cd_Alm,
	ord.Cd_CC, ord.Cd_SC, ord.Cd_SS, UMP.Factor, [dbo].[CostEnt3](@RucE ,ord.Cd_Prod , UMP.ID_UMP , ord.FecEmi , ord.Cd_Mda ) as Costo
	from FabFabricacion ord
	left join Producto2 P ON ord.RucE = P.RucE and ord.Cd_Prod = P.Cd_Prod
	left join Prod_UM UMP ON ord.RucE = UMP.RucE and ord.Id_UMP = UMP.Id_UMP and UMP.Cd_Prod = P.Cd_Prod
	where ord.RucE = @RucE and ord.Cd_Fab = @Cd_FA
	set @msj = ''
end

-- Leyenda
-- CAM <01/03/2011><Creacion del SP>
-- CAM <18/03/2011><Modif. Agregue Factor>
-- Pruebas
-- exec Inv_InventarioCons_CabeceraFabFabricacion '11111111111','FAB0000006',''
GO
