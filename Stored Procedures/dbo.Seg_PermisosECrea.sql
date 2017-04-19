SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermisosECrea]
@Cd_Prf nvarchar(3),
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from Perfil where Cd_Prf=@Cd_Prf)
begin
	Set @msj = 'Perfil no existe'
	return
end
if exists (select * from PermisosE where Cd_Prf=@Cd_Prf and RucE=@RucE)
	return
else
begin
	insert into PermisosE(Cd_Prf,RucE,Cd_GP)
		Values(@Cd_Prf,@RucE,1)
	
	if @@rowcount <= 0
		Set @msj = 'Acceso a empresa no puedo ser creado'
end
GO
