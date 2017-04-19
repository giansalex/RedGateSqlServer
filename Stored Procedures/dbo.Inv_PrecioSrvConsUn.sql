SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--------------------------------------------------------------------------------
CREATE procedure [dbo].[Inv_PrecioSrvConsUn]
@RucE nvarchar(11),
@Id_Gen int,
@msj varchar(100) output
as
if not exists (select * from PrecioSrv where RucE=@RucE and Id_Gen = @Id_Gen)
	set @msj = 'Precio de Servicio no existe'
else	select * from PrecioSrv where RucE=@RucE and Id_Gen = @Id_Gen
print @msj

-- Leyenda --
-- PP : 2010-03-04 : <Creacion del procedimiento almacenado>
GO
