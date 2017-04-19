SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Cfg_CfgAutsXUsuario_Cons_Nivel]
@RucE nvarchar(11),
@Id_Niv int,
@msj varchar(100) output
as
	if not exists (select * from Empresa where Ruc = @RucE)
		set @msj = 'No existe la empresa' + @RucE
	else
	begin
		select b.NomUsu, UPPER(b.NomComp) as 'NomComp'
		from cfgAutsXUsuario a
			join Usuario b on a.NomUsu = b.NomUsu and a.Id_Niv = @Id_Niv
			join Perfil c on b.Cd_Prf = c.Cd_Prf
			join AccesoE d on d.Cd_Prf = c.Cd_Prf
		where d.RucE = @RucE
		group by b.NomUsu, b.NomComp
	end
-- Leyenda --
-- MM : 2010-01-06    : <Creacion del procedimiento almacenado>
--<Prueba> Cfg_CfgAutsXUsuario_Cons_Nivel '11111111111', 1, null
GO
