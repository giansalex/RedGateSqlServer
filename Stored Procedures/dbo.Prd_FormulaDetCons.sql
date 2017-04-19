SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_FormulaDetCons]
@RucE nvarchar(11),
@ID_Fmla int,
@TipCons int,
@msj varchar(100) output
as
if(@TipCons=0)
	select f.*,p.Nombre1,p.CodCo1_ from FormulaDet f
	inner join Producto2 p on p.RucE=f.RucE and p.Cd_Prod=f.Cd_Prod
	where f.RucE = @RucE and f.ID_Fmla = @ID_Fmla
print @msj
-- Leyenda --
-- FL : 2010-02-05	: <Creacion del procedimiento almacenado>
-- CE : 2012-09-27  : <Se agrego para q muestre el codigo comercial>
--exec Prd_FormulaDetCons '11111111111',89,0,null


GO
