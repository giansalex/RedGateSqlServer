SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Cfg_CfgAutsXUsuario_Cons_NivelEmp]
@RucE nvarchar(11),
@Id_Niv int,
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
--PARA SALIR DE APURO> SE VERA LUEGO
if(@RucE = '11111111111')
begin
		select Usuarios.Nomusu, UPPER(Usuarios.NomComp) as 'NomComp' ,
			case(isnull(a.NomUsu,'')) when '' then Convert(bit,0) else Convert(bit,1) end as 'Hab'
		from CfgNivelAut b
		join CfgAutsXUsuario a on a.Id_Niv = b.Id_Niv and b.Id_Aut = (select Id_Aut from CfgNivelAut where Id_Niv = @Id_Niv)
		right join(
			select NomUsu, NomComp from Usuario b 
			join Perfil c on b.Cd_Prf = c.Cd_Prf
			join AccesoE d on d.Cd_Prf = c.Cd_Prf
			where d.RucE = @RucE and b.Estado = 1
			group by Nomusu, NomComp
		) Usuarios 
		
		on a.NomUsu = Usuarios.Nomusu
		where b.Id_Niv = @Id_Niv or b.Id_Niv is null
end
else
begin
		select Usuarios.Nomusu, UPPER(Usuarios.NomComp) as 'NomComp' ,
			case(isnull(a.NomUsu,'')) when '' then Convert(bit,0) else Convert(bit,1) end as 'Hab'
		from CfgNivelAut b
		join CfgAutsXUsuario a on a.Id_Niv = b.Id_Niv and b.Id_Aut = (select Id_Aut from CfgNivelAut where Id_Niv = @Id_Niv)
		right join(
			select NomUsu, NomComp from Usuario b 
			join Perfil c on b.Cd_Prf = c.Cd_Prf
			join AccesoE d on d.Cd_Prf = c.Cd_Prf
			where d.RucE = @RucE and d.Cd_Prf != '001' --Por el momento
			group by NomUsu, NomComp
		) Usuarios 
		
		on a.NomUsu = Usuarios.Nomusu
		where b.Id_Niv = @Id_Niv or b.Id_Niv is null
end
end
-- Leyenda --
-- MM : 2010-01-06    : <Creacion del procedimiento almacenado>
-- MM : 2010-01-07    : <Modificacion del procedimiento almacenado>

--<Pruebas> Cfg_ConsultarUsu_Cons_PorRucE '11111111111', 1,null


/*
select Usuarios.Nomusu, UPPER(Usuarios.NomComp) as 'NomComp' ,
case(isnull(a.NomUsu,'')) when '' then Convert(bit,0) else Convert(bit,1) end as 'Hab'
from CfgNivelAut b
join CfgAutsXUsuario a on a.Id_Niv = b.Id_Niv 
and 
b.Id_Aut = (select Id_Aut from CfgNivelAut where Id_Niv = 68)
right join(
select NomUsu, NomComp from Usuario b 
join Perfil c on b.Cd_Prf = c.Cd_Prf
join AccesoE d on d.Cd_Prf = c.Cd_Prf
where d.RucE = '20464722841' and b.Estado = 1--d.Cd_Prf != '001'
group by NomUsu, NomComp
) Usuarios 
on a.NomUsu = Usuarios.Nomusu
where b.Id_Niv = 68 or b.Id_Niv is null


select * from Usuario
select * from CfgNivelAut
select * from CfgAutsXUsuario
*/
GO
