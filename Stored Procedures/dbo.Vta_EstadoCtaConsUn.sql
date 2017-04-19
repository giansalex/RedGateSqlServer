SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Vta_EstadoCtaConsUn]
@RucE nvarchar(11),
@Cd_EC int,
@msj varchar(100) output
as

if not exists (select * from EstadoCta where RucE = @RucE and Cd_EC=@Cd_EC)
	set @msj = 'Estado de Cta. no existe'
else	
	select * from EstadoCta where RucE = @RucE and Cd_EC= @Cd_EC
print @msj


--MP : 25/05/2011 : <Creacion del procedimiento almacenado>

GO
