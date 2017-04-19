SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoAccCreaxNivel]
@Cd_GA int output,
@Descrip varchar(100),
@NomUsu nvarchar(20),
@msj varchar(100) output
as

if exists (select * from GrupoAcceso where Descrip = @Descrip)
	Set @msj = 'Existe un reguistro con la misma descripcion'
else
begin
	declare @nivel nvarchar(100)
	select @nivel = Nivel
	from Usuario
	where NomUsu = @NomUsu
	
	Set @Cd_GA = (select Max(isnull(Cd_GA,0))+1 from GrupoAcceso)	
	insert into GrupoAcceso(Cd_GA,Descrip,NivUsuCrea,Estado)
	values(@Cd_GA,@Descrip,@nivel,1)
	
	if @@rowcount <= 0
	begin
		Set @msj = 'Grupo de acceso no pudo ser creado'
	end
end
print @msj

-- Leyenda --
-------------

-- DI : 25/09/2009 Creacion del procedimiento almacenado

GO
