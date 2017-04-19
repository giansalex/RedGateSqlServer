SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paGRV_2]
@RucE nvarchar(11),
@Codigo nvarchar(10),
@Cd_TDES nchar(2),
@msj varchar(100) output
as
if(@Cd_TDES = 'VT')
begin
	select 
	c.Nro_RegVdt as Nro, c.Cd_Prod,P.Nombre1,P.Descrip,UMP.ID_UMP,UM.Nombre,UMP.DescripAlt,c.Cant as sVCant, 
	ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Cant_Ing,
	c.cant - ABS(isnull((
	select sum(i.Cant) from GuiaRemisionDet i 
	left join VentaDet as det on det.RucE =i.RucE and det.Cd_Vta = i.Cd_Vta
	where i.RucE = @RucE and i.Cd_Vta = @Codigo and i.Cd_Prod=c.Cd_Prod and i.Item = det.Nro_RegVdt
	),0 ))as Pendiente,
	PU as Costo, UMP.PesoKg, Convert(bit,0) as [Check]
	from VentaDet c 
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
	where c.RucE = @RucE and c.Cd_Vta = @Codigo and c.Cd_Prod is not null

end
else if(@Cd_TDES = 'CP')
begin
	select 
	c.Item as Nro, c.Cd_Prod,P.Nombre1,P.Descrip,UMP.ID_UMP,UM.Nombre,UMP.DescripAlt,c.Cant as sVCant, 
	ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Com = c.Cd_Com and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 ))as Cant_Ing,
	c.cant - ABS(isnull((
	select sum(i.Cant) from GuiaRemisionDet i 
	left join CompraDet as det on det.RucE =i.RucE and det.Cd_Com = i.Cd_Com
	where i.RucE = @RucE and i.Cd_Com = @Codigo and i.Cd_Prod=c.Cd_Prod and i.Item = det.Item
	),0 ))as Pendiente,
	PU as Costo, UMP.PesoKg, Convert(bit,0) as [Check]
	from CompraDet c 
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
	where c.RucE = @RucE and c.Cd_Com = @Codigo and c.Cd_Prod is not null

	--set @msj = 'Funcion en construccion. Falta Probar'
end
-- Leyenda --
-- CAM : 30/12/2010 : <Creacion del procedimiento almacenado>
-- exec Inv_Producto2Cons_paGRV_2 '11111111111','VT00000415','VT',''
-- exec Inv_Producto2Cons_paGRV_2 '11111111111','CM00000013','CP',''
--MP: 13/04/2012 : <Se agrego la columna check>
GO
