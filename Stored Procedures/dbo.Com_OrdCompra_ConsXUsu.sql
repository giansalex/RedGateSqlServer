SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompra_ConsXUsu]
@UsuModf nvarchar(10),
@Pass nvarchar(50),
@msj varchar(100) output
as
if not exists (select * from Usuario where NomUsu=@UsuModf)
	set @msj = 'Usuario no existe'
else if not exists(select * from Usuario where NomUsu=@UsuModf and Pass = @Pass )
	set @msj = 'Clave incorrecta'
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>

GO
