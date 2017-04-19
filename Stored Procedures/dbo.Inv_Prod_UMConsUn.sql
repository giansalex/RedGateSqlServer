SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Prod_UMConsUn]
@RucE nvarchar(11),
@Cd_Prod char(10),
@ID_UMP int,
@msj varchar(100) output
as
if not exists (select * from Prod_UM where RucE=@RucE and Cd_Prod=@Cd_Prod and Id_UMP=@Id_UMP)
	set @msj = 'Producto por Unidad de Medida no existe'
else	select * from Prod_UM where RucE=@RucE and Cd_Prod=@Cd_Prod and Id_UMP=@Id_UMP
print @msj

-- Leyenda --
-- FL : 2011-02-22 : <Creacion del procedimiento almacenado>

GO
