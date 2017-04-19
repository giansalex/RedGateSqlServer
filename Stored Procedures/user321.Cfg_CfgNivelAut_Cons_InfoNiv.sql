SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [user321].[Cfg_CfgNivelAut_Cons_InfoNiv]
@Id_Aut int,
@msj varchar(100) output
as
	if not exists (select * from cfgAutorizacion where Id_Aut = @Id_Aut)
		set @msj = 'No existe autorizacion'
	else
	begin
		select 	b.Id_Niv, b.Niv, 'Nivel: ' + Convert(varchar,b.Niv) as 'Nivel', b.Descrip, 
			count(a.Id_Niv) as 'NroUsuarios', b.IB_Hab, b.IB_AutComNiv
		from cfgAutsXUsuario a right join cfgnivelaut b on a.Id_Niv = b.Id_Niv
		where Id_Aut = @Id_Aut
		group by a.Id_Niv, b.Id_Niv, b.Descrip, b.IB_Hab, b.Niv, b.IB_AutComNiv
	end

-- Leyenda --
-- MM : 2010-01-05    : <Creacion del procedimiento almacenado>
GO
