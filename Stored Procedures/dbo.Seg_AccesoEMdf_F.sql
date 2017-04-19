SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoEMdf_F]
@Cd_Prf nvarchar(3),
@RucE nvarchar(11),
@Cd_GA int,
@msj varchar(100) output
as
begin
	Update AccesoE Set Cd_GA=@Cd_GA 
	Where Cd_Prf=@Cd_Prf and RucE=@RucE

	if @@rowcount <= 0
	begin
		Set @msj = 'Error al modificar la asignacion de accesos'
	end
end

-- Leyenda --
-------------

-- DI 21/09/2009 : Creacion del procedimiento almacenado
GO
