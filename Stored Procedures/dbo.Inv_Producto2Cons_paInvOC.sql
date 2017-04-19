SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paInvOC]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100)output

as

select OrdCom.Item,OrdCom.Cd_Prod, OrdCom.Nombre1,OrdCom.Descrip,OrdCom.Nombre,OrdCom.ID_UMP, OrdCom.DescripAlt, OrdCom.ESCant, convert(numeric(13,3),SUM(ISNULL(Cant_Ing, 0))) as ICant, convert(numeric(13,3), OrdCom.ESCant - ABS(SUM(ISNULL(Cant_Ing,0)))) as Cant, OrdCom.Costo, OrdCom.Cd_Alm from (
select OC.RucE, OC.Cd_OC, OC.NroOC, OCD.Item, P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.ID_UMP, PU.DescripAlt, OCD.Cant as ESCant, OCD.PU as Costo, OCD.Cd_Alm  from  Producto2 as P  	
	inner join Prod_UM as PU on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
	inner join UnidadMedida as UM  on UM.Cd_UM = PU.Cd_UM
	inner join OrdCompraDet as OCD on OCD.RucE = P.RucE and OCD.Cd_Prod = P.Cd_Prod and OCD.ID_UMP =PU.ID_UMP
	inner join OrdCompra as OC on OC.RucE = OCD.RucE  and OC.Cd_OC  = OCD.Cd_OC 
	where  OC.Cd_OC = @Cd_OC and OCD.RucE = @RucE)as OrdCom
	left join Inventario as I on I.RucE = OrdCom.RucE and I.Cd_Prod = OrdCom.Cd_Prod and I.ID_UMP = OrdCom.ID_UMP and I.NroDoc = OrdCom.NroOC and I.Cd_TDES = 'OC' and I.Cd_OC = OrdCom.Cd_OC and I.Item = OrdCom.Item
	where  OrdCom.Cd_OC = @Cd_OC and OrdCom.RucE = @RucE
	group by OrdCom.Item,OrdCom.Cd_Prod, OrdCom.Nombre1, OrdCom.Descrip,OrdCom.Nombre, OrdCom.ID_UMP, OrdCom.DescripAlt, OrdCom.ESCant, OrdCom.Costo, OrdCom.Cd_Alm
	having OrdCom.ESCant - ABS(SUM(ISNULL(Cant_Ing,0)))>0

print @msj
-- Leyenda --
-- PP : 2010-08-02 16:47:52.790	: <Creacion del procedimiento almacenado>
GO
