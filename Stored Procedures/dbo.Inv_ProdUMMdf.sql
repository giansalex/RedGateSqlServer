SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMMdf]
@RucE nvarchar(11),
@Id_UMP int,
@DescripAlt varchar(100),
@Factor numeric(13,3),
@msj varchar(100) output
as

if not exists (select * from Prod_UM where Id_UMP=@Id_UMP)
	set @msj = 'Unidad de Medida x Producto no existe'
else
begin
	update Prod_UM set DescripAlt=@DescripAlt, Factor=@Factor
	where RucE=@RucE and Id_UMP=@Id_UMP
	
	if @@rowcount <= 0
	   set @msj = 'Producto por Unidad de Medida no pudo ser modificada'
end
print @msj


-- Leyenda --
-- PP : 2010-02-24 : <Creacion del procedimiento almacenado>
GO
