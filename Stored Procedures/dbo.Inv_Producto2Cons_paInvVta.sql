SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paInvVta] 
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@FecMov datetime,
@msj varchar(100)output

as

select Vent.Item, Vent.Cd_Prod, Vent.Nombre1,Vent.Descrip,Vent.Nombre,Vent.ID_UMP, Vent.DescripAlt, Vent.ESCant, convert(numeric(13,3),ISNULL(SUM(Cant_Ing), 0)) as ICant, convert(numeric(13,3), Vent.ESCant - ABS(ISNULL( SUM(Cant_Ing),0))) as Cant, dbo.CostSal(@RucE,Vent.Cd_Prod,Vent.ID_UMP,@FecMov) as Costo from (
select V.RucE, V.Cd_Vta, V.Cd_TD, S.NroSerie, V.NroDoc, P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.ID_UMP, PU.DescripAlt, VD.Cant as ESCant, VD.Nro_RegVdt as Item from  Producto2 as P  	
	inner join Prod_UM as PU on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
	inner join UnidadMedida as UM  on UM.Cd_UM = PU.Cd_UM
	inner join VentaDet as VD on VD.RucE = P.RucE and VD.Cd_Prod = P.Cd_Prod and VD.ID_UMP =PU.ID_UMP
	inner join Venta as V on V.RucE = VD.RucE  and V.Cd_Vta  = VD.Cd_Vta 
	inner join Serie as S on S.RucE  = VD.RucE and V.Cd_Sr = S.Cd_Sr and S.Cd_TD = V.Cd_TD	
	where  V.Cd_Vta = @Cd_Vta and VD.RucE = @RucE) as Vent
	LEFT join Inventario as I on I.RucE = Vent.RucE and I.Cd_Prod = Vent.Cd_Prod and I.ID_UMP = Vent.ID_UMP and I.Cd_TD = Vent.Cd_TD and I.NroSre = Vent.NroSerie and I.NroDoc = Vent.NroDoc and I.Cd_TDES = 'VT' and I.Cd_Vta = Vent.Cd_Vta and I.Item = Vent.Item
	where  Vent.Cd_Vta = @Cd_Vta and Vent.RucE = @RucE
	group by Vent.Item, Vent.Cd_Prod, Vent.Nombre1,Vent.Descrip,Vent.Nombre,Vent.ID_UMP, Vent.DescripAlt, Vent.ESCant, dbo.CostSal(@RucE,Vent.Cd_Prod,Vent.ID_UMP,@FecMov)
print @msj
-- Leyenda --
-- PP : 2010-07-26 15:04:17.783	: <Creacion del procedimiento almacenado>
GO
