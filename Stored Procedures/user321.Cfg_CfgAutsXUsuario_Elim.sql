SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Cfg_CfgAutsXUsuario_Elim]
@Id_Niv int,
@NomUsu nvarchar(10),
@msj varchar(100) output
as
begin transaction
	if not exists (select * from CfgAutsXUsuario where Id_Niv = @Id_Niv)
		set @msj = 'No existe el nivel'
	else 	if not exists (select * from CfgAutsXUsuario where NomUsu = @NomUsu)	
			set @msj = 'No existe el usuario'	
		else
		begin			
			delete from CfgAutsXUsuario
			where Id_Niv = @Id_Niv and NomUsu = @NomUsu

			if @@rowcount <=0
			begin
				set @msj = 'No se pudo eliminar el usuario'
				rollback transaction
				return
			end			
		end	
commit transaction

-- Leyenda --
-- MM : 2010-01-07    : <Creacion del procedimiento almacenado>
GO
