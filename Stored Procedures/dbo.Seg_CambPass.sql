SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_CambPass]
@NomUsu	nvarchar(10),
@Pass	nvarchar(50),
@msj varchar(100) output
as
if not exists (select * from Usuario where NomUsu=@NomUsu)
   set @msj = 'Usuario no existe'
else
begin
   update Usuario set Pass=@Pass where NomUsu=@NomUsu

   if @@rowcount<=0
      set @msj = 'No se pudo modificar la contraseña'

end
print @msj
GO
