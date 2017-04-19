SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_EnvEmbOFElim]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from EnvEmbOF where RucE=@RucE and Cd_OF=@Cd_OF)
	set @msj = 'Env. y Emb. de la Orden de Fabricacion No Existe'
else
begin
	delete from EnvEmbOF where RucE=@RucE and Cd_OF=@Cd_OF
	if @@rowcount <= 0
		set @msj = 'Env. y Emb. de la Orden de Fabricacion no pudo ser eliminada'
end
print @msj

-- Leyenda --
-- FL : 2011-03-09 : <Creacion del procedimiento almacenado>
GO
