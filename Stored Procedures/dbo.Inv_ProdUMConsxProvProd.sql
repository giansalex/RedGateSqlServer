SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMConsxProvProd]
--Consulta todos los productos que no tiene el proveedor--
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Prv char(7),
@msj varchar(100) output
as
select T1.ID_UMP, T1.DescripAlt, T1.Nombre, T1.NCorto from (select PUM.RucE,PUM.Cd_Prod,PUM.ID_UMP,PUM.descripAlt,UM.Nombre,UM.NCorto from Prod_UM PUM
inner join UnidadMedida as UM on PUM.Cd_UM = UM.Cd_UM and UM.Estado= 1 and Cd_Prod=@Cd_Prod and RucE=@RucE) as T1
left join (select RucE,Cd_Prv,Cd_Prod,ID_UMP from ProdProv where RucE=@RucE and Cd_Prod=@Cd_Prod and Cd_Prv=@Cd_Prv) as T2
on T1.RucE=T2.RucE and T1.Cd_Prod=T2.Cd_Prod and T1.ID_UMP=T2.ID_UMP
where T2.ID_UMP is null
print @msj
-- Leyenda --
-- FL : 2010-08-13 : <Creacion del procedimiento almacenado>
-- FL : 2010-08-16 : <Modificacion del procedimiento almacenado>
GO
