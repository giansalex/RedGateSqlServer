SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paSust] -- Para Sustitutos
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as

	select Cd_Prod, Nombre1 from Producto2 where RucE = @RucE and Cd_Prod <>@Cd_Prod and Cd_Prod not in (select Cd_ProdS from ProdSustituto where Cd_ProdB = @Cd_Prod) and Estado =1
print @msj

-- Leyenda --
-- PP : 2010-03-11 12:49:25 : <Creacion del procedimiento almacenado>
GO
