SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paIP]
@RucE nvarchar(11),
@Cd_Com nvarchar(10),
@msj varchar(100) output
as
	select 
	c.Item as Nro, c.Cd_Prod,P.Nombre1,P.Descrip,UMP.ID_UMP,UM.Nombre,UMP.DescripAlt,c.Cant as sVCant, 
	ABS(isnull((select sum(i.Cant) from ImportacionDet i where i.RucE = c.RucE and i.Cd_Com = c.Cd_Com and i.ItemCP = c.Item),0 ))as Cant_Ing,
	c.cant - ABS(isnull((
	select sum(i.Cant) from ImportacionDet i 
	left join CompraDet as det on det.RucE =i.RucE and det.Cd_Com = i.Cd_Com
	where i.RucE = @RucE and i.Cd_Com = @Cd_Com and i.ItemCP = det.Item and i.ItemCP = c.Item
	),0 ))as Pendiente,
	IMP as Costo, UMP.PesoKg, UMP.Volumen
	from CompraDet c 
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
	where c.RucE = @RucE and c.Cd_Com = @Cd_Com and c.Cd_Prod is not null

	--set @msj = 'Funcion en construccion. Falta Probar'
		
-- Leyenda --
-- Epsilower : 21/09/2011 : <Creacion del procedimiento almacenado>
GO
