SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paInvGR]
@RucE nvarchar(11),
@Cd_GR char(10),
@FecMov datetime,
@msj varchar(100) output
as
if not exists (select * from Inventario where Cd_GR = @Cd_GR)
begin
	select Guia.Item, Guia.Cd_Prod, Guia.Nombre1,Guia.Descrip,Guia.Nombre,Guia.ID_UMP, Guia.DescripAlt, Guia.ESCant, convert(numeric(13,3),0) as ICant, Guia.ESCant as Cant, Case(Guia.IC_ES) when 'S' then dbo.CostSal(@RucE,Guia.Cd_Prod,Guia.ID_UMP,@FecMov) else  dbo.CostEnt(@RucE,Guia.Cd_Prod,Guia.ID_UMP,@FecMov) end as Costo from (
	select P.Cd_Prod, P.Nombre1,P.Descrip,UM.Nombre, PU.ID_UMP, PU.DescripAlt, GRD.Cant as ESCant, GRD.Item as Item,  GR.IC_ES from Producto2 as P  	
		inner join Prod_UM as PU on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
		inner join UnidadMedida as UM  on UM.Cd_UM = PU.Cd_UM
		inner join GuiaRemisionDet as GRD on GRD.RucE = P.RucE and GRD.Cd_Prod = P.Cd_Prod and GRD.ID_UMP =PU.ID_UMP
		inner join GuiaRemision as GR on GR.RucE = GRD.RucE  and GR.Cd_GR  = GRD.Cd_GR
		where  GR.Cd_GR = @Cd_GR and GRD.RucE = @RucE) as Guia
end
print @msj

-- Leyenda --
-- PP : 2010-07-01 12:10:44.580	: <Creacion del procedimiento almacenado>
GO
