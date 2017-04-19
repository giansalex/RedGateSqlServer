SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoECrea_F]  --Procedimiento Final
@Cd_Prf nvarchar(3),
@RucE nvarchar(11),
@Cd_GA int,
@msj varchar(100) output
as
if not exists (select * from Perfil where Cd_Prf=@Cd_Prf)
begin
	Set @msj = 'Perfil no existe'
	return
end
if exists (select * from AccesoE where Cd_Prf=@Cd_Prf and RucE=@RucE and Cd_GA=@Cd_GA)
	return
else
begin
	insert into AccesoE(Cd_Prf,RucE,Cd_GA)
		Values(@Cd_Prf,@RucE,@Cd_GA)
	
	if @@rowcount <= 0
		Set @msj = 'Acceso a empresa no puedo ser creado'
end


--MP : 2011-03-30 : <Modificacion del procedimiento almacenado>

GO
