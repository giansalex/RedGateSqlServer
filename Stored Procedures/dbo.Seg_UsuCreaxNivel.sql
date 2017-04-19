SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuCreaxNivel]
@NomUsu	nvarchar(10),
@NomUsuCrea	nvarchar(10),
@Pass	nvarchar(50),
@NomComp varchar(50),
@Cd_Trab nvarchar(15),
@Cd_Prf	nvarchar(3),
--@Estado	bit
@msj varchar(100) output
as
if exists (select * from Usuario where NomUsu=@NomUsu)
   set @msj = 'Usuario ya existe'
else
begin
    insert into Usuario(NomUsu,Pass,NomComp,Cd_Trab,Cd_Prf,Nivel,Estado)
	        values (@NomUsu,@Pass,@NomComp,@Cd_Trab,@Cd_Prf,
			dbo.Asigna_NivelxUsuario(@NomUsuCrea),1)
    if @@rowcount<=0
       set @msj = 'Usuario no pudo ser creado'
end
print @msj
--select * from Usuario
--print dbo.Asigna_NivelxUsuario('A.CARLOS')

--MP : 2011/06/01 : <Modificacion del procedimiento almacenado>
--print dbo.Asigna_NivelxUsuario('admin.nefu')
--select * from Usuario where NomUsu = 'admin.nefu'
GO
