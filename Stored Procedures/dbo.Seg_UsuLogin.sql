SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuLogin]
@NomUsu nvarchar(10),
@Pass nvarchar(50),
@msj varchar(100)output
as
set @msj=''
if not exists (select * from Usuario where NomUsu=@NomUsu)
   set @msj = 'Usuario no existe'
else if not exists (select * from Usuario where NomUsu=@NomUsu and Pass=@Pass)
	set @msj = 'Password incorrecto'
     else if not exists (select * from Usuario where NomUsu=@NomUsu and Pass=@Pass and Estado=1)
	     set @msj = 'Usuario deshabilitado'
print @msj
-- NO COLOCAR NOMBRES DE USUARIO

GO
