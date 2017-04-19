SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paInvOP]
@RucE nvarchar(11),
@Cd_OP char(10),
@msj varchar(100)output

as

select OrdPed.Item,OrdPed.Cd_Prod, OrdPed.Nombre1,OrdPed.Descrip,OrdPed.Nombre,OrdPed.ID_UMP, OrdPed.DescripAlt, OrdPed.ESCant, convert(numeric(13,3),SUM(ISNULL(Cant_Ing,0))) as ICant, convert(numeric(13,3), OrdPed.ESCant - ABS(SUM(ISNULL(Cant_Ing,0)))) as Cant, OrdPed.Costo, OrdPed.Cd_Alm from (
select OP.RucE, OP.Cd_OP, OP.NroOP, OPD.Item, P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.ID_UMP, PU.DescripAlt, OPD.Cant as ESCant, OPD.PU as Costo, OPD.Cd_Alm  from  Producto2 as P  	
	inner join Prod_UM as PU on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
	inner join UnidadMedida as UM  on UM.Cd_UM = PU.Cd_UM
	inner join OrdPedidoDet as OPD on OPD.RucE = P.RucE and OPD.Cd_Prod = P.Cd_Prod and OPD.ID_UMP =PU.ID_UMP
	inner join OrdPedido as OP on OP.RucE = OPD.RucE  and OP.Cd_OP  = OPD.Cd_OP 
	where  OP.Cd_OP = @Cd_OP and OPD.RucE = @RucE)as OrdPed
	left join Inventario as I on I.RucE = OrdPed.RucE and I.Cd_Prod = OrdPed.Cd_Prod and I.ID_UMP = OrdPed.ID_UMP and I.NroDoc = OrdPed.NroOP and I.Cd_TDES = 'OP' and I.Cd_OP = OrdPed.Cd_OP and I.Item = OrdPed.Item
	where  OrdPed.Cd_OP = @Cd_OP and OrdPed.RucE = @RucE
	group by OrdPed.Item,OrdPed.Cd_Prod, OrdPed.Nombre1, OrdPed.Descrip,OrdPed.Nombre, OrdPed.ID_UMP, OrdPed.DescripAlt, OrdPed.ESCant, OrdPed.Costo, OrdPed.Cd_Alm
	having OrdPed.ESCant - ABS(SUM(ISNULL(Cant_Ing,0))) >0
print @msj
-- Leyenda --
-- PP : 2010-08-02 16:47:52.790	: <Creacion del procedimiento almacenado>
GO
