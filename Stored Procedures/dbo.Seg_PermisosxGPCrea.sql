SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermisosxGPCrea]
@Cd_GP int,
@Cd_Pm varchar(10),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from PermisosxGP where Cd_GP=@Cd_GP and Cd_Pm=@Cd_Pm)
	set @msj = 'Permiso ya existe'
else
begin
	insert into PermisosxGP(Cd_GP,Cd_Pm,Estado)
		     values(@Cd_GP,@Cd_Pm,1)

	if @@rowcount <= 0
           set @msj = 'Permiso no pudo ser registrado'
end
print @msj


GO
