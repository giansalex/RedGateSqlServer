SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Prd_FormulaXProd_Cons1]
@RucE nvarchar(11),
@Cd_Prod char(7),
@ID_UMP int,
@msj varchar(100) output
as
begin
select f.ID_fmla,f.Cd_Prod,p.CodCo1_, f.Fecha, f.Descrip, f.Obs, f.IB_Prin
from Formula f inner join Producto2 p on (f.RucE=p.RucE and f.Cd_Prod=p.Cd_Prod)
where f.RucE=@RucE and f.Estado=1 and f.Cd_Prod=@Cd_Prod and f.ID_UMP = @ID_UMP
end
print @msj

GO
