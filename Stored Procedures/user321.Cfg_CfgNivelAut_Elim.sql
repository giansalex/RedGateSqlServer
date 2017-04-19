SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [user321].[Cfg_CfgNivelAut_Elim]
@Id_Niv int,
@msj varchar(100) output
as
begin transaction
	if not exists (select Id_Niv from CfgNivelAut where Id_Niv = @Id_Niv)
		set @msj = 'No existe el nivel'
	else
	begin
		if ((select count(*) from CfgAutsXUsuario where Id_Niv = @Id_Niv)>0)
		begin
			delete from CfgAutsXUsuario
			where Id_Niv = @Id_Niv
			if @@rowcount <=0
			begin
				set @msj = 'No se pudo eliminar los usuarios del nivel'
				rollback transaction
				return
			end
		end
		delete from CfgNivelAut
		where Id_Niv = @Id_Niv
		if @@rowcount <=0
		begin
			set @msj = 'No se pudo eliminar el nivel'
			rollback transaction
			return
		end
	end
commit transaction

-- Leyenda --
-- MM : 2010-01-06    : <Creacion del procedimiento almacenado>
-- MM : 2010-01-07    : <Modifcacion del procedimiento almacenado> Se agrego eliminacion de usuarios
GO
