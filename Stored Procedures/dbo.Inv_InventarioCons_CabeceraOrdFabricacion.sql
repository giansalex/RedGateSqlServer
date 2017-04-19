SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_CabeceraOrdFabricacion]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from OrdFabricacion where RucE = @RucE and Cd_OF = @Cd_OF )
		set @msj = 'No existe la Orden de Fabricacion'
else
begin
	select ord.RucE, ord.Cd_OF, ord.CU as CosUnt,ord.NroOF,'1' as Item,ord.Cd_Prod,ord.Id_UMP,
	ord.Cant as Cant_Ing,P.Nombre1 as NomProd, UMP.DescripAlt as NomPUM, ord.Cd_Alm,
	ord.Cd_CC, ord.Cd_SC, ord.Cd_SS, UMP.Factor
	from OrdFabricacion ord
	left join Producto2 P ON ord.RucE = P.RucE and ord.Cd_Prod = P.Cd_Prod
	left join Prod_UM UMP ON ord.RucE = UMP.RucE and ord.Id_UMP = UMP.Id_UMP and UMP.Cd_Prod = P.Cd_Prod
	where ord.RucE = @RucE and ord.Cd_OF = @Cd_OF
	set @msj = ''
end

-- Leyenda
-- CAM <01/03/2011><Creacion del SP>
-- CAM <18/03/2011><Modif. Agregue Factor>
-- Pruebas
-- exec Inv_InventarioCons_CabeceraOrdFabricacion '11111111111','OF00000014',''
GO
