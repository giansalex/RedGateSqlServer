SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMModificar_2]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Id_UMP int,
@Cd_UM char(2),
@DescripAlt varchar(100),
@Factor numeric(13,3),
@PesoKg numeric(18,3),
@Volumen numeric(18,3),
@EstadoUMP bit,
@msj varchar(100) output
as

if not exists (select * from Prod_UM where RucE=@RucE and Cd_Prod=@Cd_Prod and Id_UMP=@Id_UMP)
      set @msj = 'Unidad de Medida x Producto no existe'
else
begin
      update Prod_UM set Cd_UM=@Cd_UM,DescripAlt=@DescripAlt,Factor=@Factor,PesoKg=@PesoKg, Volumen=@Volumen, EstadoUMP=@EstadoUMP
      where RucE=@RucE and Cd_Prod=@Cd_Prod and Id_UMP=@Id_UMP
      
      if @@rowcount <= 0
         set @msj = 'Producto por Unidad de Medida no pudo ser modificada'
end
print @msj


-- CE: crecion del sp -> se adiciono EstadoUMP 13/08/2012
GO
