SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Cfg_CfgAutsXUsuario_Crea]
@Id_Niv int,
@NomUsu nvarchar(10),
@msj varchar(100) output
as
	if not exists (select * from CfgNivelAut where Id_Niv = @Id_Niv)
		set @msj = 'No existe el nivel'
	else	
	begin
		if not exists (select * from Usuario where NomUsu = @NomUsu)
			set @msj = 'No existe el usuario a ingresar'
		else
		begin
			insert into cfgAutsXUsuario (Id_Niv, NomUsu)
			values (@Id_Niv, @NomUsu)
			
			if @@rowcount <=0
				set @msj = 'No se pudo ingresar el usuario'
		end
	end
	
-- Leyenda --
-- MM : 2010-01-05    : <Creacion del procedimiento almacenado>
GO
