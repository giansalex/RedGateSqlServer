SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermisosECrea_F]  --Procedimiento Final
@Cd_Prf nvarchar(3),
@RucE nvarchar(11),
@Cd_GP int,
@msj varchar(100) output
as
if not exists (select * from Perfil where Cd_Prf=@Cd_Prf)
begin
	Set @msj = 'Perfil no existe'
	return
end
if exists (select * from PermisosE where Cd_Prf=@Cd_Prf and RucE=@RucE and Cd_GP=@Cd_GP)
begin
	Set @msj = 'Permiso no existe'
	return
end
else
begin
	insert into PermisosE(Cd_Prf,RucE,Cd_GP)
		Values(@Cd_Prf,@RucE,@Cd_GP)
	
	if @@rowcount <= 0
		Set @msj = 'Acceso a empresa no puedo ser creado'
end


--FL : 2011-06-20 : <Creacion del procedimiento almacenado>

GO
