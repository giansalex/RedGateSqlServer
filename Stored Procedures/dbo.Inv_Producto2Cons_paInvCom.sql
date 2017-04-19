SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paInvCom]
@RucE nvarchar(11),
@Cd_Com nvarchar(10),
@FecMov datetime,
@msj varchar(100)output

as
select Comp.Item, Comp.Cd_Prod, Comp.Nombre1,Comp.Descrip,Comp.Nombre,Comp.ID_UMP, Comp.DescripAlt, Comp.ESCant, convert(numeric(13,3),SUM(ISNULL(Cant_Ing, 0))) as ICant, convert(numeric(13,3), Comp.ESCant - ABS(SUM(ISNULL(Cant_Ing,0)))) as Cant, dbo.CostSal(@RucE,Comp.Cd_Prod,Comp.ID_UMP,@FecMov) as Costo from (
select C.RucE, C.Cd_Com, C.Cd_TD, C.NroSre, C.NroDoc, P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.ID_UMP, PU.DescripAlt, CD.Cant as ESCant, CD.Item as Item from  Producto2 as P  	
	inner join Prod_UM as PU on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
	inner join UnidadMedida as UM  on UM.Cd_UM = PU.Cd_UM
	inner join CompraDet as CD on CD.RucE = P.RucE and CD.Cd_Prod = P.Cd_Prod and CD.ID_UMP =PU.ID_UMP
	inner join Compra as C on C.RucE = CD.RucE  and C.Cd_Com  = CD.Cd_Com
	where  C.Cd_Com = @Cd_Com and CD.RucE = @RucE) as Comp
	LEFT join Inventario as I on I.RucE = Comp.RucE and I.Cd_Prod = Comp.Cd_Prod and I.ID_UMP = Comp.ID_UMP and I.Cd_TD = Comp.Cd_TD and I.NroSre = Comp.NroSre and I.NroDoc = Comp.NroDoc and I.Cd_TDES = 'CP' and I.Cd_Com = Comp.Cd_Com and I.Item = Comp.Item
	where  Comp.Cd_Com = @Cd_Com and Comp.RucE = @RucE
	group by Comp.Item, Comp.Cd_Prod, Comp.Nombre1,Comp.Descrip,Comp.Nombre,Comp.ID_UMP, Comp.DescripAlt, Comp.ESCant, dbo.CostSal(@RucE,Comp.Cd_Prod,Comp.ID_UMP,@FecMov)
	having Comp.ESCant - ABS(SUM(ISNULL(Cant_Ing,0)))>0
print @msj
-- Leyenda --
-- PP : 2010-09-03 12:13:14.093	: <Creacion del procedimiento almacenado>
GO
