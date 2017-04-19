SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2ConsUn_X_CA_CASAMARILLA]
@RucE nvarchar(11),
@Dato varchar(100),
@msj varchar(100) output
as

/*
DECLARE @RucE nvarchar(11)
DECLARE @Dato nvarchar(100)
DECLARE @msj varchar(100)
SET @RucE='20507826467'
SET @Dato='HOLGADOGABRIEL'
*/

if not exists (select * from Cliente2 where RucE=@RucE and (CA01=@Dato or CA04=@Dato or CA07=@Dato))
	set @msj = 'Cliente no existe'
else	select * from Cliente2  where RucE=@RucE and (CA01=@Dato or CA04=@Dato or CA07=@Dato)
print @msj

-- Leyenda --
-- DI : 15/04/2011 <Se credo procedimiento almacenado para la empresa CASA AMARILLA>
--		   <Se consultara la informacion del cliente o Padre a travez del codigo del hijo (Dato)>

GO
