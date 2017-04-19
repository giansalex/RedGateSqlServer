SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdComboConsxProd]
@RucE nvarchar(11),
@Cd_ProdB char(7),
@msj varchar(100) output
as

	select P.Cd_Prod, P.Nombre1,P.NCorto, P.Descrip,PC.Cant,PUM.ID_UMP,U.Nombre,PUM.DescripAlt,PUM.Factor 
		from prodcombo as PC  
			inner join Producto2 as P on P.RucE = PC.RucE and P.Cd_Prod = PC.Cd_ProdC 
			inner join Prod_UM as PUM on PUM.RucE = PC.RucE and PUM.ID_UMP = PC.ID_UMP and PUM.Cd_Prod =PC.Cd_ProdC
			inner join UnidadMedida as U on PUM.Cd_UM = U.Cd_UM and PC.Estado =1 and PC.Cd_ProdB = @Cd_ProdB and PC.RucE = @RucE

print @msj
-- Leyenda --
-- PP : 2010-03-06 : <Creacion del procedimiento almacenado>
GO
