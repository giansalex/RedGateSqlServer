SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paGRV]
@RucE nvarchar(11),
@Codigo nvarchar(10),
@Cd_TDES nchar(2),
@msj varchar(100) output
as
/*
if(@Cd_TDES = 'VT')
begin
	select 
	c.Nro_RegVdt as Nro, c.Cd_Prod,P.Nombre1,P.Descrip,UMP.ID_UMP,UM.Nombre,UMP.DescripAlt,c.Cant as sVCant, 
	ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Cant_Ing,
	c.cant - ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Pendiente,
	PU as Costo, UMP.PesoKg
	from VentaDet c 
	left join Venta as V on V.RucE =c.RucE and V.Cd_Vta = c.Cd_Vta
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
	where c.RucE = @RucE and c.Cd_Vta = @Codigo and c.Cd_Prod is not null
end
else if(@Cd_TDES = 'CP')
begin
	select 
	c.item as Nro, c.Cd_Prod,P.Nombre1,P.Descrip,UMP.ID_UMP,UM.Nombre,UMP.DescripAlt,c.Cant as sVCant, 
	ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Com = c.Cd_Com and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Cant_Ing,
	c.cant - ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Com = c.Cd_Com and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Pendiente,
	PU as Costo, UMP.PesoKg
	from CompraDet c 
	left join Compra as V on V.RucE =c.RucE and V.Cd_Com = c.Cd_Com   
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
	where c.RucE = @RucE and c.Cd_Com = @Codigo and c.Cd_Prod is not null
end
*/
set @msj = 'Para Listar Productos debe actualizar el sistema'
-- Leyenda --
-- CAM : 14/12/2010 : <Creacion del procedimiento almacenado>
-- exec Inv_Producto2Cons_paGRV '11111111111','VT00000386','VT',''
-- exec Inv_Producto2Cons_paGRV '11111111111','CM00000087','CP',''
GO
