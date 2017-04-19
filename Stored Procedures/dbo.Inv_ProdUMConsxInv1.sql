SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_ProdUMConsxInv1]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as
select distinct T1.ID_UMP, T1.DescripAlt, T1.Nombre, T1.NCorto,T1.PesoKg from (select PUM.PesoKg,PUM.RucE,PUM.Cd_Prod,PUM.ID_UMP,PUM.descripAlt,UM.Nombre,UM.NCorto from Prod_UM PUM
inner join UnidadMedida as UM on PUM.Cd_UM = UM.Cd_UM and UM.Estado= 1 and Cd_Prod=@Cd_Prod and RucE=@RucE) as T1
print @msj
-- Leyenda --
-- FL : 2010-08-27 : <Creacion del procedimiento almacenado>
GO
