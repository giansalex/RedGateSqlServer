SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_OrdProdConsProdxIBFormula]
@RucE nvarchar(11),
@ID_Fmla int,
@msj varchar(100) output
as
if not exists (select * from FormulaDet where RucE = @RucE and ID_Fmla = @ID_Fmla)
	set @msj = 'La formula no tiene detalle'
else
begin
select P.Cd_Prod, Case when P.CodCo1_ is null then '' else P.CodCo1_ end as CodComercial,
P.Nombre1 as Producto, PUM.Id_UMP, U.NCorto as UndMed, dbo.CostSal2(@RucE,F.Cd_Prod, F.ID_UMP, getdate(), '01') as Cost, dbo.CostSal2(@RucE,F.Cd_Prod, F.ID_UMP, getdate(), '02') as Cost_ME, convert(numeric(16,2),F.Cant) as Cant, Cd_Cos from FormulaDet as F
inner join Producto2 as P on F.RucE = P.RucE and F.Cd_Prod = P.Cd_Prod
inner join Prod_UM  as PUM on PUM.RucE = F.RucE and PUM.Cd_Prod = F.Cd_Prod and PUM.ID_UMP = F.ID_UMP
inner join UnidadMedida as U on U.Cd_UM = PUM.Cd_UM
where F.RucE = @RucE and ID_Fmla = @ID_Fmla
end
print @msj
-- Leyenda --
-- FL : 2011-02-19 : <creacion del procedimiento almacenado>
-- PP : 2011-02-21 : <modificacion recreacion  del procedimiento almacenado>

-- exec Prd_OrdProdConsProdxIBFormula '11111111111','89',null

GO
