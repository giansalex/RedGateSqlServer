SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_FormulaConsUn]
@RucE nvarchar(11),
@ID_Fmla int,
@msj varchar(100) output
as
if not exists (select * from Formula where RucE=@RucE and ID_Fmla=@ID_Fmla)
	set @msj = 'Formula no existe'
else	
	select f.*, isnull(p.CodCo1_, f.Cd_Prod) as Cd_Comer from Formula f inner join Producto2 p on p.RucE=f.RucE and p.Cd_Prod=f.Cd_Prod  where f.RucE=@RucE and f.ID_Fmla=@ID_Fmla
print @msj

-- CE : 2012-09-27  : <Se agrego para q muestre el codigo comercial>

--exec user321.Prd_FormulaConsUn '11111111111',89,null
GO
