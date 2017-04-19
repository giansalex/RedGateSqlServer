SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMCrea]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_UM char(2),
@DescripAlt varchar(100),
@Factor numeric(13,3),
@PesoKg numeric(18,3),
@msj varchar(100) output
as

if exists (select * from Prod_UM where RucE = @RucE and Cd_Prod=@Cd_Prod and Cd_UM = @Cd_UM and Factor=@Factor)
	set @msj = 'Ya existe Producto y Unidad de medida con ese factor'
else
begin
	insert into Prod_UM(RucE,Cd_Prod,Id_UMP,Cd_UM,DescripAlt,Factor,PesoKg)
		    values(@RucE,@Cd_Prod,dbo.Id_UMP(@RucE,@Cd_Prod),@Cd_UM,@DescripAlt,@Factor,@PesoKg)
	
	if @@rowcount <= 0
	   set @msj = 'Producto por Unidad de Medida no pudo ser creada'
end
print @msj
--Leyenda--
-- FL: 13/09/2010 <Se modifico el sp, agregando el campo PesoKg>




GO
