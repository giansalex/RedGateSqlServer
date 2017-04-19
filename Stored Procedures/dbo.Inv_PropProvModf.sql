SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PropProvModf] --<Procedimiento que modifica los datos de productosXproveedor>
@RucE nvarchar(11),
@Cd_Prod char(7),
@ID_UMP int,
@CodigoAlt varchar(50),
@DescripAlt varchar(50),
@Obs varchar(200),
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@msj varchar(100) output
as
if not exists(select * from ProdProv where RucE=@RucE and Cd_Prod=@Cd_Prod and ID_UMP=@ID_UMP)
	set @msj = 'Error en la seleccion Producto'
else
begin
	update ProdProv set CodigoAlt=@CodigoAlt,DescripAlt=@DescripAlt,Obs=@Obs,Estado=@Estado,CA01=@CA01,
			    CA02=@CA02,CA03=@CA03
	where RucE=@RucE and Cd_Prod=@Cd_Prod and ID_UMP=@ID_UMP

	if @@rowcount <= 0
	set @msj = 'Producto No Pudo Ser Actualizado'	
end
------------
--FL : 11-08-2010 - <creacion del procedimiento almacenado>
GO
