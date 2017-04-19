SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paGRVta2]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
select 
	c.Nro_RegVdt as Nro, c.Cd_Prod,P.Nombre1,P.Descrip,UMP.ID_UMP,UM.Nombre, UMP.DescripAlt,c.Cant as sVCant, 
	ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Cant_Ing,
	c.cant - ABS(isnull((select sum(i.Cant) from GuiaRemisionDet i where i.RucE = c.RucE and i.Cd_Vta = c.Cd_Vta and i.Cd_Prod=c.Cd_Prod and i.Item = c.Nro_RegVdt),0 ))as Pendiente,
	PU as Costo
	from VentaDet c 
	left join Venta as V on V.RucE =c.RucE and V.Cd_Vta = c.Cd_Vta   
	left join Producto2 as P on P.RucE = c.RucE and P.Cd_Prod = c.Cd_Prod  
	left join Prod_UM as UMP on UMP.RucE = c.RucE and UMP.Cd_Prod = c.Cd_Prod and UMP.ID_UMP = c.ID_UMP
	left join UnidadMedida as UM  on UM.Cd_UM = UMP.Cd_UM
	--left join GuiaRemisionDet as GRD on GRD.RucE= c.RucE and GRD.Cd_Vta=c.Cd_Vta and GRD.Cd_Prod=c.Cd_Prod and GRD.ID_UMP=c.ID_UMP  and c.Nro_RegVdt = ItemPd
	where c.RucE = @RucE and c.Cd_Vta = @Cd_Vta and c.Cd_Prod is not null
print @msj

-- Leyenda --
-- CAM : 14/12/2010 : <Creacion del procedimiento almacenado>
-- exec Inv_Producto2Cons_paGRVta2 '11111111111','VT00000386',''
GO
