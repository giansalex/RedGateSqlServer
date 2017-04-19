SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuConsxNivel]
@NomUsu nvarchar(10),
@msj varchar(100) output
as
declare @nivel nvarchar(11)
select @nivel = Nivel
from Usuario
where NomUsu = @NomUsu
	
print @nivel
	
select usu.*, prf.NomP from Usuario usu
inner join Perfil prf on usu.Cd_Prf = prf.Cd_Prf
where Nivel like '' + @nivel + '%'

print @msj

GO
