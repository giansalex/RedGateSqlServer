SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [user321].[Cfg_CfgAutorizacion_Elim]
@Id_Aut int,
@msj varchar(100) output
as
begin transaction
	if not exists (select * from CfgAutorizacion where Id_Aut = @Id_Aut)
		set @msj = 'No existe la autorizacion'
	else
	begin
		if exists (select * from CfgNivelAut where Id_Aut = @Id_Aut)
		begin
			delete from CfgNivelAut where Id_Aut = @Id_Aut
			if @@rowcount <=0
			begin
				set @msj = 'Error al eliminar los niveles de la autorizacion'
				rollback transaction
				return	
			end
		end
		delete from CfgAutorizacion where Id_Aut = @Id_Aut
		if @@rowcount <=0
		begin
			set @msj =  'Error al eliminar los niveles de la autorizacion'
			rollback transaction
			return
		end
	end
commit transaction

-- Leyenda --
-- MM : 2010-01-05    : <Creacion del procedimiento almacenado>
GO
