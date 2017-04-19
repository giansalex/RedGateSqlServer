SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoEElim_F]  --Procedimiento Final
@Cd_Prf nvarchar(3),
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from Perfil where Cd_Prf=@Cd_Prf)
begin
	Set @msj = 'Perfil no existe'
	return
end
if not exists (select * from AccesoE where Cd_Prf=@Cd_Prf and RucE=@RucE)
	return
else
begin
	delete from AccesoE where Cd_Prf=@Cd_Prf and RucE=@RucE

	if @@rowcount <= 0
		Set @msj = 'Acceso a empresa no puedo ser eliminado'
end

-- Leyenda --
-------------
-- DI 18/09/2009 : Creacion del procedimiento almacenado
GO
