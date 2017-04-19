SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuElim]
@NomUsu	nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from Usuario where NomUsu=@NomUsu)
   set @msj = 'Usuario no existe'
else
begin
   delete Usuario where NomUsu=@NomUsu
   if @@rowcount<=0
      set @msj = 'Usuario no pudo ser eliminado'
end
print @msj
GO
