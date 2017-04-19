SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoPermisosCrea]
@Cd_GP int output,
@Descrip varchar(100),
@msj varchar(100) output
as

if exists (select * from GrupoPermisos where Descrip = @Descrip)
	Set @msj = 'Existe un registro con la misma descripcion'
else
begin
	Set @Cd_GP = (select Max(isnull(Cd_GP,0))+1 from GrupoPermisos)	
	insert into GrupoPermisos(Cd_GP,Descrip,Estado)
	values(@Cd_GP,@Descrip,1)
	
	if @@rowcount <= 0
	begin
		Set @msj = 'Grupo de permisos no pudo ser creado'
	end
end
print @msj

-- Leyenda --
-------------

-- FL : 17/06/2011 Creacion del procedimiento almacenado

GO
