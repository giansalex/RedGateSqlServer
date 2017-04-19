SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdSustitutoConsxProd]
@RucE nvarchar(11),
@Cd_ProdB char(7),
@msj varchar(100) output

as
	select Prod.Cd_Prod, Prod.Nombre1,Prod.NCorto, Prod.Descrip, Prod.Estado, Sum(I.Cant) as Cant from (
	select P.RucE, Cd_Prod, Nombre1,NCorto, P.Descrip, PS.Estado from prodsustituto as PS  
	inner join Producto2 as P on P.RucE = PS.RucE and P.Cd_Prod = PS.Cd_ProdS  and PS.Estado =1 and PS.Cd_ProdB = @Cd_ProdB and PS.RucE = @RucE) as Prod 
	left join Inventario as I on I.RucE = Prod.RucE  and I.Cd_Prod = Prod.Cd_Prod
	group by Prod.Cd_Prod, Prod.Nombre1,Prod.NCorto, Prod.Descrip, Prod.Estado 

print @msj

-- Leyenda --
-- PP : 2010-03-10 : <Creacion del procedimiento almacenado>
GO
