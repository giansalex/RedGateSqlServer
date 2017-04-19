SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paGRCom] 
@RucE nvarchar(11),
@Cd_Com char(10),
@msj varchar(100) output
as
	select VD.Item as Nro,P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.DescripAlt,  VD.Cant as sVCant, sum(isnull(GRD.Cant,0)) as GRCant,VD.Cant - sum(isnull(GRD.Cant,0)) as Cant from Producto2 as P  	
		inner join Prod_UM as PU on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
		inner join UnidadMedida as UM  on UM.Cd_UM = PU.Cd_UM
		inner join CompraDet as VD on PU.RucE = VD.RucE and PU.Cd_Prod = VD.Cd_Prod and PU.ID_UMP = VD.ID_UMP 
		inner join Compra as V on V.Cd_Com = VD.Cd_Com  and V.RucE =VD.RucE 
		left join GuiaRemisionDet as GRD on GRD.RucE= VD.RucE and GRD.Cd_Com=VD.Cd_Com and GRD.Cd_Prod=VD.Cd_Prod and GRD.ID_UMP=VD.ID_UMP  and VD.Item = ItemPd
		Where  v.Cd_Com = @Cd_Com and  VD.RucE = @RucE 
		Group by VD.Item,P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.DescripAlt, VD.Cant
		having  VD.Cant - sum(isnull(GRD.Cant,0)) >0
	
print @msj

-- Leyenda --
-- FL : 2010-10-20	: <Creacion del procedimiento almacenado>
GO
