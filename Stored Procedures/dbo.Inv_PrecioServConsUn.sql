SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioServConsUn]
@RucE nvarchar(11),
@ID_PrSv int,
@msj varchar(100) output
as
if not exists (select * from PrecioSrv where RucE=@RucE and ID_PrSv = @ID_PrSv)
	set @msj = 'Precio del Servicio no existe'
else	select * from PrecioSrv where RucE=@RucE and ID_PrSv = @ID_PrSv
print @msj

-- Leyenda --
--J -> 19/03/2010 -> CREACION
GO
