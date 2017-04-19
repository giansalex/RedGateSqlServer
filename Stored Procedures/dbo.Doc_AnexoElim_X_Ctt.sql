SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_AnexoElim_X_Ctt]
@RucE nvarchar(11),
@Cd_Ctt int,
@msj varchar(100) output
as
begin 
	if exists (Select * From Anexo Where RucE=@RucE and Cd_Ctt=@Cd_Ctt)
	Begin
		Delete From Anexo Where RucE=@RucE and Cd_Ctt=@Cd_Ctt
		if @@rowcount <= 0
			Set @msj = 'Error al eliminar los Anexos del contrato '+convert(varchar,@Cd_Ctt)
	end
end
-- Leyenda --
-- CAM 31/10/2011 <Creacion del procedimiento>

GO
