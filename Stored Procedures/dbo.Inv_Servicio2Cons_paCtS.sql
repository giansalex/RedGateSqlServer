SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Servicio2Cons_paCtS] --Para Cartera de Servicios
@RucE nvarchar(11),
@msj varchar(100) output
as

	select Cd_Srv as Codigo,Nombre
	from Servicio2 
	where RucE = @RucE
print @msj
-- Leyenda --
-- J : 2010-03-30 : <Creacion del procedimiento almacenado>

GO
