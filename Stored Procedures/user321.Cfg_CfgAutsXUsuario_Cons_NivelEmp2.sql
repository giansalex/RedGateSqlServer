SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
create procedure [user321].[Cfg_CfgAutsXUsuario_Cons_NivelEmp2]
@RucE nvarchar(11),
@Id_Niv int,
@NomUsu nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from Empresa where Ruc = @RucE)
	set @msj = 'No existe la empresa' + @RucE
else
begin
	/*
	select b.NomUsu, UPPER(b.NomComp) as 'NomComp',
	case(isnull(a.NomUsu,'')) when '' then Convert(bit,0) else Convert(bit,1) end as 'Hab'	
	from cfgAutsXUsuario a
		right join Usuario b on a.NomUsu = b.NomUsu and a.Id_Niv = @Id_Niv
		join Perfil c on b.Cd_Prf = c.Cd_Prf
		join AccesoE d on d.Cd_Prf = c.Cd_Prf
	where d.RucE = @RucE
	*/
	declare @nivel nvarchar(11)
	select @nivel = Nivel
	from Usuario
	where NomUsu = @NomUsu
		
	--print @nivel

	select Usuarios.Nomusu, UPPER(Usuarios.NomComp) as 'NomComp' ,
		case(isnull(a.NomUsu,'')) when '' then Convert(bit,0) else Convert(bit,1) end as 'Hab'
	from CfgNivelAut b
	join CfgAutsXUsuario a on a.Id_Niv = b.Id_Niv and b.Id_Aut = (select Id_Aut from CfgNivelAut where Id_Niv = @Id_Niv)
	right join(
		select NomUsu, NomComp from Usuario b 
		join AccesoE d on d.Cd_Prf = b.Cd_Prf
		where d.RucE = @RucE and b.Estado = 1 and b.Nivel like '' + @nivel + '%'
		group by Nomusu, NomComp
	) Usuarios 
	
	on a.NomUsu = Usuarios.Nomusu
	where b.Id_Niv = @Id_Niv or b.Id_Niv is null
end
-- Leyenda --
-- MM : 2010-01-06    : <Creacion del procedimiento almacenado>
-- MM : 2010-01-07    : <Modificacion del procedimiento almacenado>
-- MP : 2012-10-10	:	<Modificacion del procedimiento almacenado>
--<Pruebas> user321.Cfg_CfgAutsXUsuario_Cons_NivelEmp '22222222222', 214,null

/*
select * from Usuario
select * from CfgNivelAut
select * from CfgAutsXUsuario
select * from Empresa
*/
GO
