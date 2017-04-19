SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuConsUn]
@NomUsu nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from Usuario where NomUsu=@NomUsu)
   set @msj = 'Usuario no existe'
else select * from Usuario where NomUsu=@NomUsu
print @msj
GO
