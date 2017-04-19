SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_AnexoElim]
@RucE nvarchar(11),
@Cd_Ctt int,
@Cd_Anx int,
@msj varchar(100) output
as
begin 
	Delete From Anexo Where RucE=@RucE and Cd_Ctt=@Cd_Ctt and Cd_Anx=@Cd_Anx
	if @@rowcount <= 0
		Set @msj = 'Error al eliminar Anexo'
end
-- Leyenda --
-- CAM 31/10/2011 <Creacion del procedimiento>

GO
