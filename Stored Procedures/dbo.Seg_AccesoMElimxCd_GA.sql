SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoMElimxCd_GA]
@Cd_GA int,
@msj varchar(100) output
as

begin transaction
if exists (select * from AccesoM where Cd_GA=@Cd_GA)
begin
	delete from AccesoM
	where Cd_GA = @Cd_GA
	
	if @@rowcount <= 0
	begin
		set @msj = 'Error al eliminar accesos'
		rollback transaction
		return
	end
end
commit transaction

--Leyenda--

--MP : 01/04/2011 : <Creacion del procedimiento almacenado>
/*
select * from GrupoAcceso
select * from AccesoM where Cd_Ga = 112
exec dbo.Seg_AccesoMElimxCd_GA 112, null
*/
GO
