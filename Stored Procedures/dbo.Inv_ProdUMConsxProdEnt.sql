SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMConsxProdEnt]
@RucE nvarchar(11),
@Cd_Prod char(7),
@FecMov datetime,
@msj varchar(100) output
as
select ID_UMP,UM.Cd_UM,descripAlt,Factor,Nombre,NCorto,Estado, isnull(dbo.CostEnt(@RucE,@Cd_Prod, ID_UMP, @FecMov),0.00) as Cost  from Prod_UM as PUM inner join UnidadMedida as UM on PUM.Cd_UM = UM.Cd_UM and UM.Estado= 1 and Cd_Prod=@Cd_Prod and RucE=@RucE
print @msj
-- Leyenda --
-- PP : 2010-07-20 10:37:18.180	 : <Creacion del procedimiento almacenado>
GO
