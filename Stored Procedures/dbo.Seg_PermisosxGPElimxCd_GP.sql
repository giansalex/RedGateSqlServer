SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermisosxGPElimxCd_GP]
@Cd_Gp int,
@msj varchar(100) output
as

begin transaction
if exists (select * from PermisosxGP where Cd_Gp=@Cd_Gp)
begin
	delete from PermisosxGP
	where Cd_GP = @Cd_GP
	
	if @@rowcount <= 0
	begin
		set @msj = 'Error al eliminar permisos'
		rollback transaction
		return
	end
end
commit transaction

--Leyenda--

--FL : 17/06/2011 : <Creacion del procedimiento almacenado>
/*
select * from GrupoAcceso
select * from AccesoM where Cd_Ga = 112
exec dbo.Seg_AccesoMElimxCd_GA 112, null
*/
GO
