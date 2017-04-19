SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2ConsUn_X_CA_CASAMARILLA2]
@RucE nvarchar(11),
@NDoc varchar(15),
@msj varchar(100) output
as

/*
DECLARE @RucE nvarchar(11)
DECLARE @Dato nvarchar(100)
DECLARE @msj varchar(100)
SET @RucE='20507826467'
SET @Dato='HOLGADOGABRIEL'
*/

if not exists (select * from Cliente2 where RucE=@RucE and NDoc=NDoc)
	set @msj = 'Cliente no existe'
else	select * from Cliente2  where RucE=@RucE and NDoc=@NDoc
print @msj

-- Leyenda --
-- DI : 21/10/2012 <Se credo procedimiento almacenado para la empresa CASA AMARILLA>

GO
