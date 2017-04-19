SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdComboElim]
@RucE nvarchar(11),
@Cd_ProdB char(7),
@Cd_ProdC char(7),
@Id_UMP int,

@msj varchar(100) output
as
if not exists (select * from ProdCombo where RucE=@RucE and Cd_ProdB=@Cd_ProdB and Cd_ProdC=@Cd_ProdC and Id_UMP=@Id_UMP)
	set @msj = 'Componete no existe'
else
	delete from ProdCombo where RucE=@RucE and Cd_ProdB=@Cd_ProdB and Cd_ProdC=@Cd_ProdC and Id_UMP=@Id_UMP
	if @@rowcount <= 0	   set @msj = 'Proveedor no pudo ser eliminado'

print @msj
-- Leyenda --
-- PP : 2010-03-09 : <Creacion del procedimiento almacenado>
GO
