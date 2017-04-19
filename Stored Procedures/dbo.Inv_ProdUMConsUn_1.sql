SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_ProdUMConsUn_1]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Id_UMP int,
@msj varchar(100) output
as
if not exists (select * from Prod_UM where RucE=@RucE and Cd_Prod = @Cd_Prod and Id_UMP=@Id_UMP)
	set @msj = 'Unidad de Medida x Producto no existe'
else	select * from Prod_UM where RucE=@RucE and Cd_Prod = @Cd_Prod and Id_UMP=@Id_UMP
print @msj

-- Leyenda --
-- PP : 2010-02-24 : <Creacion del procedimiento almacenado>

-- exec Inv_ProdUMConsUn '11111111111','1',''
GO
