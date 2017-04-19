SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paGRVta]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
	select VD.Nro_RegVdt as Nro,P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.DescripAlt,  VD.Cant as sVCant, sum(isnull(GRD.Cant,0)) as GRCant,VD.Cant - sum(isnull(GRD.Cant,0)) as Cant from Producto2 as P  	
		inner join Prod_UM as PU on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
		inner join UnidadMedida as UM  on UM.Cd_UM = PU.Cd_UM
		inner join VentaDet as VD on PU.RucE = VD.RucE and PU.Cd_Prod = VD.Cd_Prod and PU.ID_UMP = VD.ID_UMP 
		inner join Venta as V on V.Cd_Vta = VD.Cd_Vta  and V.RucE =VD.RucE 
		left join GuiaRemisionDet as GRD on GRD.RucE= VD.RucE and GRD.Cd_Vta=VD.Cd_Vta and GRD.Cd_Prod=VD.Cd_Prod and GRD.ID_UMP=VD.ID_UMP  and VD.Nro_RegVdt = ItemPd
		Where  v.Cd_Vta = @Cd_Vta and  VD.RucE = @RucE 
		Group by VD.Nro_RegVdt,P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.DescripAlt, VD.Cant
		having  VD.Cant - sum(isnull(GRD.Cant,0)) >0
	
print @msj

-- Leyenda --
-- PP : 2010-06-30 12:30:31.217	: <Creacion del procedimiento almacenado>
GO
